// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barcode_widget/barcode_widget.dart';
import 'package:cards_app/presentation/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cards_app/data/models/gift_card_model.dart';
import 'package:url_launcher/url_launcher.dart';

class GiftCardWidget extends StatefulWidget {
  final GiftCard giftCard;
  final int cardColor;
  final bool useWhiteIcons;
  const GiftCardWidget({
    Key? key,
    required this.giftCard,
    required this.cardColor,
    required this.useWhiteIcons,
  }) : super(key: key);

  @override
  State<GiftCardWidget> createState() => _GiftCardWidgetState();
}

class _GiftCardWidgetState extends State<GiftCardWidget> {
  void openWebPage(final url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  void _showModalBottomSheet(BuildContext context) {
    final _myTextFieldKey = GlobalKey<FormState>();
    final clipboardController = TextEditingController();
    Future<void> readFromClipboard() async {
      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data != null) {
        var text = data.text;
        if (text != null) {
          String outputString = text.replaceAll(RegExp(r'[^\d.,]+'), '');
          clipboardController.text = outputString;

          clipboardController.selection = TextSelection.fromPosition(
              TextPosition(offset: clipboardController.text.length));
        }
      }
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15.r)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10.h),
              Text(
                'Wprowadź nowe saldo',
                style: Theme.of(context).copyWith().textTheme.headline5,
              ),
              SizedBox(height: 15.h),
              Form(
                key: _myTextFieldKey,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d,\.]')),
                  ],
                  controller: clipboardController,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: false),
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                      child: Icon(Icons.content_paste_rounded),
                      onTap: () {
                        readFromClipboard();
                      },
                    ),
                    hintText: 'Wprowadź nowe saldo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Wprowadź kwotę';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Wprowadź poprawną kwotę';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_myTextFieldKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Confirm',
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180.h,
      child: Card(
        color: Color(widget.cardColor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.r))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("GiftCard",
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: widget.useWhiteIcons
                                ? Colors.white
                                : Colors.black)),
                    Text(
                      "Balance: ${widget.giftCard.balance} zł",
                      style: TextStyle(
                          color: widget.useWhiteIcons
                              ? Colors.white
                              : Colors.black),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () async {
                      await Clipboard.setData(
                          ClipboardData(text: widget.giftCard.number));
                      openWebPage(widget.giftCard.link);
                      Future.delayed(Duration(seconds: 1), () {
                        _showModalBottomSheet(context);
                      });
                    },
                    child: Text("Check balance",
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: widget.useWhiteIcons
                                ? Colors.white
                                : Colors.black)))
              ],
            ),
            SizedBox(height: 5.h),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.r))),
                  child: BarcodeWidget(
                      drawText: false,
                      data: widget.giftCard.number,
                      barcode: Barcode.code128(),
                      height: 80.h,
                      padding: EdgeInsets.all(12.w)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
