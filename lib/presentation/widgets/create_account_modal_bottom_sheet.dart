import 'package:cards_app/presentation/widgets/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountModalBottomSheet extends StatefulWidget {
  const CreateAccountModalBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateAccountModalBottomSheet> createState() =>
      _CreateAccountModalBottomSheetState();
}

class _CreateAccountModalBottomSheetState
    extends State<CreateAccountModalBottomSheet> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _passwordFocusNode = FocusNode();
  final _userNameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  bool _isHiddenPassword = true;
  bool _hasNumber = false;
  bool _hasSymbol = false;
  bool _hasAtLeast8Characters = false;
  bool _hasUppercaseLetter = false;
  bool _showPasswordInfo = false;
  bool _isLoading = false;

  @override
  void initState() {
    _passwordFocusNode.addListener(() {
      setState(() {
        if (_passwordFocusNode.hasFocus) {
          _showPasswordInfo = true;
        } else {
          _showPasswordInfo = false;
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _userNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

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
    final bool _isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: DraggableScrollableSheet(
        maxChildSize: 0.95,
        initialChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.r))),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create an Account',
                        style: Theme.of(context).copyWith().textTheme.headline5,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15.r)),
                        child: Container(
                          color: _isDark
                              ? const Color(0xFF222222)
                              : const Color(0xFFf0f0f0),
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
                ),
                Expanded(
                  child: ListView(
                    children: [
                      Form(
                        key: _key,
                        child: AutofillGroup(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                            ),
                            child: Column(
                              children: [
                                TextFormField(
                                  autofocus: true,
                                  autofillHints: const [
                                    AutofillHints.newUsername
                                  ],
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.next,
                                  controller: _usernameController,
                                  focusNode: _userNameFocusNode,
                                  validator: validateUsername,
                                  decoration: const InputDecoration(
                                      labelText: 'Username',
                                      hintText: 'John Nowak'),
                                ),
                                SizedBox(height: 10.h),
                                TextFormField(
                                  autofillHints: const [AutofillHints.email],
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  validator: validateEmail,
                                  decoration: const InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'example@gmail.com'),
                                ),
                                SizedBox(height: 10.h),
                                TextFormField(
                                  autofillHints: const [
                                    AutofillHints.newPassword
                                  ],
                                  onFieldSubmitted: (_) {
                                    _passwordFocusNode.unfocus();
                                  },
                                  validator: validatePassword,
                                  controller: _passwordController,
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
                                    ),
                                  ),
                                  onEditingComplete: () =>
                                      TextInput.finishAutofillContext(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _showPasswordInfo
                          ? Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Password must include: '),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            splashRadius: 0,
                                            value: _hasSymbol,
                                            onChanged: (_) {}),
                                      ),
                                      SizedBox(width: 5.w),
                                      const Text('Symbol')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            splashRadius: 0,
                                            value: _hasNumber,
                                            onChanged: (_) {}),
                                      ),
                                      SizedBox(width: 5.w),
                                      const Text('Number')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            splashRadius: 0,
                                            value: _hasUppercaseLetter,
                                            onChanged: (_) {}),
                                      ),
                                      SizedBox(width: 5.w),
                                      const Text('Uppercase Letter')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                        width: 20.w,
                                        child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            splashRadius: 0,
                                            value: _hasAtLeast8Characters,
                                            onChanged: (_) {}),
                                      ),
                                      SizedBox(width: 5.w),
                                      const Text('At least 8 Characters')
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 0,
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 24.w),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              _isLoading = true;
                              setState(() {});
                              final result = await createAccount();
                              if (result == null) {
                                Navigator.of(context).pop();
                              } else {
                                _isLoading = false;
                                setState(() {});
                              }
                            }
                          },
                          child: _isLoading
                              ? SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color:
                                        _isDark ? Colors.black : Colors.white,
                                  ),
                                )
                              : const Text('Create an Account'))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseAuthException?> createAccount() async {
    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = result.user;
      await user!.updateDisplayName(_usernameController.text.trim());
    } on FirebaseAuthException catch (e) {
      showErrorDialog(e, context);
      return e;
    }
    return null;
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
