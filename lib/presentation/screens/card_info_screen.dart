import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cards_app/data/models/gift_card_model.dart';
import 'package:cards_app/data/models/loyalty_card_model.dart';
import 'package:cards_app/presentation/screens/add_gift_card.dart';
import 'package:cards_app/presentation/widgets/gift_card.dart';
import 'package:cards_app/presentation/widgets/loyalty_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowCardInfoScreen extends StatefulWidget {
  final LoyaltyCard card;
  const ShowCardInfoScreen({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  State<ShowCardInfoScreen> createState() => _ShowCardInfoScreenState();
}

class _ShowCardInfoScreenState extends State<ShowCardInfoScreen> {
  GiftCard? giftCard;

  @override
  void initState() {
    super.initState();
    fetchGiftCard(widget.card.id);
  }

  @override
  Widget build(BuildContext context) {
    bool useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {
      int v = sqrt(pow(backgroundColor.red, 2) * 0.299 +
              pow(backgroundColor.green, 2) * 0.587 +
              pow(backgroundColor.blue, 2) * 0.114)
          .round();
      return v < 130 + bias ? true : false;
    }

    bool useWhiteIcons = useWhiteForeground(Color(widget.card.cardColor));

    Widget buildCard() {
      if (giftCard != null) {
        return Column(
          children: [
            Text(giftCard!.id),
            Text(giftCard!.link),
            Text(giftCard!.balance.toString())
          ],
        );
      } else {
        return Container();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Card')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      LoyaltyCardWidget(
                          card: widget.card, useWhiteIcons: useWhiteIcons),
                      giftCard != null
                          ? GiftCardWidget(
                              cardColor: widget.card.cardColor,
                              giftCard: giftCard!,
                              useWhiteIcons: useWhiteIcons,
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                giftCard == null
                    ? SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                            style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.green),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.green.withOpacity(0.2)),
                            ),
                            onPressed: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddGiftCard(card: widget.card)));
                              if (result == true) {
                                giftCard = null;
                                await fetchGiftCard(widget.card.id);

                                setState(() {});
                              }
                            },
                            child: const Text('Add gift card')))
                    : Container(),
                SizedBox(height: 10.h),
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
                      await deleteCard(widget.card.id);
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

  Future fetchGiftCard(String id) async {
    final String userUID = FirebaseAuth.instance.currentUser!.uid;

    CollectionReference giftCardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('cards')
        .doc(id)
        .collection('giftCard');

    QuerySnapshot querySnapshot = await giftCardRef.limit(1).get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot cardSnapshot = querySnapshot.docs[0];

      Map<String, dynamic> cardData =
          cardSnapshot.data() as Map<String, dynamic>;

      setState(() {
        giftCard = GiftCard.fromMap(cardData);
      });
    }
  }
}
