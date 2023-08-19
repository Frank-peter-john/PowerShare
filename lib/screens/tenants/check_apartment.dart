import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:powershare/screens/tenants/join_apartment.dart';
import 'package:powershare/screens/tenants/tenant_main_screen.dart';
import 'package:powershare/widgets/navigation.dart';
import '../../utils/big_text.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/small_text.dart';
import '../../widgets/buttons/continue_with.dart';

class CheckApartmentScreen extends StatelessWidget {
  const CheckApartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          left: Dimensions.width20,
          right: Dimensions.width20,
        ),
        child: Center(
          child: Column(
            children: [
              const TopNavigation(
                text: 'Join apartment',
                icon: Icons.arrow_back_outlined,
              ),
              SizedBox(height: Dimensions.height20),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.data!.data() == null ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading or skeleton screen while data is being fetched
                    return const CircularProgressIndicator(
                      color: greenColor,
                    );
                  }

                  final userData = snapshot.data!.data()!;
                  final apartmentName = userData['apartment name'];
                  final landlordName = userData['landlord'];

                  if (apartmentName != null && landlordName != null) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to tenant home screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => TenantMainScreen(
                              apartmentName: apartmentName,
                              landLordName: landlordName,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BigText(
                                    text: 'Your current apartment',
                                    size: Dimensions.font18,
                                  ),
                                  SizedBox(height: Dimensions.height10),
                                  SmallText(
                                    text: landlordName,
                                    size: Dimensions.font18,
                                  ),
                                  SizedBox(height: Dimensions.height10),
                                  SmallText(
                                    text: apartmentName,
                                    size: Dimensions.font18,
                                  ),
                                  SizedBox(height: Dimensions.width10),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      BigText(
                                        text: 'Continue with this apartment',
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        const Text(
                          'Looks like you are a new tenant!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: Dimensions.height20),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return const JoinApartmentScreen();
                            }));
                          },
                          child: ContinueWith(
                            text: 'Join your Apartment',
                            iconUrl: 'assets/icons/apartments.png',
                            iconColor: Theme.of(context).primaryColor,
                          ),
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
    );
  }
}
