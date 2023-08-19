import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:powershare/screens/authentication/login.dart';
import 'package:powershare/screens/tenants/join_apartment.dart';
import 'package:powershare/utils/colors.dart';
import 'package:provider/provider.dart';
import '../../../utils/big_text.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/small_text.dart';
import '../../../widgets/buttons/button.dart';
import '../../../widgets/buttons/multipurpose_button.dart';
import '../../profile/profile.dart';
import '../../terms/privacy_policy.dart';
import '../../terms/terms_service.dart';
import '../../themes/theme_provider.dart';
import 'manage_apartments.dart';

class OwnerAccountHomeScreen extends StatelessWidget {
  const OwnerAccountHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final User currentUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String name = snapshot.data!['name'];
          String imageUrl = snapshot.data!['imageUrl'];
          return Scaffold(
            body: Container(
              margin: EdgeInsets.only(
                top: Dimensions.width20,
                left: Dimensions.width10,
                right: Dimensions.width10,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: BigText(
                        text: 'My account',
                        size: Dimensions.font26,
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return ProfileScreen();
                        }));
                      },
                      child: Row(
                        children: [
                          //  USER'S PROFILE IMAGE
                          imageUrl.isNotEmpty
                              ? CircleAvatar(
                                  radius: Dimensions.radius20 * 2,
                                  backgroundImage: NetworkImage(imageUrl),
                                  backgroundColor: isDark
                                      ? darkSearchBarColor
                                      : buttonBackgroundColor,
                                )
                              : CircleAvatar(
                                  radius: Dimensions.radius20 * 2,
                                  backgroundColor: greenColor1,
                                  child: SmallText(
                                    text: name[0].toUpperCase(),
                                    color: whiteColor,
                                    size: Dimensions.font26,
                                  ),
                                ),
                          SizedBox(width: Dimensions.height15),

                          // USER'S FIRSTNAME
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SmallText(
                                  text: name,
                                  size: Dimensions.font18,
                                ),
                                SizedBox(height: Dimensions.height7 / 2),
                                SmallText(
                                  text: 'Show profile',
                                  color: greyColor,
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.arrow_forward_ios,
                            size: Dimensions.iconSize22,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Dimensions.height20),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: Dimensions.height20,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: isDark
                              ? const BorderSide(
                                  color: greyColor,
                                  width: 0.5,
                                )
                              : const BorderSide(
                                  color: greyColor,
                                  width: 0.3,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height10),

                    SizedBox(height: Dimensions.height30),

                    // SETTINGS SECTION
                    BigText(
                      text: 'Settings',
                      size: Dimensions.font18,
                    ),
                    SizedBox(height: Dimensions.height20),

                    // CHANGE THEME
                    Padding(
                      padding: EdgeInsets.only(right: Dimensions.width20),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: isDark
                                ? const BorderSide(
                                    color: greyColor,
                                    width: 0.5,
                                  )
                                : const BorderSide(
                                    color: greyColor,
                                    width: 0.3,
                                  ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.wb_sunny_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: Dimensions.width20),
                            Expanded(
                              child: SmallText(
                                text: 'Change theme',
                                size: Dimensions.font15,
                              ),
                            ),
                            Consumer<ThemeProvider>(
                                builder: (context, provider, child) {
                              return DropdownButton<String>(
                                value: provider.currentTheme,
                                underline: Container(),
                                iconEnabledColor: greyColor,
                                iconSize: Dimensions.iconSize30,
                                alignment: AlignmentDirectional.bottomStart,
                                focusColor: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius15),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'light',
                                    child: BigText(
                                      text: 'Light',
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'dark',
                                    child: BigText(
                                      text: 'Dark',
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'system',
                                    child: BigText(
                                      text: 'System',
                                    ),
                                  ),
                                ],
                                onChanged: (String? value) {
                                  provider.changeTheme(value ?? 'system');
                                },
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                    // CHANGE THEME

                    SizedBox(height: Dimensions.height20),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return const ManageApartmentScreen();
                        }));
                      },
                      child: const Button(
                        color: whiteColor,
                        iconLeft: Icons.apartment_outlined,
                        text: "My apartments",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) {
                          return const JoinApartmentScreen();
                        }));
                      },
                      child: const Button(
                        color: whiteColor,
                        iconLeft: Icons.apartment_outlined,
                        text: "Change to tenant",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: Icons.security_outlined,
                        text: "Two factor authentication",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: Icons.notifications_outlined,
                        text: "Notifications",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    // SETTINGS SECTION

                    SizedBox(height: Dimensions.height20),

                    // SUPPORT SECTION
                    BigText(
                      text: 'Support',
                      size: Dimensions.font18,
                    ),
                    SizedBox(height: Dimensions.height20),

                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: CupertinoIcons.question_circle,
                        text: "Get help",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Button(
                        color: whiteColor,
                        iconLeft: CupertinoIcons.question,
                        text: "FAQ'S",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),
                    // SUPPORT SECTION

                    SizedBox(height: Dimensions.height20),

                    // LEGAL SECTION
                    BigText(
                      text: 'Legal',
                      size: Dimensions.font18,
                    ),
                    SizedBox(height: Dimensions.height20),

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
                      child: const Button(
                        color: whiteColor,
                        iconLeft: CupertinoIcons.book,
                        text: "Terms of service",
                        iconRight: Icons.arrow_forward_ios,
                      ),
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
                      child: const Button(
                        color: whiteColor,
                        iconLeft: CupertinoIcons.lock,
                        text: "Privacy policy",
                        iconRight: Icons.arrow_forward_ios,
                      ),
                    ),

                    SizedBox(height: Dimensions.height20),

                    // LOG OUT BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) {
                                return AlertDialog(
                                  title: const BigText(
                                    text: 'Logout',
                                  ),
                                  content: SmallText(
                                    text: 'Are you sure you want to log out?',
                                    size: Dimensions.font14,
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // CANCEL LOGOUT
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: MultipurposeButton(
                                            text: "Cancel",
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            textColor: isDark
                                                ? blackColor
                                                : whiteColor,
                                          ),
                                        ),

                                        // LOGOUT
                                        GestureDetector(
                                          onTap: () {
                                            FirebaseAuth.instance.signOut();
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (ctx) {
                                              return const LoginScreen();
                                            }));
                                          },
                                          child: const MultipurposeButton(
                                            text: "Logout",
                                            backgroundColor: greenColor,
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
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: const BigText(text: 'Log out'),
                          ),
                        ),
                        // LOG OUT BUTTON

                        // VERSION NUMBER
                        FutureBuilder<PackageInfo>(
                          future: PackageInfo.fromPlatform(),
                          builder:
                              (context, AsyncSnapshot<PackageInfo> snapshot) {
                            if (snapshot.hasData) {
                              return SmallText(
                                text: 'Version ${snapshot.data!.version}',
                                color: isDark ? greyColor : blackColor,
                                size: Dimensions.font12,
                              );
                            } else {
                              return const CircularProgressIndicator(
                                color: greyColor,
                              );
                            }
                          },
                        ),
                        //  VERSION NUMBER
                      ],
                    ),

                    SizedBox(height: Dimensions.height30),
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SmallText(
                  text: 'Oops!, something went wrong.',
                  size: Dimensions.font18,
                  color: Theme.of(context).primaryColor,
                ),
              ],
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
