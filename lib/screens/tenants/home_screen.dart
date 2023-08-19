import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:powershare/utils/show_snack_bar.dart';
import '../../utils/big_text.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/power_share_heading.dart';
import '../../utils/small_text.dart';
import 'package:flutter/material.dart';
import '../../widgets/buttons/multipurpose_button.dart';
import 'add_appliance.dart';
import 'all_appliances.dart';

class TenantsHomeScreen extends StatelessWidget {
  final String landLordName;
  final String apartmentName;
  const TenantsHomeScreen({
    Key? key,
    required this.landLordName,
    required this.apartmentName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    User? user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: greenColor,
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: EdgeInsets.only(
                top: Dimensions.height30,
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PowerShareHeading(),
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.height20),
                    height: Dimensions.height30 * 3.5,
                    width: Dimensions.width350 * 3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: isDark ? darkSearchBarColor : whiteColor,
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(Dimensions.height10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.apartment_outlined,
                              size: Dimensions.iconSize20 * 2,
                              color: deepGreen,
                            ),
                            SizedBox(width: Dimensions.width20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BigText(
                                  text: 'This is where you live now',
                                  size: Dimensions.font18,
                                ),
                                SmallText(
                                  text: 'Apartment name: $apartmentName',
                                  size: Dimensions.font15,
                                ),
                                SizedBox(
                                  height: Dimensions.height10 / 2,
                                ),
                                SmallText(
                                  text: 'LandLord: $landLordName',
                                  size: Dimensions.font15,
                                ),
                                SizedBox(width: Dimensions.width8),
                                SizedBox(height: Dimensions.width10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),

                  // APPLIANCES CARD
                  Container(
                    margin: EdgeInsets.only(top: Dimensions.height10),
                    height: Dimensions.height30 * 6,
                    width: Dimensions.width350 * 3,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) {
                              return const AppliancesScreen();
                            },
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                        ),
                        color: isDark ? darkSearchBarColor : whiteColor,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width20,
                              vertical: Dimensions.height10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                BigText(
                                  text: 'My appliances',
                                  size: Dimensions.font16,
                                ),
                                Icon(
                                  CupertinoIcons.dot_radiowaves_left_right,
                                  size: Dimensions.iconSize30,
                                  color: greyColor,
                                ),
                                SizedBox(height: Dimensions.height10),
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .collection('appliances')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(
                                        color: greenColor,
                                      );
                                    }

                                    var appliancesCount = 0;
                                    var totalWatts = 0.0;
                                    for (var doc in snapshot.data!.docs) {
                                      int quantity = doc['quantity'];
                                      var watts = doc['watts'];

                                      var allWatts = watts * quantity;
                                      totalWatts += allWatts;
                                      appliancesCount += quantity;
                                    }

                                    if (appliancesCount == 0) {
                                      return Column(
                                        children: [
                                          SmallText(
                                            text:
                                                'You have not added any appliances yet.',
                                          ),
                                          SizedBox(height: Dimensions.height10),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (ctx) {
                                                    return const AddApplianceScreen();
                                                  },
                                                ),
                                              );
                                            },
                                            child: MultipurposeButton(
                                              text: 'Add',
                                              textColor: whiteColor,
                                              backgroundColor: isDark
                                                  ? greenColor1
                                                  : greyColor,
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          SmallText(
                                            text:
                                                'Number of appliances: $appliancesCount',
                                          ),
                                          SizedBox(height: Dimensions.height10),
                                          SmallText(
                                            text:
                                                'Total watts: $totalWatts watts',
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                    builder: (ctx) {
                                                      return const AddApplianceScreen();
                                                    },
                                                  ));
                                                },
                                                child: MultipurposeButton(
                                                  text: 'Add more',
                                                  textColor: whiteColor,
                                                  backgroundColor: isDark
                                                      ? deepGreen
                                                      : blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  // APPLIANCES CARD

                  //USED UNITS CARD
                  Container(
                    margin: EdgeInsets.only(
                      top: Dimensions.height10,
                      bottom: Dimensions.height30,
                    ),
                    height: Dimensions.height30 * 6,
                    width: Dimensions.width350 * 3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                      ),
                      color: isDark ? darkSearchBarColor : whiteColor,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BigText(
                              text: 'Total used units.',
                              size: Dimensions.font16,
                            ),
                            Icon(
                              Icons.payments_outlined,
                              size: Dimensions.iconSize30,
                              color: greyColor,
                            ),
                            SizedBox(height: Dimensions.height10),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .collection('appliances')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(
                                    color: greenColor,
                                  );
                                }

