import 'dart:io';
import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cards_app/data/models/loyalty_card_model.dart';
import 'package:cards_app/presentation/screens/add_loyalty_card_screen.dart';
import 'package:cards_app/presentation/theme/theme_menager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light));
    }

    User? user = FirebaseAuth.instance.currentUser!;
    List<LoyaltyCard> cardsList = [
      LoyaltyCard(
          id: 0,
          isSync: true,
          cardName: 'Moja Biedronka',
          companyName: 'Biedronka',
          cardColor: 0XFFe02130,
          cardNumber: '23875782fgh3652'),
      LoyaltyCard(
          id: 0,
          cardName: 'IKEA Family',
          companyName: 'IKEA',
          cardColor: 0XFF0058ab,
          cardNumber: '238757823hfgh652'),
      LoyaltyCard(
          id: 0,
          cardName: 'Żappka',
          companyName: 'Żabka',
          cardColor: 0XFF006420,
          cardNumber: '2387578236dfhfdh52'),
      LoyaltyCard(
          id: 0,
          cardName: 'IKEA Family',
          companyName: 'IKEA',
          cardColor: 0XFFdde99f,
          cardNumber: 'ffgh')
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Cards'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: cardsList.length,
          itemBuilder: (context, index) {
            return LoyaltyCardWidget(
              cardsList: cardsList,
              index: index,
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add new Loyalty Card'),
        onPressed: () {
          Navigator.of(context).pushNamed(AddLoyaltyCardScreen.routeName);
        },
      ),
    );
  }
}

class LoyaltyCardWidget extends StatelessWidget {
  const LoyaltyCardWidget(
      {Key? key, required this.cardsList, required this.index})
      : super(key: key);

  final List<LoyaltyCard> cardsList;
  final int index;

  @override
  Widget build(BuildContext context) {
    int cardColor = cardsList.elementAt(index).cardColor;

    bool useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {
      int v = sqrt(pow(backgroundColor.red, 2) * 0.299 +
              pow(backgroundColor.green, 2) * 0.587 +
              pow(backgroundColor.blue, 2) * 0.114)
          .round();
      return v < 130 + bias ? true : false;
    }

    bool useWhiteIcons = useWhiteForeground(Color(cardColor));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Card(
          color: Color(cardColor),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.r))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cardsList.elementAt(index).companyName,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: useWhiteIcons ? Colors.white : Colors.black)),
                  Icon(
                    cardsList.elementAt(index).isSync
                        ? Icons.cloud_off
                        : Icons.cloud_done,
                    color: useWhiteIcons ? Colors.white : Colors.black,
                  )
                ],
              ),
              Text(
                cardsList.elementAt(index).cardName,
                style: TextStyle(
                    color: useWhiteIcons ? Colors.white : Colors.black),
              ),
              SizedBox(height: 5.h),
              GestureDetector(
                onTap: () {},
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.r))),
                  // child: SizedBox(
                  //   height: 60.h,
                  //   child: BarcodeWidget(
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  //       drawText: false,
                  //       data: cardsList.elementAt(index).cardNumber,
                  //       barcode: Barcode.code128()),
                  // ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
