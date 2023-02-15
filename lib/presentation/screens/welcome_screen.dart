import 'dart:io';

import 'package:cards_app/data/providers/auth_provider.dart';
import 'package:cards_app/presentation/widgets/create_account_modal_bottom_sheet.dart';
import 'package:cards_app/presentation/widgets/continue_with_button.dart';
import 'package:cards_app/presentation/widgets/login_modal_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
    TextTheme _textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hi There!', style: _textTheme.headline3),
                const Text(
                  'Please select the provider to enter to Cards',
                ),
                SizedBox(
                  height: 10.h,
                ),
                ContinueWithButton(
                    onPressed: () {
                      auth.googleLogin();
                    },
                    bgColor: Colors.black,
                    textColor: Colors.white,
                    text: 'Continue With Google',
                    icon: const FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    )),
                // SizedBox(
                //   height: 10.h,
                // ),
                // ContinueWithButton(
                //     onPressed: () {
                //       showThisFeatureWillBeAddedSoonSnackBar(context);
                //     },
                //     bgColor: isDark ? Colors.black26 : Colors.white,
                //     textColor: isDark ? Colors.white : Colors.black,
                //     text: 'Continue With Facebook',
                //     icon: FaIcon(
                //       FontAwesomeIcons.facebook,
                //       color: isDark ? Colors.white : Colors.black,
                //     )),
                // SizedBox(
                //   height: 10.h,
                // ),
                // ContinueWithButton(
                //     onPressed: () {
                //       showThisFeatureWillBeAddedSoonSnackBar(context);
                //     },
                //     bgColor: isDark ? Colors.black26 : Colors.white,
                //     textColor: isDark ? Colors.white : Colors.black,
                //     text: 'Continue With Github',
                //     icon: FaIcon(
                //       FontAwesomeIcons.github,
                //       color: isDark ? Colors.white : Colors.black,
                //     )),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(thickness: 2.h),
                    ),
                    SizedBox(width: 16.w),
                    const Text('Or use email to continue'),
                    SizedBox(width: 16.w),
                    Expanded(child: Divider(thickness: 2.h)),
                  ],
                ),
                SizedBox(height: 20.h),
                ContinueWithButton(
                    text: 'Login via Email',
                    icon: Container(),
                    onPressed: () => _showLoginBottomSheet(context)),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () => _showCreateAccountSheet(context),
                      child: const Text('Create an account via email')),
                )
              ],
            ),
          )),
        ));
  }

  void _showLoginBottomSheet(BuildContext context) => showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
        context: context,
        builder: (context) => const LoginModalBottomSheet(),
      );

  void _showCreateAccountSheet(BuildContext context) => showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
      context: context,
      builder: (context) => const CreateAccountModalBottomSheet());
}

void showThisFeatureWillBeAddedSoonSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
      content: const Text(
        'this feature will be added soon',
        textAlign: TextAlign.center,
      )));
}
