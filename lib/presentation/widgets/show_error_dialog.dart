import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
 
 Future<dynamic> showErrorDialog(FirebaseAuthException e,BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        e.message.toString(),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                          onPressed: Navigator.of(context).pop,
                          child: const Text('Ok'))
                    ],
                  ),
                  Positioned(
                      top: -35.h,
                      child: CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Theme.of(context).errorColor,
                        child: const Icon(
                          Icons.clear,
                          size: 40,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.r))),
            ));
  }