import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModalBottomSheetCreateAccount extends StatefulWidget {
  const ModalBottomSheetCreateAccount({
    Key? key,
  }) : super(key: key);

  @override
  State<ModalBottomSheetCreateAccount> createState() =>
      _ModalBottomSheetCreateAccountState();
}

class _ModalBottomSheetCreateAccountState
    extends State<ModalBottomSheetCreateAccount> {
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 16.h),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create an Account',
                      style: Theme.of(context).copyWith().textTheme.headline5,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15.r)),
                      child: Container(
                        color: Color(0xFFf0f0f0),
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
                SizedBox(height: 20.h),
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: validateUsername,
                        decoration: InputDecoration(
                            labelText: 'Username', hintText: 'John Nowak'),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                        validator: validateEmail,
                        decoration: InputDecoration(
                            labelText: 'Email', hintText: 'example@gmail.com'),
                      ),
                      SizedBox(height: 10.h),
                      TextFormField(
                          validator: validatePassword,
                          focusNode: _passwordFocusNode,
                          onChanged: (password) => onPasswordChanged(password),
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
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Text('Password must include: '),
                Row(
                  children: [
                    SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          splashRadius: 0,
                          value: _hasSymbol,
                          onChanged: (_) {}),
                    ),
                    SizedBox(width: 5.w),
                    Text('Symbol')
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          splashRadius: 0,
                          value: _hasNumber,
                          onChanged: (_) {}),
                    ),
                    SizedBox(width: 5.w),
                    Text('Number')
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          splashRadius: 0,
                          value: _hasUppercaseLetter,
                          onChanged: (_) {}),
                    ),
                    SizedBox(width: 5.w),
                    Text('Uppercase Letter')
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                          splashRadius: 0,
                          value: _hasAtLeast8Characters,
                          onChanged: (_) {}),
                    ),
                    SizedBox(width: 5.w),
                    Text('At least 8 Characters')
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            _key.currentState!.validate();
                          },
                          child: Text('Create an Account'))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? validateUsername(String? username) {
  if (username!.isEmpty) return 'Username cannot be empty';
  return null;
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
