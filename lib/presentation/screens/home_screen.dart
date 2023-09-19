import 'dart:io';
import 'dart:math';

import 'package:cards_app/data/models/loyalty_card_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../data/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light));
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('You are logged in'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  auth.logout();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Container());
  }
}
