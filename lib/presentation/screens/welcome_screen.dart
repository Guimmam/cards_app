import 'package:cards_app/presentation/screens/modal_bottom_sheet_create_account.dart';
import 'package:cards_app/presentation/widgets/continue_with_button.dart';
import 'package:cards_app/presentation/widgets/login_modal_bottom_sheet.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hi There!', style: _textTheme.headline3),
            Text(
              'Please select the provider to enter to Cards',
            ),
            SizedBox(
              height: 10.h,
            ),
            ContinueWithButton(
                text: 'Continue With Google',
                icon: FaIcon(FontAwesomeIcons.google)),
            SizedBox(
              height: 10.h,
            ),
            ContinueWithButton(
                text: 'Continue With Facebook',
                icon: FaIcon(FontAwesomeIcons.facebookF)),
            SizedBox(
              height: 10.h,
            ),
            ContinueWithButton(
                text: 'Continue With Github',
                icon: FaIcon(FontAwesomeIcons.github)),
            SizedBox(
              height: 20.h,
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(thickness: 2.h),
                ),
                SizedBox(width: 16.w),
                Text('Or use email to continue'),
                SizedBox(width: 16.w),
                Expanded(child: Divider(thickness: 2.h)),
              ],
            ),
            SizedBox(height: 20.h),
            ContinueWithButton(
                text: 'Log in via Email',
                icon: Container(),
                onPressed: () => _showLoginBottomSheet(context)),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () => _showCreateAccountSheet(context),
                  child: Text('Create an account via email')),
            )
          ],
        ),
      )),
    ));
  }

  void _showLoginBottomSheet(BuildContext context) => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => LoginModalBottomSheet(),
      );

  void _showCreateAccountSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
        context: context,
        builder: (context) => ModalBottomSheetCreateAccount());
  }
}
