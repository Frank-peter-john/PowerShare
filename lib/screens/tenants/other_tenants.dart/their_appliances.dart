import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:powershare/utils/big_text.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/small_text.dart';
import '../../../widgets/navigation.dart';

class OtherTenantAppliances extends StatelessWidget {
  final String uid;
  const OtherTenantAppliances({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('appliances')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: greenColor,
            ));
          }

          List<DocumentSnapshot> appliances = snapshot.data!.docs;

          if (appliances.isEmpty) {
            return Center(
              child: Container(
                margin: EdgeInsets.only(
                  top: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const TopNavigation(
                      text: 'Appliances',
                      icon: Icons.arrow_back_outlined,
                    ),
                    SizedBox(height: Dimensions.height20),
                    SmallText(text: 'This tenant have no appliances yet.'),
                    SizedBox(height: Dimensions.height20),
                  ],
                ),
              ),
            );
          }

          return Container(
            margin: EdgeInsets.only(
              top: Dimensions.height30,
              left: Dimensions.width20,
              right: Dimensions.width20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopNavigation(
                  text: 'Appliances',
                  icon: Icons.arrow_back_outlined,
                ),
                SizedBox(height: Dimensions.height20),
                SizedBox(height: Dimensions.height20),
                Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: appliances.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> applianceData =
                            appliances[index].data() as Map<String, dynamic>;
                        String name = applianceData['name'];
                        double watts = applianceData['watts'];
                        int quantity = applianceData['quantity'];

                        return Container(
                          margin: EdgeInsets.only(bottom: Dimensions.height20),
                          height: Dimensions.height30 * 5,
                          width: Dimensions.width350 * 3,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: isDark ? darkSearchBarColor : whiteColor,
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.height10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BigText(
                                    text: 'Appliance: $name',
                                    size: Dimensions.font16,
                                  ),
                                  SizedBox(height: Dimensions.height7),
                                  SmallText(text: 'Consumption: $watts watts'),
                                  SizedBox(height: Dimensions.height7),
                                  SmallText(text: 'Quantity: $quantity'),
                                  SizedBox(height: Dimensions.height10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
