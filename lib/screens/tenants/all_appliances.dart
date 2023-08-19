import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:powershare/utils/big_text.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/small_text.dart';
import '../../widgets/buttons/multipurpose_button.dart';
import '../../widgets/navigation.dart';
import 'add_appliance.dart';

class AppliancesScreen extends StatelessWidget {
  const AppliancesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
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
                      text: 'My Appliances',
                      icon: Icons.arrow_back_outlined,
                    ),
                    SizedBox(height: Dimensions.height20),
                    SmallText(
                        text:
                            'You have no appliances yet. Add your appliances'),
                    SizedBox(height: Dimensions.height20),
                    Icon(
                      CupertinoIcons.dot_radiowaves_left_right,
                      size: Dimensions.iconSize30,
                      color: greyColor,
                    ),
                    SizedBox(height: Dimensions.height20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return const AddApplianceScreen();
                            }));
                          },
                          child: MultipurposeButton(
                            text: 'Add',
                            textColor: whiteColor,
                            backgroundColor: isDark ? greenColor : blackColor,
                          ),
                        )
                      ],
                    )
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
                  text: 'My Appliances',
                  icon: Icons.arrow_back_outlined,
                ),
                SizedBox(height: Dimensions.height20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return const AddApplianceScreen();
                        }));
                      },
                      child: MultipurposeButton(
                        text: 'Add more',
                        textColor: whiteColor,
                        backgroundColor: isDark ? deepGreen : blackColor,
                      ),
                    )
                  ],
                ),
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
                        String applianceId = appliances[index].id;

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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: const BigText(
                                                  text: 'Remove appliance',
                                                ),
                                                content: SmallText(
                                                  text:
                                                      'Are you sure you want to delete this Appliance? This action can\'t be undone',
                                                  size: Dimensions.font14,
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // CANCEL LOGOUT
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            MultipurposeButton(
                                                          text: "Cancel",
                                                          backgroundColor:
                                                              isDark
                                                                  ? deepGreen
                                                                  : blackColor,
                                                          textColor: whiteColor,
                                                        ),
                                                      ),

                                                      // REMOVE APARTMENT
                                                      GestureDetector(
                                                        onTap: () {
                                                          // Delete the appliance from the database and remove the card
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(uid)
                                                              .collection(
                                                                  'appliances')
                                                              .doc(applianceId)
                                                              .delete();

                                                          // Remove the card by updating the snapshot data
                                                          snapshot.data!.docs
                                                              .removeAt(index);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            MultipurposeButton(
                                                          text: "Remove",
                                                          backgroundColor:
                                                              isDark
                                                                  ? deepRed
                                                                  : redColor,
                                                          textColor: whiteColor,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: MultipurposeButton(
                                          text: 'Remove',
                                          textColor: whiteColor,
                                          backgroundColor:
                                              isDark ? deepRed : redColor,
                                        ),
                                      )
                                    ],
                                  )
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
