import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContinueWithButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  final Color? bgColor;
  final Color? textColor;

  const ContinueWithButton({
    Key? key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.bgColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: const ButtonStyle().copyWith(
          backgroundColor: MaterialStateProperty.all<Color>(bgColor == null
              ? Theme.of(context).colorScheme.primary
              : bgColor!),
        ),
        onPressed: onPressed,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [icon],
              ),
            )
          ],
        ),
      ),
    );
  }
}
