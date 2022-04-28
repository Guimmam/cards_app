import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cards_app/data/models/loyalty_card_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowCardInfoScreen extends StatelessWidget {
  final LoyaltyCard card;
  const ShowCardInfoScreen({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {
      int v = sqrt(pow(backgroundColor.red, 2) * 0.299 +
              pow(backgroundColor.green, 2) * 0.587 +
              pow(backgroundColor.blue, 2) * 0.114)
          .round();
      return v < 130 + bias ? true : false;
    }

    bool useWhiteIcons = useWhiteForeground(Color(card.cardColor));

    return Scaffold(
      appBar: AppBar(title: const Text('Card')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: SizedBox(
                    height: card.cardFormat == 'BarcodeFormat.code128'
                        ? 180.h
                        : 310.h,
                    child: Card(
                      color: Color(card.cardColor),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.r))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(card.companyName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          ?.copyWith(
                                              color: useWhiteIcons
                                                  ? Colors.white
                                                  : Colors.black)),
                                  Icon(
                                    card.isSync
                                        ? Icons.cloud_done
                                        : Icons.cloud_off,
                                    color: useWhiteIcons
                                        ? Colors.white
                                        : Colors.black,
                                  )
                                ],
                              ),
                              Text(
                                card.cardName,
                                style: TextStyle(
                                    color: useWhiteIcons
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              SizedBox(height: 5.h),
                              Center(
                                child: SizedBox(
                                  width:
                                      card.cardFormat == 'BarcodeFormat.code128'
                                          ? double.infinity
                                          : 200.h,
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.r))),
                                    child: BarcodeWidget(
                                        drawText: false,
                                        data: card.cardNumber,
                                        barcode: card.cardFormat !=
                                                'BarcodeFormat.code128'
                                            ? Barcode.qrCode()
                                            : Barcode.code128(),
                                        height: card.cardFormat ==
                                                'BarcodeFormat.code128'
                                            ? 80.h
                                            : 200.h,
                                        padding: EdgeInsets.all(12.w)),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                      overlayColor: MaterialStateProperty.all(
                          Colors.red.withOpacity(0.2)),
                    ),
                    onPressed: () async {
                      _showConfirmationBottomSheet(context);
                    },
                    child: const Text('Delete card'))),
          ],
        ),
      ),
    );
  }

  void _showConfirmationBottomSheet(BuildContext context) =>
      showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
        context: context,
        builder: (context) => Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10.h),
              Text(
                'Are you sure?',
                style: Theme.of(context).copyWith().textTheme.headline5,
              ),
              SizedBox(height: 15.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No, I want to keep it')),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () async {
                      await deleteCard(card.id);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Yes, delete it')),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ),
        ),
      );

  Future deleteCard(String id) async {
    final String userUID = FirebaseAuth.instance.currentUser!.uid;

    final docCard = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('cards')
        .doc(id);
    docCard.delete();
  }
}
