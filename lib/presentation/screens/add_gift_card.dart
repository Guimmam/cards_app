import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart' as code;
import 'package:cards_app/data/models/loyalty_card_model.dart';
import 'package:cards_app/presentation/screens/scan_code_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddGiftCard extends StatefulWidget {
  const AddGiftCard({Key? key}) : super(key: key);

  static String routeName = 'add_gift_card';

  @override
  State<AddGiftCard> createState() => _AddGiftCardState();
}

class _AddGiftCardState extends State<AddGiftCard> {
  final GlobalKey<FormState> _addNewCardFormKey = GlobalKey<FormState>();
  final companyNameController = TextEditingController();
  final companyNameFocusNode = FocusNode();
  final cardNameController = TextEditingController();
  final cardNameFocusNode = FocusNode();

  @override
  void dispose() {
    companyNameController.dispose();
    companyNameFocusNode.dispose();
    cardNameController.dispose();
    cardNameFocusNode.dispose();
    super.dispose();
  }

  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);
  String barcodeData = '';
  String barcodeFormat = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new card'),
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
                        controller: companyNameController,
                        focusNode: companyNameFocusNode,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          cardNameFocusNode.requestFocus();
                        },
                        decoration: const InputDecoration(
                            labelText: 'Company name', hintText: 'IKEA'),
                      ),
                      SizedBox(height: 15.h),
                      TextFormField(
                        validator: validateText,
                        controller: cardNameController,
                        focusNode: cardNameFocusNode,
                        decoration: const InputDecoration(
                            labelText: 'Card name', hintText: 'IKEA Family'),
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        currentColor)),
                            onPressed: () {
                              showColorPicker(context);
                            },
                            icon: Icon(Icons.color_lens,
                                color: useWhiteForeground(currentColor)
                                    ? Colors.white
                                    : Colors.black),
                            label: Text(
                              'Pick color',
                              style: TextStyle(
                                  color: useWhiteForeground(currentColor)
                                      ? Colors.white
                                      : Colors.black),
                            )),
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
                    onPressed: () {
                      if (_addNewCardFormKey.currentState!.validate()) {
                        if (barcodeData.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please scan barcode before you continue')));
                        } else {
                          var card = LoyaltyCard(
                              id: '0',
                              cardColor: currentColor.value,
                              cardNumber: barcodeData,
                              companyName: companyNameController.text,
                              cardName: cardNameController.text,
                              cardFormat: barcodeFormat);
                          createNewCard(card);
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: const Text('Create new Card'),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<dynamic> showColorPicker(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  bool useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {
    int v = sqrt(pow(backgroundColor.red, 2) * 0.299 +
            pow(backgroundColor.green, 2) * 0.587 +
            pow(backgroundColor.blue, 2) * 0.114)
        .round();
    return v < 130 + bias ? true : false;
  }
}

String? validateText(String? text) {
  if (text!.isEmpty) return 'This field cannot be empty';
  return null;
}

Future createNewCard(LoyaltyCard card) async {
  final String userUID = FirebaseAuth.instance.currentUser!.uid;
  final String? userEmail = FirebaseAuth.instance.currentUser!.email;
  final docUser = FirebaseFirestore.instance.collection('users').doc(userUID);

  final json = {
    'email': userEmail,
  };

  await docUser.set(json);
  final docCard = docUser.collection('cards').doc();

  final jsonCard = {
    'id': docCard.id,
    'cardName': card.cardName,
    'companyName': card.companyName,
    'cardColor': card.cardColor,
    'cardNumber': card.cardNumber,
    'cardFormat': card.cardFormat,
    'isSync': true,
  };

  await docCard.set(jsonCard);
}
