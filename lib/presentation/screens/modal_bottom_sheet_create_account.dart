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
  bool isHiddenPassword = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Name', hintText: 'John Nowak'),
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Email', hintText: 'example@gmail.com'),
                  ),
                  SizedBox(height: 10.h),
                  TextFormField(
                      obscureText: isHiddenPassword,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'password123',
                          suffixIcon: IconButton(
                            icon: Icon(isHiddenPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              isHiddenPassword = !isHiddenPassword;
                              setState(() {});
                            },
                          ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
