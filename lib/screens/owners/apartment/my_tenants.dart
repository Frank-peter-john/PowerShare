import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:powershare/screens/tenants/other_tenants.dart/their_appliances.dart';
import 'package:powershare/utils/colors.dart';
import 'package:powershare/utils/small_text.dart';
import '../../../utils/big_text.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/buttons/multipurpose_button.dart';

class MyTenantsScreen extends StatefulWidget {
  final String apartmentName;
  final String location;
  const MyTenantsScreen({
    super.key,
    required this.apartmentName,
    required this.location,
  });

  @override
  State<MyTenantsScreen> createState() => _MyTenantsScreenState();
}

class _MyTenantsScreenState extends State<MyTenantsScreen> {
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
              itemCount: 5,
              itemBuilder: (context, index) => const SkeletonChatItem(),
            );
          }

          if (!snapshot.hasData) {
            return ListView.builder(
              itemCount: 5,
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
                        Card(
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
                                  color: greenColor,
                                ),
                                SizedBox(width: Dimensions.width10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BigText(
                                      text: 'Welcome to Your apartment',
                                      size: Dimensions.font18,
                                    ),
                                    SmallText(
                                      text:
                                          'Apartment: ${widget.apartmentName}',
                                      size: Dimensions.font15,
                                    ),
                                    SizedBox(
                                      height: Dimensions.height10 / 2,
                                    ),
                                    Row(
                                      children: [
                                        SmallText(
                                          text: 'Location: ${widget.location}',
                                          size: Dimensions.font15,
                                        ),
                                        SizedBox(width: Dimensions.width8),
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: Dimensions.iconSize16,
                                          color: blueColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.width10),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.width10),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: Dimensions.height10,
                          ),
                          child: BigText(
                            text: 'Your tenants',
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
                          text: 'This are your Tenants in this apartment',
                          size: Dimensions.font16,
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
                                final displayName = userData['name'];

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
                                          vertical: Dimensions.height20,
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

                                                      for (var doc in snapshot
                                                          .data!.docs) {
                                                        int quantity =
                                                            doc['quantity'];

                                                        appliancesCount +=
                                                            quantity;
                                                      }

                                                      return Text(
                                                        'Number of appliances: $appliancesCount',
                                                      );
                                                      // Display the message
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions.height20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            context: context,
                                                            barrierDismissible:
                                                                false,
                                                            builder: (ctx) {
                                                              return AlertDialog(
                                                                title:
                                                                    const BigText(
                                                                  text:
                                                                      'Remove tenant',
                                                                ),
                                                                content:
                                                                    SmallText(
                                                                  text:
                                                                      'Are you sure you want to remove this Tenant? This action can\'t be undone',
                                                                  size: Dimensions
                                                                      .font14,
                                                                ),
                                                                actions: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      // CANCEL DELETE
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            MultipurposeButton(
                                                                          text:
                                                                              "Cancel",
                                                                          backgroundColor: isDark
                                                                              ? deepGreen
                                                                              : blackColor,
                                                                          textColor:
                                                                              whiteColor,
                                                                        ),
                                                                      ),

                                                                      // LOGOUT
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          // Delete the tenant from the database and remove the card
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('users')
                                                                              .doc(user.id)
                                                                              .delete();

                                                                          // Remove the card by updating the snapshot data
                                                                          snapshot
                                                                              .data!
                                                                              .docs
                                                                              .removeAt(index);
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            MultipurposeButton(
                                                                          text:
                                                                              "Remove",
                                                                          backgroundColor: isDark
                                                                              ? deepRed
                                                                              : redColor,
                                                                          textColor:
                                                                              whiteColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child:
                                                            MultipurposeButton(
                                                          text: 'Remove',
                                                          textColor: whiteColor,
                                                          backgroundColor:
                                                              isDark
                                                                  ? deepRed
                                                                  : redColor,
                                                        ),
                                                      )
                                                    ],
                                                  )
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
                return Container(
                  margin: EdgeInsets.only(
                    top: Dimensions.height30,
                    right: Dimensions.width20,
                    left: Dimensions.width20,
                    bottom: Dimensions.height20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
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
                                color: greenColor,
                              ),
                              SizedBox(width: Dimensions.width10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BigText(
                                    text: 'Welcome to Your apartment',
                                    size: Dimensions.font18,
                                  ),
                                  SmallText(
                                    text: 'Apartment: ${widget.apartmentName}',
                                    size: Dimensions.font15,
                                  ),
                                  SizedBox(
                                    height: Dimensions.height10 / 2,
                                  ),
                                  Row(
                                    children: [
                                      SmallText(
                                        text: 'Location: ${widget.location}',
                                        size: Dimensions.font15,
                                      ),
                                      SizedBox(width: Dimensions.width8),
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: Dimensions.iconSize16,
                                        color: blueColor,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.width10),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.height20),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: Dimensions.height10,
                        ),
                        child: BigText(
                          text: 'Your Tenants',
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
                        text:
                            'Your tenants will appear here. No Tenants have joined yet.',
                        size: Dimensions.font14,
                      )
                    ],
                  ),
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
