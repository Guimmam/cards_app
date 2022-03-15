import 'package:cards_app/presentation/widgets/continue_with_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginModalBottomSheet extends StatefulWidget {
  const LoginModalBottomSheet({Key? key}) : super(key: key);

  @override
  State<LoginModalBottomSheet> createState() => _LoginModalBottomSheetState();
}

class _LoginModalBottomSheetState extends State<LoginModalBottomSheet> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  bool _isHiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Log in',
                  style: Theme.of(context).copyWith().textTheme.headline5,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
                  child: Container(
                    color: Theme.of(context).brightness == Brightness.light
                        ? const Color(0xFFf0f0f0)
                        : const Color(0xFF222222),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                )
              ],
            ),
            Column(
              //padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
              children: [
                SizedBox(height: 20.h),
                Form(
                  key: _key,
                  child: AutofillGroup(
                    child: Column(
                      children: [
                        TextFormField(
                          onFieldSubmitted: (_) {
                            passwordFocusNode.requestFocus();
                          },
                          focusNode: emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: validateEmail,
                          controller: emailController,
                          decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'example@gmail.com'),
                        ),
                        SizedBox(height: 10.h),
                        TextFormField(
                          onFieldSubmitted: (_) {
                            passwordFocusNode.unfocus();
                          },
                          focusNode: passwordFocusNode,
                          autofillHints: const [AutofillHints.password],
                          keyboardType: TextInputType.visiblePassword,
                          validator: validatePassword,
                          controller: passwordController,
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
                            ),
                          ),
                          onEditingComplete: () =>
                              TextInput.finishAutofillContext(),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: ContinueWithButton(
                              onPressed: () async {
                                if (_key.currentState!.validate()) {
                                  passwordFocusNode.unfocus();
                                  final resault = await logiIn();
                                  if (resault == null) {
                                    Navigator.of(context).pop();
                                  } else {}
                                }
                              },
                              text: 'Login',
                              icon: Container()),
                        ),
                        SizedBox(height: 15.h)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<FirebaseAuthException?> logiIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 10),
        backgroundColor: Theme.of(context).errorColor,
        behavior: SnackBarBehavior.floating,
      ));
      return e;
    }
    return null;
  }
}

String? validateEmail(String? email) {
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if (email!.isEmpty) return 'E-mail Addres is required.';

  if (!emailRegex.hasMatch(email)) return 'Invalid E-mail Address format';

  return null;
}

String? validatePassword(String? password) {
  final symbolRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  final numericRegex = RegExp(r'[0-9]');
  final uppercaseRegex = RegExp(r'[A-Z]');

  if (password!.length < 8) {
    return 'Password is too short';
  }

  if (!numericRegex.hasMatch(password)) {
    return 'Password has not any numbers';
  }

  if (!symbolRegex.hasMatch(password)) {
    return 'Password has not any symbols';
  }

  if (!uppercaseRegex.hasMatch(password)) {
    return 'Password has not any uppercase letters';
  }
  return null;
}
