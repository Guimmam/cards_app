import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLoyaltyCardScreen extends StatefulWidget {
  AddLoyaltyCardScreen({Key? key}) : super(key: key);

  static String routeName = 'add_loyalty_card_screen';

  @override
  State<AddLoyaltyCardScreen> createState() => _AddLoyaltyCardScreenState();
}

class _AddLoyaltyCardScreenState extends State<AddLoyaltyCardScreen> {
  final GlobalKey _addNewCardFormKey = GlobalKey();

  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new loyalty card'),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: SingleChildScrollView(
          child: Form(
            key: _addNewCardFormKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Company name', hintText: 'Biedronka'),
                ),
                SizedBox(height: 15.h),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Card name', hintText: 'Moja Biedronka'),
                ),
                SizedBox(height: 15.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(currentColor)),
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
              ],
            ),
          ),
        ),
      )),
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