                                var totalWatts = 0.0;
                                var allDailyUnits = 0.0;
                                for (var doc in snapshot.data!.docs) {
                                  int quantity = doc['quantity'];
                                  var watts = doc['watts'];
                                  var dailyUnits = doc['totalDailyUnits'];
                                  var allWatts = watts * quantity;
                                  totalWatts += allWatts;
                                  allDailyUnits += dailyUnits;
                                }

                                const daysInMonth = 30;
                                var monthlyUnits = allDailyUnits * daysInMonth;

                                String formattedMontlyUnits =
                                    monthlyUnits.toStringAsFixed(2);

                                if (totalWatts == 0) {
                                  return Column(
                                    children: [
                                      Icon(
                                        Icons.attach_money_outlined,
                                        size: Dimensions.iconSize30,
                                        color: greyColor,
                                      ),
                                      SizedBox(height: Dimensions.height10),
                                      SmallText(
                                        text:
                                            'You have no any bills yet, your bills will appear here.',
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      SmallText(
                                          text: 'Total Units you have used',
                                          size: Dimensions.font18),
                                      SmallText(
                                        text: 'Today: $allDailyUnits KwH',
                                      ),
                                      SizedBox(height: Dimensions.height10),
                                      SmallText(
                                        text:
                                            'This month: $formattedMontlyUnits KwH',
                                      ),
                                      SizedBox(height: Dimensions.height20),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //USED UNITS CARD

                  // BILLS CARD
                  Container(
                    margin: EdgeInsets.only(
                      top: Dimensions.height10,
                      bottom: Dimensions.height30,
                    ),
                    height: Dimensions.height30 * 6,
                    width: Dimensions.width350 * 3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                      ),
                      color: isDark ? darkSearchBarColor : whiteColor,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BigText(
                              text: 'My bills',
                              size: Dimensions.font16,
                            ),
                            SizedBox(height: Dimensions.height10),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(uid)
                                  .collection('appliances')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(
                                    color: greenColor,
                                  );
                                }

                                var totalWatts = 0.0;
                                var allDailyUnits = 0.0;
                                for (var doc in snapshot.data!.docs) {
                                  int quantity = doc['quantity'];
                                  var watts = doc['watts'];
                                  var dailyUnits = doc['totalDailyUnits'];
                                  var allWatts = watts * quantity;
                                  totalWatts += allWatts;
                                  allDailyUnits += dailyUnits;
                                }

                                const daysInMonth = 30;

                                const costPerunit = 292;
                                var dailyCost = allDailyUnits * costPerunit;
                                var monthlyCost = dailyCost * daysInMonth;

                                String formattedDailyCost =
                                    dailyCost.toStringAsFixed(2);
                                String formattedMonthlyCost =
                                    monthlyCost.toStringAsFixed(2);

                                if (totalWatts == 0) {
                                  return Column(
                                    children: [
                                      Icon(
                                        Icons.attach_money_outlined,
                                        size: Dimensions.iconSize30,
                                        color: greyColor,
                                      ),
                                      SizedBox(height: Dimensions.height10),
                                      SmallText(
                                        text:
                                            'You have no any bills yet, your bills will appear here.',
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      SmallText(
                                          text: 'Total cost',
                                          size: Dimensions.font18),
                                      SmallText(
                                        text:
                                            'Today\'s amount: $formattedDailyCost Tshs',
                                      ),
                                      SizedBox(height: Dimensions.height10),
                                      SmallText(
                                        text:
                                            'This month\'s amount: $formattedMonthlyCost Tshs',
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showSnackBar(
                                                context,
                                                'This feature is still under development.',
                                              );
                                            },
                                            child: MultipurposeButton(
                                              text: 'Pay',
                                              textColor: whiteColor,
                                              backgroundColor: isDark
                                                  ? deepGreen
                                                  : blackColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // BILLS CARD
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
