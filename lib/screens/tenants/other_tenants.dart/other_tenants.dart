import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:powershare/screens/tenants/other_tenants.dart/their_appliances.dart';
import 'package:powershare/utils/colors.dart';
import 'package:powershare/utils/small_text.dart';
import '../../../utils/big_text.dart';
import '../../../utils/dimensions.dart';

class OtherTenantsScreen extends StatelessWidget {
  const OtherTenantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display skeleton screens while data is loading
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => const SkeletonChatItem(),
            );
          }

          if (!snapshot.hasData) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => const SkeletonChatItem(),
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final currentUserApartmentName = userData['apartment name'];

          final currrentUsersName = userData['name'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where(
                  'apartment name',
                  isEqualTo: currentUserApartmentName,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display skeleton screens while data is loading
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => const SkeletonChatItem(),
                );
              }

              if (snapshot.hasError) {
                return const Scaffold(
                  body: Center(
                    child: Text('Oops! something went wrong'),
                  ),
                );
              }

              final users = snapshot.data!.docs;

              if (users.isNotEmpty) {
                return Container(
                  margin: EdgeInsets.only(
                    top: Dimensions.height30,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: Dimensions.height10,
                          ),
                          child: BigText(
                            text: 'Other tenants',
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
                                      color: darkSearchBarColor,
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
                        SizedBox(height: Dimensions.height10),
                        SmallText(
                          text: 'This are Tenants you share the meter with.',
                        ),
                        SizedBox(height: Dimensions.height10),
                        Expanded(
                          child: SizedBox(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];

                                final userData =
                                    user.data() as Map<String, dynamic>;
                                // Determine the display name based on the user's role
                                final name = userData['name'];
                                final displayName = userData['role'] == 'owner'
                                    ? 'landlord'
                                    : userData['name'];

                                if (currrentUsersName != name) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) {
                                            return OtherTenantAppliances(
                                              uid: user.id,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radius20),
                                      ),
                                      color: isDark
                                          ? darkSearchBarColor
                                          : whiteColor,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions.width20,
                                          vertical: Dimensions.height10,
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                radius: Dimensions.radius20 * 2,
                                                backgroundImage: NetworkImage(
                                                    user['imageUrl']),
                                                backgroundColor: isDark
                                                    ? darkSearchBarColor
                                                    : greyColor,
                                              ),
                                              SizedBox(
                                                  width: Dimensions.width20),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    displayName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          Dimensions.height7),
                                                  StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(user.id)
                                                        .collection(
                                                            'appliances')
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const SizedBox(); // Return an empty container while waiting for data
                                                      }

                                                      if (!snapshot.hasData ||
                                                          snapshot.data!.docs
                                                              .isEmpty) {
                                                        return const Row(
                                                          children: [
                                                            Text(
                                                              'This tenant has no appliances',
                                                            ),
                                                            SizedBox(width: 8),
                                                            Text('')
                                                          ],
                                                        );
                                                      }

                                                      var appliancesCount = 0;
                                                      var allDailyUnits = 0.0;
                                                      for (var doc in snapshot
                                                          .data!.docs) {
                                                        int quantity =
                                                            doc['quantity'];

                                                        appliancesCount +=
                                                            quantity;
                                                        var dailyUnits = doc[
                                                            'totalDailyUnits'];

                                                        allDailyUnits +=
                                                            dailyUnits;
                                                      }

                                                      const daysInMonth = 30;

                                                      const costPerunit = 292;
                                                      var dailyCost =
                                                          allDailyUnits *
                                                              costPerunit;
                                                      var monthlyCost =
                                                          dailyCost *
                                                              daysInMonth;

                                                      String
                                                          formattedDailyCost =
                                                          dailyCost
                                                              .toStringAsFixed(
                                                                  2);
                                                      String
                                                          formattedMonthlyCost =
                                                          monthlyCost
                                                              .toStringAsFixed(
                                                                  2);

                                                      return Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              'Number of appliances: $appliancesCount'), // Display the message
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            'Today\'s bills: $formattedDailyCost',
                                                          ), // Display the message
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            'This month\'s bills: $formattedMonthlyCost',
                                                          ),
                                                          SizedBox(
                                                              height: Dimensions
                                                                  .height10),
                                                          if (snapshot
                                                                  .hasData ||
                                                              snapshot
                                                                  .data!
                                                                  .docs
                                                                  .isNotEmpty)
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                SmallText(
                                                                  text:
                                                                      'Status',
                                                                ),
                                                                SizedBox(
                                                                    width: Dimensions
                                                                        .width10),
                                                                const BigText(
                                                                  text:
                                                                      'Not paid',
                                                                  color:
                                                                      greenColor,
                                                                ),
                                                              ],
                                                            )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ]),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                          ),
                        ),
                      ]),
                );
              } else {
                return const Center(
                  child: Text('No data'),
                );
              }
            },
          );
        },
      ),
    );
  }
}

// A simple skeleton screen for the chat item
class SkeletonChatItem extends StatelessWidget {
  const SkeletonChatItem({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.height20,
        horizontal: Dimensions.height20,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
        ),
        color: isDark ? darkSearchBarColor : buttonBackgroundColor,
        child: Row(children: [
          CircleAvatar(
            radius: Dimensions.radius20 * 2,
            backgroundColor:
                isDark ? darkSearchBarColor : buttonBackgroundColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Dimensions.width30 * 3,
                height: Dimensions.height30 / 1.5,
                decoration: BoxDecoration(
                  color: isDark ? darkSearchBarColor : buttonBackgroundColor,
                ),
              ),
              SizedBox(height: Dimensions.height7),
              Container(
                width: Dimensions.width30 * 2,
                height: Dimensions.height30 / 1.5,
                decoration: BoxDecoration(
                  color: isDark ? darkSearchBarColor : buttonBackgroundColor,
                ),
              ),
              SizedBox(height: Dimensions.height7),
              Container(
                width: Dimensions.width30 * 2,
                height: Dimensions.height30 / 2,
                decoration: BoxDecoration(
                  color: isDark ? darkSearchBarColor : buttonBackgroundColor,
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
