import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/small_text.dart';

class ContinueWith extends StatelessWidget {
  final String iconUrl;
  final String text;
  final Color? iconColor;
  const ContinueWith({
    super.key,
    required this.iconUrl,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.height20 / 1.5,
        horizontal: Dimensions.width10,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: greyColor),
          borderRadius: BorderRadius.all(
            Radius.circular(
              Dimensions.radius20 / 2,
            ),
          ),
        ),
      ),
      child: Row(
        children: [
          Image(
            image: AssetImage(
              iconUrl,
            ),
            width: Dimensions.width30,
            color: iconColor,
          ),
          SizedBox(width: Dimensions.width30 * 1.5),
          Expanded(
            child: SmallText(
              text: text,
              size: Dimensions.font15,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
