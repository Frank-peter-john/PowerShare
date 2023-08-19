import 'package:flutter/material.dart';
import 'package:powershare/utils/colors.dart';

import '../../utils/dimensions.dart';
import '../../utils/small_text.dart';

class MultipurposeButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const MultipurposeButton({
    super.key,
    required this.text,
    this.backgroundColor = greenColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.width30 * 3,
      alignment: Alignment.center,
      padding: EdgeInsets.all(Dimensions.height7),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Dimensions.radius20 / 2),
          ),
        ),
        color: backgroundColor,
      ),
      child: SmallText(
        text: text,
        color: textColor,
        size: Dimensions.font15,
      ),
    );
  }
}
