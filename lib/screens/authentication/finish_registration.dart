// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:powershare/utils/pick_image.dart';
import 'package:powershare/utils/power_share_heading.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/show_snack_bar.dart';
import '../../utils/small_text.dart';
import '../terms/payment_terms.dart';
import '../terms/privacy_policy.dart';
import '../terms/terms_service.dart';
import 'firebase_auth_methods.dart';

class RegistrationScreen extends StatefulWidget {
  final String phoneNumber;
  const RegistrationScreen({super.key, required this.phoneNumber});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _comfirmPasswordController =
      TextEditingController();
  Uint8List? _image;

  final _formKey = GlobalKey<FormState>();

  var _firstName = '';
  var _lastName = '';
  var _userEmail = '';
  var _userPassword = '';
  bool _isLoading = false;

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  bool _termsAccepted = false;

// THIS METHOD CHECKS IF THE TERMS CHECK BOX IS TICKED.
  void _onTermsAccepted(bool? value) {
    setState(() {
      _termsAccepted = value ?? false;
    });
  }

// THIS FUNCTIONS PICKS AN IMAGE FROM THE GALLERY
  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

//THIS METHOD CONTROLS PASSWORD VISIBLITY
  void _toggleObscured() {
    setState(
      () {
        _obscured = !_obscured;
        if (textFieldFocusNode.hasPrimaryFocus) {
          return; // If focus is on text field, don't unfocus
        }
        textFieldFocusNode.canRequestFocus =
            false; // Prevents focus if tap on eye
      },
    );
  }

//THIS METHOD  CHECKS IF PASSWORD IS NOT ALL INTEGERS
  bool hasNonNumeric(String password) {
    final RegExp regex = RegExp(r'[^0-9]');
    return regex.hasMatch(password);
  }

// THIS METHOD INVOKES ALL THE FORM VALIDATORS WHEN THE SIGNUP BUTTON IS CLICKED.
  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();

    /* Remove the cursor on submiting the form  */
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      // this triggers all the save functions in the form
      _formKey.currentState!.save();

      // use the values to send auth request.

      String response = await FirebaseAuthMethods().signUpWithEmail(
        email: _userEmail,
        password: _userPassword,
        firstName: _firstName,
        lastName: _lastName,
        context: context,
        file: _image!,
        phoneNumber: widget.phoneNumber,
      );

      setState(() {
        _isLoading = false;
      });

      if (response != 'success') {
        showSnackBar(context, response);
      }
    }
  }

// THIS METHOD DISPOSES THE CONTROLLERS AFTER THEY ARE USED.
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _comfirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width30),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.height30),

                  const Center(child: PowerShareHeading()),

                  SizedBox(height: Dimensions.height20),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(width: Dimensions.width30 * 4),
                      Text(
                        'Finish Signing up',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: Dimensions.font20,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: Dimensions.height20),

                  // PROFILE IMAGE
                  Center(
                    child: Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: Dimensions.width30 * 2.5,
                                backgroundColor: whiteColor,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : CircleAvatar(
                                radius: Dimensions.width30 * 2.5,
                                backgroundColor: greyColor,
                                backgroundImage: const NetworkImage(
                                  'data:image/png;base64,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',
                                ),
                              ),
                        Positioned(
                          bottom: -2,
                          left: 90,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo_outlined),
                            color: greenColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // PROFILE IMAGE

                  SizedBox(height: Dimensions.height20),

                  // FIRST NAME INPUT
                  TextFormField(
                    key: const ValueKey('firstName'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _firstName = value!;
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
                      labelText: 'First name',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // LAST NAME INPUT
                  TextFormField(
                    key: const ValueKey('lastName'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _lastName = value!;
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
                      labelText: 'Last name',
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                    ),
                  ),

                  SizedBox(height: Dimensions.height8),

                  SizedBox(height: Dimensions.height20),

                  // EMAIL INPUT FIELD
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !value.contains('@') ||
                          !value.contains('.com')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Theme.of(context).primaryColor,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.font16,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: Dimensions.font15,
                        color: Theme.of(context).primaryColor,
                      ),
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                    ),
                  ),

                  SizedBox(height: Dimensions.height8),
                  SmallText(
                    text:
                        "Make sure your Email is correct, you will have to confirm it.",
                  ),
                  SizedBox(height: Dimensions.height8),

                  SmallText(
                    text: "We'll send you notifications.",
                  ),
                  SizedBox(height: Dimensions.height20),

                  SmallText(
                    text:
                        "Choose a strong password. Use a mixture of letters and characters",
                  ),
                  SizedBox(height: Dimensions.height10 / 2),

                  // PASSWORD ONPUT
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return 'Password must be atleast 8 characters long.';
                      } else if (!hasNonNumeric(value)) {
                        return 'Password can not be all intergers.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    controller: _passwordController,
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
                      labelText: 'Password',
                      border: inputBorder,
                      suffixIcon: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                            _obscured
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            size: Dimensions.iconSize24,
                            color: greyColor),
                      ),
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscured,
                    focusNode: textFieldFocusNode,
                  ),

                  SizedBox(height: Dimensions.height10),

                  // AGREE TO THE TERMS AND CONDITIONS.
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    checkColor: isDark ? blackColor : whiteColor,
                    activeColor: Theme.of(context).primaryColor,
                    selectedTileColor: Colors.transparent,
                    value: _termsAccepted,
                    onChanged: _onTermsAccepted,
                    contentPadding: const EdgeInsets.all(0),
                    title: Column(
                      children: [
                        Row(
                          children: [
                            SmallText(
                              text: "I agree to PowerShares's ",
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) {
                                      return const TermsOfService();
                                    },
                                  ),
                                );
                              },
                              child: SmallText(
                                text: 'Terms of service, ',
                                color: blueColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) {
                                      return const PaymentsTermsOfservice();
                                    },
                                  ),
                                );
                              },
                              child: SmallText(
                                text: 'Payments terms of service, ',
                                color: blueColor,
                              ),
                            ),
                            SmallText(
                              text: 'and ',
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) {
                                      return const PrivacyPolicy();
                                    },
                                  ),
                                );
                              },
                              child: SmallText(
                                text: 'privacy policy.',
                                color: blueColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.height20),

                  // SIGN UP BUTTON
                  _termsAccepted
                      ? GestureDetector(
                          onTap: _trySubmit,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.height15,
                            ),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    Dimensions.radius20 / 2,
                                  ),
                                ),
                              ),
                              color: isDark ? deepGreen : greenColor,
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: Dimensions.width20,
                                    height: Dimensions.height20,
                                    child: const CircularProgressIndicator(
                                      color: whiteColor,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : SmallText(
                                    text: "Sign Up",
                                    color: whiteColor,
                                    size: Dimensions.font15,
                                  ),
                          ),
                        )
                      : GestureDetector(
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height15),
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimensions.radius20 / 2),
                                ),
                              ),
                              color: isDark
                                  ? darkSearchBarColor
                                  : buttonBackgroundColor,
                            ),
                            child: SmallText(
                              text: "Signup",
                              size: Dimensions.font15,
                              color: isDark ? greyColor : whiteColor,
                            ),
                          ),
                        ),
                  // SIGN UP BUTTO

                  SizedBox(height: Dimensions.height20 * 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
