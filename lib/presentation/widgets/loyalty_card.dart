import 'package:barcode_widget/barcode_widget.dart';
import 'package:cards_app/data/models/loyalty_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoyaltyCardWidget extends StatelessWidget {
  const LoyaltyCardWidget({
    Key? key,
    required this.card,
    required this.useWhiteIcons,
  }) : super(key: key);

  final LoyaltyCard card;
  final bool useWhiteIcons;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: card.cardFormat == 'BarcodeFormat.code128' ? 180.h : 310.h,
      child: Card(
        color: Color(card.cardColor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.r))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(card.companyName,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: useWhiteIcons ? Colors.white : Colors.black)),
                Icon(
                  card.isSync ? Icons.cloud_done : Icons.cloud_off,
                  color: useWhiteIcons ? Colors.white : Colors.black,
                )
              ],
            ),
            Text(
              card.cardName,
              style:
                  TextStyle(color: useWhiteIcons ? Colors.white : Colors.black),
            ),
            SizedBox(height: 5.h),
            Center(
              child: SizedBox(
                width: card.cardFormat == 'BarcodeFormat.code128'
                    ? double.infinity
                    : 200.h,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.r))),
                  child: BarcodeWidget(
                      drawText: false,
                      data: card.cardNumber,
                      barcode: card.cardFormat != 'BarcodeFormat.code128'
                          ? Barcode.qrCode()
                          : Barcode.code128(),
                      height: card.cardFormat == 'BarcodeFormat.code128'
                          ? 80.h
                          : 200.h,
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
