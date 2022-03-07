import 'package:cards_app/presentation/widgets/continue_with_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginModalBottomSheet extends StatefulWidget {
  const LoginModalBottomSheet({Key? key}) : super(key: key);

  @override
  State<LoginModalBottomSheet> createState() => _LoginModalBottomSheetState();
}

class _LoginModalBottomSheetState extends State<LoginModalBottomSheet> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordFocusNode = FocusNode();
  bool _isHiddenPassword = true;
  bool _hasNumber = false;
  bool _hasSymbol = false;
  bool _hasAtLeast8Characters = false;
  bool _hasUppercaseLetter = false;

  onPasswordChanged(String password) {
    final symbolRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    final numericRegex = RegExp(r'[0-9]');
    final uppercaseRegex = RegExp(r'[A-Z]');

    setState(() {
      _hasAtLeast8Characters = false;
      if (password.length >= 8) {
        _hasAtLeast8Characters = true;
      }
      _hasNumber = false;
      if (numericRegex.hasMatch(password)) {
        _hasNumber = true;
      }
      _hasSymbol = false;
      if (symbolRegex.hasMatch(password)) {
        _hasSymbol = true;
      }
      _hasUppercaseLetter = false;
      if (uppercaseRegex.hasMatch(password)) {
        _hasUppercaseLetter = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: DraggableScrollableSheet(
        maxChildSize: 0.95,
        initialChildSize: 0.6,
        builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(15.r))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Log in',
                        style: Theme.of(context).copyWith().textTheme.headline5,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        child: Container(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Color(0xFFf0f0f0)
                                  : Color(0xFF222222),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.close),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding:
                        EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
                    controller: scrollController,
                    children: [
                      SizedBox(height: 20.h),
                      Form(
                        key: _key,
                        child: Column(
                          children: [
                            TextFormField(
                              //validator: validateUsername,
                              decoration: InputDecoration(
                                  labelText: 'Username',
                                  hintText: 'John Nowak'),
                            ),
                            SizedBox(height: 10.h),
                            TextFormField(
                              //validator: validateEmail,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'example@gmail.com'),
                            ),
                            SizedBox(height: 10.h),
                            TextFormField(
                                //validator: validatePassword,
                                focusNode: _passwordFocusNode,
                                onChanged: (password) =>
                                    onPasswordChanged(password),
                                obscureText: _isHiddenPassword,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: 'password123',
                                    suffixIcon: IconButton(
                                      icon: Icon(_isHiddenPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        _isHiddenPassword = !_isHiddenPassword;
                                        setState(() {});
                                      },
                                    ))),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: ContinueWithButton(
                                  text: 'text', icon: Container()),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
