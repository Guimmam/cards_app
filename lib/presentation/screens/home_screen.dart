import 'dart:io';
import 'dart:math';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:cards_app/data/models/loyalty_card_model.dart';
import 'package:cards_app/presentation/screens/add_loyalty_card_screen.dart';
import 'package:cards_app/presentation/screens/show_card_info_screen.dart';
import 'package:cards_app/presentation/theme/theme_menager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
            child: StreamBuilder<List<LoyaltyCard>>(
                stream: fetchCards(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.hasData) {
                    final cards = snapshot.data!;
                    if (cards.isEmpty) {
                      return Center(
                        child: Text('There are no cards to show'),
                      );
                    }
                    return ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return buildCard(context, cards.elementAt(index));
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: 160.w,
          child: ElevatedButton(
            child: Text('Add new Card'),
            onPressed: () {
              Navigator.of(context).pushNamed(AddLoyaltyCardScreen.routeName);
            },
          ),
        ));
  }

  Stream<List<LoyaltyCard>> fetchCards() {
    final String userUID = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUID)
        .collection('cards')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LoyaltyCard.fromJson(doc.data()))
            .toList());
  }
}

Widget buildCard(BuildContext context, LoyaltyCard card) {
  bool useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {
    int v = sqrt(pow(backgroundColor.red, 2) * 0.299 +
            pow(backgroundColor.green, 2) * 0.587 +
            pow(backgroundColor.blue, 2) * 0.114)
        .round();
    return v < 130 + bias ? true : false;
  }

  bool useWhiteIcons = useWhiteForeground(Color(card.cardColor));
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ShowCardInfoScreen(card: card)));
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
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
                style: TextStyle(
                    color: useWhiteIcons ? Colors.white : Colors.black),
              ),
              SizedBox(height: 5.h),
              Card(
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
              )
            ]),
          ),
        ),
      ),
    ),
  );
}
