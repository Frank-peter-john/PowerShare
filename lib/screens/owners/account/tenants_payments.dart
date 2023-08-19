import 'package:flutter/material.dart';
import 'package:powershare/utils/small_text.dart';
import '../../../utils/big_text.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          right: Dimensions.width20,
          left: Dimensions.width20,
          bottom: Dimensions.height20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                bottom: Dimensions.height10,
              ),
              child: BigText(
                text: 'Tenants payments',
                size: Dimensions.font24,
              ),
            ),

            // BORDER
            Container(
              margin: EdgeInsets.only(
                bottom: Dimensions.height20,
              ),
              decoration: BoxDecoration(
                border: isDark
                    ? const Border(
                        bottom: BorderSide(
                          color: greyColor,
                          // style: BorderStyle.solid,
                          width: 0.5,
                        ),
                      )
                    : const Border(
                        bottom: BorderSide(
                          color: greyColor,
                          // style: BorderStyle.solid,
                          width: 0.2,
                        ),
                      ),
              ),
            ),
            // BORDER

            SmallText(
              text: 'No payments  from Tenants yet.',
              size: Dimensions.font16,
            ),
            SizedBox(height: Dimensions.height10),
            SmallText(
              text: 'Payments made by each Tenant will appear here.',
              size: Dimensions.font14,
              color: greyColor,
            ),
          ],
        ),
      ),
    );
  }
}
