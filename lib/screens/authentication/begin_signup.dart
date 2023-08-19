import 'package:flutter/material.dart';
import 'package:powershare/utils/power_share_heading.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/small_text.dart';
import '../../widgets/buttons/continue_with.dart';
import 'phone_number.dart';

class BeginRegistrationScreen extends StatefulWidget {
  const BeginRegistrationScreen({super.key});

  @override
  State<BeginRegistrationScreen> createState() =>
      _BeginRegistrationScreenState();
}

class _BeginRegistrationScreenState extends State<BeginRegistrationScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width30,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // svg logo
              Flexible(
                flex: 7,
                child: Container(),
              ),

              // HEADING
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: Dimensions.iconSize24,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: Dimensions.width30 * 5),
                  const PowerShareHeading(),
                ],
              ),
              // HEADING

              SizedBox(height: Dimensions.height30),

              // PHONE NUMBER INPUT
              const PhoneNumberInput(),
              // PHONE NUMBER INPUT

              SizedBox(height: Dimensions.height20),

              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark ? whiteColor : greyColor,
                      thickness: 0.2,
                    ),
                  ),
                  SizedBox(width: Dimensions.width8 / 2),
                  SmallText(
                    text: 'OR',
                    size: Dimensions.font16,
                  ),
                  SizedBox(width: Dimensions.width8 / 2),
                  Expanded(
                    child: Divider(
                      color: isDark ? whiteColor : greyColor,
                      thickness: 0.2,
                    ),
                  ),
                ],
              ),

              SizedBox(height: Dimensions.height20),

              // CONTINUE WITH GOOGLE
              GestureDetector(
                onTap: () {},
                child: const ContinueWith(
                  text: 'Continue with Google',
                  iconUrl: 'assets/icons/google_icon.png',
                ),
              ),
              // CONTINUE WITH GOOGLE

              SizedBox(height: Dimensions.height20),

              Flexible(
                flex: 25,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
