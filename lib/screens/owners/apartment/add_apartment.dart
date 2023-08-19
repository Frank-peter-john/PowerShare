// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:powershare/screens/owners/owner_main_screen.dart';
import 'package:powershare/utils/colors.dart';
import 'package:powershare/widgets/buttons/multipurpose_button.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/show_snack_bar.dart';
import '../../../utils/small_text.dart';
import '../../../widgets/navigation.dart';

class AddApartmentDetails extends StatefulWidget {
  const AddApartmentDetails({super.key});

  @override
  State<AddApartmentDetails> createState() => _AddApartmentDetailsState();
}

class _AddApartmentDetailsState extends State<AddApartmentDetails> {
  final TextEditingController _apartmentNameController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

// THIS METHOD INVOKES ALL THE FORM VALIDATORS WHEN THE SIGNUP BUTTON IS CLICKED.

  void saveDetails() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      final apartmentName = _apartmentNameController.text.trim();
      final description = _descriptionController.text.trim();
      final location = _locationController.text
          .trim(); // Trim any leading/trailing whitespace

      if (apartmentName.isNotEmpty) {
        // Check if the apartment name is not empty
        try {
          final User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final userId = user.uid;

            final CollectionReference userApartments = FirebaseFirestore
                .instance
                .collection('users')
                .doc(userId)
                .collection('apartments');

            final QuerySnapshot snapshot = await userApartments
                .where('name', isEqualTo: apartmentName)
                .get();

            if (snapshot.docs.isNotEmpty) {
              setState(() {
                _isLoading = false;
              });
              showSnackBar(
                  context, 'The name is already taken, choose another name.');
            } else {
              await userApartments.doc(apartmentName).set({
                'name': apartmentName,
                'location': location,
                'description': description,
              });

              final userDoc =
                  FirebaseFirestore.instance.collection('users').doc(userId);
              await userDoc.update({
                'role': 'owner',
                'apartment name': apartmentName,
              });

              setState(() {
                _isLoading = false;
              });

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (ctx) => OwnerMainScreen(
                          apartmentName: apartmentName,
                          location: location,
                        )),
              );
            }
          }
        } catch (error) {
          setState(() {
            _isLoading = false;
          });

          showSnackBar(context, 'Oops! something went wrong, try again.');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Apartment name cannot be empty.');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _apartmentNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // DEFINING THE INPUT BORDER STRUCTURE
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: Theme.of(context).primaryColor, width: 0.5),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TopNavigation(
              text: "Add your apartment details",
              icon: Icons.arrow_back,
            ),
            SizedBox(height: Dimensions.height20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SmallText(
                      text: "Cool, add your apartment details.",
                      size: Dimensions.font16,
                    ),

                    SizedBox(height: Dimensions.height20),

                    //APARTMENT NAME
                    SmallText(
                      text:
                          "Enter your apartment name. The name should be unique",
                      size: Dimensions.font14,
                    ),
                    SizedBox(height: Dimensions.height10),

                    TextFormField(
                      controller: _apartmentNameController,
                      key: const ValueKey('apartmentName'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Apartment name can not be empty.';
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.font16,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: Dimensions.font15,
                          color: Theme.of(context).primaryColor,
                        ),
                        border: inputBorder,
                        focusedBorder: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    SizedBox(height: Dimensions.height20),

                    // APARTMENT LOCATION
                    SmallText(
                      text: "Enter your apartment location.",
                      size: Dimensions.font14,
                    ),
                    SizedBox(height: Dimensions.height10),

                    TextFormField(
                      key: const ValueKey('apartmentLocation'),
                      controller: _locationController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Apartment location can not be empty.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.font16,
                      ),
                      decoration: InputDecoration(
                        labelText: 'street, District, region',
                        labelStyle: TextStyle(
                          fontSize: Dimensions.font15,
                          color: Theme.of(context).primaryColor,
                        ),
                        border: inputBorder,
                        focusedBorder: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // APARTMENT DESCRIPTION
                    SmallText(
                      text: "Describe your apartment in a few words.",
                      size: Dimensions.font14,
                    ),
                    SizedBox(height: Dimensions.height10),

                    TextFormField(
                      controller: _descriptionController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Apartment description can not be empty';
                        }
                        return null;
                      },
                      cursorColor: Theme.of(context).primaryColor,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.font14,
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.font15,
                        ),
                        labelText: 'Description...',
                        border: inputBorder,
                        focusedBorder: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                      minLines: 4,
                      maxLines: 20,
                    ),
                    // TEXT INPUT

                    SizedBox(height: Dimensions.height30),

                    // NEXT BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: saveDetails,
                          child: _isLoading
                              ? SizedBox(
                                  height: Dimensions.height30,
                                  width: Dimensions.width30,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : MultipurposeButton(
                                  text: 'Finish',
                                  textColor: whiteColor,
                                  backgroundColor:
                                      isDark ? greenColor : blackColor,
                                ),
                        ),
                      ],
                    ),

                    SizedBox(height: Dimensions.height30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
