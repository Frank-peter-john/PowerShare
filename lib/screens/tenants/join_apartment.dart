// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:powershare/screens/tenants/tenant_main_screen.dart';
import 'package:powershare/utils/colors.dart';
import 'package:powershare/utils/dimensions.dart';
import 'package:powershare/utils/show_snack_bar.dart';
import 'package:powershare/utils/small_text.dart';
import 'package:powershare/widgets/buttons/multipurpose_button.dart';
import 'package:powershare/widgets/navigation.dart';

class JoinApartmentScreen extends StatefulWidget {
  const JoinApartmentScreen({super.key});

  @override
  State<JoinApartmentScreen> createState() => _JoinApartmentScreenState();
}

class _JoinApartmentScreenState extends State<JoinApartmentScreen> {
  final TextEditingController _apartmentNameController =
      TextEditingController();
  final TextEditingController _landLordNameController = TextEditingController();

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> _verifyApartmentName() async {
    final isValid = _formKey.currentState!.validate();
    /* Remove the cursor on submitting the form */
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      final landLordName = _landLordNameController.text.trim();
      final apartmentName = _apartmentNameController.text.trim();

      final userSnapshots =
          await FirebaseFirestore.instance.collection('users').get();
      final userId = FirebaseAuth.instance.currentUser!.uid;

      bool isLandlordFound = false;
      bool isApartmentFound = false;

      // Loop through uid docs inside the users collection
      for (final userDoc in userSnapshots.docs) {
        final String name = userDoc['name'];

        final apartmentsSnapshot =
            await userDoc.reference.collection('apartments').get();

        //  Remove unneccesary spaces between words and change to lowercase.
        final normalizedName =
            name.toLowerCase().replaceAll(RegExp('\\s+'), ' ').trim();
        final normalizedLandLordName =
            landLordName.toLowerCase().replaceAll(RegExp('\\s+'), ' ').trim();

        // Check if landlord name matches the name field
        if (normalizedName == normalizedLandLordName) {
          isLandlordFound = true;

          // Loop through apartment docs in the apartments sub-collection
          for (final apartmentDoc in apartmentsSnapshot.docs) {
            final String apartmentDocName = apartmentDoc['name'];
            final normalizedAaprtmentName = apartmentName
                .toLowerCase()
                .replaceAll(RegExp('\\s+'), ' ')
                .trim();
            final normalizedAaprtmentDocName = apartmentDocName
                .toLowerCase()
                .replaceAll(RegExp('\\s+'), ' ')
                .trim();

            // Check if apartment name matches
            if (normalizedAaprtmentDocName == normalizedAaprtmentName) {
              isApartmentFound = true;
              break;
            }
          }

          break;
        }
      }

      if (isLandlordFound && isApartmentFound) {
        // Apartment and landlord found
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(userId);
        await userDoc.update({
          'role': 'tenant',
          'landlord': landLordName,
          'apartment name': apartmentName,
        });

        // Navigate to tenant home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (ctx) => TenantMainScreen(
              apartmentName: apartmentName,
              landLordName: landLordName,
            ),
          ),
        );
      } else if (!isLandlordFound) {
        // Landlord not found
        setState(() {
          _isLoading = false;
        });
        showSnackBar(
          context,
          'No landlord was found, enter a correct landlord name.',
        );
      } else if (!isApartmentFound) {
        // Apartment not found
        setState(() {
          _isLoading = false;
        });
        showSnackBar(
          context,
          'No apartment was found, enter your apartment name correctly.',
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _apartmentNameController.dispose();
    _landLordNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool _isDark = Theme.of(context).brightness == Brightness.dark;

    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(
        context,
        color: Theme.of(context).primaryColor,
        width: 0.5,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          left: Dimensions.width20,
          right: Dimensions.width20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopNavigation(
                text: 'Join your apartment',
                icon: Icons.arrow_back,
              ),
              SizedBox(height: Dimensions.height20 * 2),
              // LANDLORD NAME INPUT
              SmallText(
                text: 'Enter your Landlord name.',
                size: Dimensions.font14,
              ),
              SizedBox(
                height: Dimensions.height7,
              ),
              TextFormField(
                controller: _landLordNameController,
                key: const ValueKey('LandlordName'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Landlord name.';
                  }
                  return null;
                },
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.font16,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.font15,
                  ),
                  labelText: 'Landlord name',
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                ),
              ),

              SizedBox(height: Dimensions.height20),
              // APARTMENT NAME INPUT
              SmallText(
                text: 'Enter your apartment name.',
                size: Dimensions.font14,
              ),
              SizedBox(
                height: Dimensions.height7,
              ),
              TextFormField(
                controller: _apartmentNameController,
                key: const ValueKey('apartmentName'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your apartment name.';
                  }
                  return null;
                },
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.font16,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.font15,
                  ),
                  labelText: 'Apartment name',
                  border: inputBorder,
                  focusedBorder: inputBorder,
                  enabledBorder: inputBorder,
                ),
              ),
              SizedBox(height: Dimensions.height20),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _verifyApartmentName,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: greenColor,
                          )
                        : const MultipurposeButton(
                            text: 'Join',
                            textColor: whiteColor,
                            backgroundColor: greenColor,
                          ),
                  ),
                ],
              ),

              SizedBox(height: Dimensions.height20),
            ],
          ),
        ),
      ),
    );
  }
}
