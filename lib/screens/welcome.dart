import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:powershare/screens/tenants/check_apartment.dart';
import 'package:powershare/utils/colors.dart';
import '../utils/big_text.dart';
import '../utils/dimensions.dart';
import '../utils/power_share_heading.dart';
import '../utils/small_text.dart';

import '../widgets/buttons/continue_with.dart';
import 'owners/apartment/my_apartment.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<String> getCurrentUserName() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String uid = currentUser!.uid;

    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    String name = userSnapshot['name'];
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getCurrentUserName(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String name = snapshot.data!;
          return Scaffold(
            body: Container(
              margin: EdgeInsets.only(
                top: Dimensions.height20,
                right: Dimensions.width30 * 2,
                left: Dimensions.width30 * 2,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADING
                  const Center(child: PowerShareHeading()),
                  // HEADING

                  SizedBox(height: Dimensions.height20),

                  // WELCOME TEXT
                  Row(
                    children: [
                      BigText(text: 'Hello, welcome ', size: Dimensions.font18),
                      BigText(
                        text: name,
                        size: Dimensions.font16,
                        color: greenColor,
                      )
                    ],
                  ),
                  // WELCOME TEXT

                  SizedBox(height: Dimensions.height20 * 2),

                  // ADD APARTMENT BUTTON
                  SmallText(
                    text: 'Are you an apartment Owner?',
                    size: Dimensions.font15,
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const MyApartmentScreen();
                      }));
                    },
                    child: ContinueWith(
                      text: 'Add your Apartment',
                      iconUrl: 'assets/icons/apartments.png',
                      iconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  // ADD APARTMENT BUTTON

                  SizedBox(height: Dimensions.height30 * 1.5),

                  // JOIN APARTMENT BUTTON
                  SmallText(
                    text: 'Are you a Tenant?',
                    size: Dimensions.font15,
                  ),
                  SizedBox(height: Dimensions.height20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return const CheckApartmentScreen();
                      }));
                    },
                    child: ContinueWith(
                      text: 'Join your Apartment',
                      iconUrl: 'assets/icons/apartments.png',
                      iconColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SmallText(
                    text: 'Oops!,sory something went wrong.',
                    size: Dimensions.font18,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: SizedBox(
              height: Dimensions.height30 * 2,
              width: Dimensions.width30 * 2,
              child: const CircularProgressIndicator(
                color: greenColor,
              ),
            ),
          );
        }
      },
    );
  }
}
