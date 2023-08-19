import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:powershare/utils/big_text.dart';
import 'package:powershare/utils/colors.dart';
import 'package:powershare/utils/small_text.dart';
import 'package:powershare/widgets/navigation.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/buttons/continue_with.dart';
import '../../../widgets/buttons/multipurpose_button.dart';
import '../apartment/add_apartment.dart';
import '../owner_main_screen.dart';

class ManageApartmentScreen extends StatefulWidget {
  const ManageApartmentScreen({super.key});

  @override
  State<ManageApartmentScreen> createState() => _ManageApartmentScreenState();
}

class _ManageApartmentScreenState extends State<ManageApartmentScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final uid = user!.uid;

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('apartments')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // User has apartments
            var apartmentDocs = snapshot.data!.docs;

            return Padding(
              padding: EdgeInsets.all(Dimensions.height20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopNavigation(
                    text: 'My apartments',
                    icon: Icons.arrow_back,
                  ),
                  SizedBox(height: Dimensions.height10),
                  SizedBox(
                    height: Dimensions.height120 * 3,
                    child: ListView.builder(
                      itemCount: apartmentDocs.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final apartmentId = apartmentDocs[index].id;
                        var apartmentData =
                            apartmentDocs[index].data() as Map<String, dynamic>;
                        var apartmentName = apartmentData['name'] ?? 'Unknown';
                        var apartmentLocation =
                            apartmentData['location'] ?? 'Unknown';

                        return GestureDetector(
                          onTap: () {
                            final userDoc = FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid);
                            userDoc.update({
                              'role': 'owner',
                              'apartment name': apartmentName,
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => OwnerMainScreen(
                                  apartmentName: apartmentName,
                                  location: apartmentLocation,
                                ),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => OwnerMainScreen(
                                  apartmentName: apartmentName,
                                  location: apartmentLocation,
                                ),
                              ),
                            );
                          },
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
                                    color: isDark ? deepGreen : greenColor,
                                  ),
                                  SizedBox(width: Dimensions.width10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SmallText(
                                        text: apartmentName,
                                        size: Dimensions.font18,
                                      ),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      Row(
                                        children: [
                                          SmallText(
                                            text: apartmentLocation,
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
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const BigText(
                                            text: 'Switch to this apartment',
                                          ),
                                          SizedBox(
                                              width: Dimensions.width30 * 2),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    title: const BigText(
                                                      text: 'Remove apartment',
                                                    ),
                                                    content: SmallText(
                                                      text:
                                                          'Are you sure you want to delete this Apartment? This action can not be undone',
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
                                                              textColor:
                                                                  whiteColor,
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
                                                                      'apartments')
                                                                  .doc(
                                                                      apartmentId)
                                                                  .delete();
                                                              // Remove the card by updating the snapshot data
                                                              snapshot
                                                                  .data!.docs
                                                                  .removeAt(
                                                                      index);
                                                              Navigator.pop(
                                                                  context);
                                                              print(
                                                                  apartmentId);
                                                            },
                                                            child:
                                                                MultipurposeButton(
                                                              text: "Remove",
                                                              backgroundColor:
                                                                  isDark
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
                                            child: MultipurposeButton(
                                              text: 'Remove',
                                              textColor: whiteColor,
                                              backgroundColor:
                                                  isDark ? deepRed : redColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const AddApartmentDetails();
                      }));
                    },
                    child: ContinueWith(
                      text: 'Add another Apartment',
                      iconUrl: 'assets/icons/apartments.png',
                      iconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            );
          } else {
            // User has no apartments
            return Container(
              margin: EdgeInsets.only(
                top: Dimensions.height30,
                left: Dimensions.width20,
                right: Dimensions.width20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TopNavigation(
                    text: 'My apartments',
                    icon: Icons.arrow_back,
                  ),
                  SizedBox(height: Dimensions.height10),
                  SmallText(text: 'You have no apartment in the system'),
                  SizedBox(height: Dimensions.height30),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return const AddApartmentDetails();
                        }));
                      },
                      child: ContinueWith(
                        text: 'Add your Apartment',
                        iconUrl: 'assets/icons/apartments.png',
                        iconColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
