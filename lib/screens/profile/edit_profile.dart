// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utils/dimensions.dart';
import '../../utils/colors.dart';
import '../../utils/pick_image.dart';
import '../../utils/show_snack_bar.dart';
import '../../utils/small_text.dart';
import '../../utils/storage_methods.dart';
import '../../widgets/buttons/multipurpose_button.dart';
import '../../widgets/navigation.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  final _formKey = GlobalKey<FormState>();
  Uint8List? _selectedImage;
  bool _isLoading = false;
  String _name = '';
  String _phoneNumber = '';
  String _imageUrl = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    ;
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _name = userData['name'] ?? '';
        _phoneNumber = userData['phoneNumber'] ?? '';
        _imageUrl = userData['imageUrl'];

        _nameController.text = _name;
        _phoneNumberController.text = _phoneNumber;
      });
    } catch (error) {
      // Handle error
    }
  }

  Future<void> _selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    /* Remove the cursor on submiting the form  */
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      String imageUrl = await StorageMethods()
          .uploadImage('users/profilePics/$_name', _selectedImage!);
      try {
        FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': _name,
          'phoneNumber': _phoneNumber,
          'imageUrl': imageUrl,
        });
        setState(() {
          _isLoading = false;
        });

        Navigator.pop(context);
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        return showSnackBar(context, 'Oops! something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // DEFINIMG THE INPUT BORDER STRUCTURE
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context,
          color: Theme.of(context).primaryColor, width: 0.5),
      borderRadius: BorderRadius.all(
        Radius.circular(
          Dimensions.radius20 / 2,
        ),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
          top: Dimensions.height30,
          left: Dimensions.width20,
          right: Dimensions.width20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopNavigation(
                text: 'Edit your profile',
                icon: Icons.arrow_back_outlined,
              ),
              SizedBox(height: Dimensions.height20),
              Center(
                child: Stack(
                  children: [
                    _imageUrl.isNotEmpty
                        ? _selectedImage != null
                            ? CircleAvatar(
                                radius: Dimensions.radius30 * 3,
                                backgroundImage: MemoryImage(_selectedImage!),
                                backgroundColor:
                                    isDark ? darkSearchBarColor : whiteColor,
                              )
                            : CircleAvatar(
                                radius: Dimensions.radius30 * 3,
                                backgroundImage: NetworkImage(_imageUrl),
                                backgroundColor:
                                    isDark ? darkSearchBarColor : whiteColor,
                              )
                        : CircleAvatar(
                            radius: Dimensions.radius30 * 3,
                            backgroundColor: greenColor,
                            child: Text(
                              _name.isNotEmpty ? _name[0] : '',
                              style: TextStyle(
                                fontSize: Dimensions.font20 * 2.5,
                                color: whiteColor,
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: -2,
                      left: 120,
                      child: IconButton(
                        onPressed: _selectImage,
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          color: _imageUrl.isEmpty
                              ? Theme.of(context).primaryColor
                              : greenColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.height20),
              SmallText(text: 'Name'),
              SizedBox(height: Dimensions.height10),
              TextFormField(
                controller: _nameController,
                onChanged: (value) {
                  _name = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              SmallText(text: 'Phone number'),
              SizedBox(height: Dimensions.height10),
              TextFormField(
                controller: _phoneNumberController,
                onChanged: (value) {
                  _phoneNumber = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 10) {
                    return 'Your phone number must have 10 digits.';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
              ),
              SizedBox(height: Dimensions.height30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _submitForm,
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: greenColor,
                            ),
                          )
                        : MultipurposeButton(
                            text: "Save",
                            textColor: whiteColor,
                            backgroundColor:
                                isDark ? darkSearchBarColor : blackColor,
                          ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height30),
            ],
          ),
        ),
      ),
    ));
  }
}
