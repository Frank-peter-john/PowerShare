import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/small_text.dart';

class LoginButton extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;

  const LoginButton({
    super.key,
    required this.text,
    this.color = greenColor,
    this.textColor = whiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.height20),
      width: Dimensions.width30 * 5,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              Dimensions.radius20 / 2,
            ),
          ),
        ),
        color: color,
      ),
      child: SmallText(
        text: text,
        size: Dimensions.font15,
        color: textColor,
      ),
    );
  }
}
