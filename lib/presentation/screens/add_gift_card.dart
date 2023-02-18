// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';
import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart' as code;
import 'package:cards_app/data/models/gift_card_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cards_app/data/models/loyalty_card_model.dart';
import 'package:cards_app/presentation/screens/scan_code_screen.dart';

class AddGiftCard extends StatefulWidget {
  final LoyaltyCard card;
  const AddGiftCard({
    Key? key,
    required this.card,
  }) : super(key: key);

  static String routeName = 'add_gift_card';

  @override
  State<AddGiftCard> createState() => _AddGiftCardState();
}

class _AddGiftCardState extends State<AddGiftCard> {
  final GlobalKey<FormState> _addNewCardFormKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final cardNumberFocusNode = FocusNode();
  final balanceController = TextEditingController();
  final balanceFocusNode = FocusNode();
  final linkController = TextEditingController();
  final linkFocusNode = FocusNode();

  @override
  void dispose() {
    cardNumberController.dispose();
    cardNumberFocusNode.dispose();
    balanceController.dispose();
    balanceFocusNode.dispose();
    linkController.dispose();
    linkFocusNode.dispose();
    super.dispose();
  }

  String barcodeData = '';
  String barcodeFormat = 'BarcodeFormat.code128';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add gift card to ${widget.card.companyName}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              Expanded(
                child: Form(
                  key: _addNewCardFormKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        validator: validateText,
                        autofocus: true,
                        controller: cardNumberController,
                        focusNode: cardNumberFocusNode,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            barcodeData = value;
                          });
                        },
                        onFieldSubmitted: (_) {
                          balanceFocusNode.requestFocus();
                        },
                        decoration: const InputDecoration(
                            labelText: 'Card Number', hintText: ''),
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        validator: validateText,
                        controller: balanceController,
                        focusNode: balanceFocusNode,
                        decoration: const InputDecoration(
                            labelText: 'Balance', hintText: ''),
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        validator: validateText,
                        controller: linkController,
                        focusNode: linkFocusNode,
                        decoration: const InputDecoration(
                            labelText: 'Link to check your balance ',
                            hintText: 'Optional'),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      if (barcodeData.isNotEmpty)
                        Column(
                          children: [
                            SizedBox(
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(15.r))),
                                child: code.BarcodeWidget(
                                    drawText: false,
                                    data: barcodeData,
                                    barcode:
                                        barcodeFormat != 'BarcodeFormat.code128'
                                            ? code.Barcode.qrCode()
                                            : code.Barcode.code128(),
                                    width: 240.w,
                                    height:
                                        barcodeFormat == 'BarcodeFormat.code128'
                                            ? 80.h
                                            : 200.h,
                                    padding: EdgeInsets.all(12.w)),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (barcodeFormat ==
                                          "BarcodeFormat.code128") {
                                        barcodeFormat = "BarcodeFormat.qrCode";
                                      } else {
                                        barcodeFormat = "BarcodeFormat.code128";
                                      }
                                    });
                                  },
                                  child: Text("Change code type")),
                            )
                          ],
                        ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          label: Text(
                              barcodeData.isEmpty ? 'Scan code' : 'Scan again'),
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () async {
                            await Navigator.of(context)
                                .pushNamed(ScanCodeScreen.routeName)
                                .then((value) {
                              Map<String, Object?> barcode = {};
                              barcode = value as Map<String, Object?>;

                              setState(() {
                                barcodeData = barcode['barcodeData'].toString();
                                cardNumberController.text = barcodeData;
                                barcodeFormat =
                                    barcode['barcodeFormat'].toString();
                              });
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 15.h)
                    ],
                  ),
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_addNewCardFormKey.currentState!.validate()) {
                        if (barcodeData.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please scan barcode before you continue')));
                        } else {
                          await createNewCard(
                              cardNumberController.text,
                              double.parse(balanceController.text),
                              linkController.text);
                          Navigator.pop(context, true);
                        }
                      }
                    },
                    child: const Text('Add Gift Card'),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  String? validateText(String? text) {
    if (text!.isEmpty) return 'This field cannot be empty';
    return null;
  }

  Future createNewCard(String number, double balance, String link) async {
    final String userUID = FirebaseAuth.instance.currentUser!.uid;
    final String? userEmail = FirebaseAuth.instance.currentUser!.email;
    final docUser = FirebaseFirestore.instance.collection('users').doc(userUID);

    final json = {
      'email': userEmail,
    };

    await docUser.set(json);
    final docCard = docUser
        .collection('cards')
        .doc(widget.card.id)
        .collection("giftCard")
        .doc();
    GiftCard card =
        GiftCard(id: docCard.id, number: number, balance: balance, link: link);

    await docCard.set(card.toMap());
  }
}
