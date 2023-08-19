import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:powershare/screens/tenants/tenant_main_screen.dart';
import 'package:powershare/utils/big_text.dart';
import 'package:powershare/utils/colors.dart';
import 'package:powershare/utils/show_snack_bar.dart';
import 'package:powershare/utils/small_text.dart';

import 'package:powershare/widgets/navigation.dart';
import '../../utils/dimensions.dart';
import '../../widgets/buttons/multipurpose_button.dart';

class AddApplianceScreen extends StatefulWidget {
  const AddApplianceScreen({super.key});

  @override
  State<AddApplianceScreen> createState() => _AddApplianceScreenState();
}

class _AddApplianceScreenState extends State<AddApplianceScreen> {
  final TextEditingController _wattsController = TextEditingController();

  String? _selectedAppliance;
  bool _isLoading = false;
  double _watts = 0.0;
  int _quantity = 1;

  final _formKey = GlobalKey<FormState>();

  // Average usage time of appliances
  static const refrigeratorUsagetime = 12;
  static const tvUsageTime = 4;
  static const microwaveUsageTime = 1;
  static const washMachineUsageTime = 6;
  static const ovenUsageTime = 1;
  static const dishWasherUsageTime = 2;
  static const acUsageTime = 12;
  static const fanUsageTime = 8;
  static const coffeeMakerUsageTime = 1;
  static const toasterUsageTime = 2;
  static const blenderUsageTime = 1;
  static const juicerUsageTime = 1;
  static const ironerUsageTime = 1;

  // Average wattage of each appliance
  static const refrigeratorWattage = 600;
  static const tvWattage = 400;
  static const washMachineWattage = 700;
  static const microwaveWattage = 500;
  static const ovenWattage = 1000;
  static const dishWattage = 1200;
  static const acWattage = 1000;
  static const fanWattage = 60;
  static const coffeMakerWattage = 800;
  static const toasterWattage = 750;
  static const blenderWattage = 300;
  static const juicerWattage = 300;
  static const ironerWattage = 1000;

  List<String> homeAppliances = [
    'Refrigerator',
    'Television',
    'Washing Machine',
    'Microwave',
    'Oven',
    'Dishwasher',
    'Air Conditioner',
    'iron',
    'Fan',
    'Coffee Maker',
    'Toaster',
    'Blender',
    'Juicer',
  ];

  int getWattage() {
    switch (_selectedAppliance) {
      case 'Refrigerator':
        return refrigeratorWattage;
      case 'Television':
        return tvWattage;
      case 'Washing Machine':
        return washMachineWattage;
      case 'Microwave':
        return microwaveWattage;
      case 'Oven':
        return ovenWattage;
      case 'Dishwasher':
        return dishWattage;
      case 'Air Conditioner':
        return acWattage;
      case 'Iron':
        return ironerWattage;
      case 'Fan':
        return fanWattage;
      case 'Coffee Maker':
        return coffeMakerWattage;
      case 'Toaster':
        return toasterWattage;
      case 'Blender':
        return blenderWattage;
      case 'Juicer':
        return juicerWattage;
      default:
        return 0;
    }
  }

  void _addAppliance() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      // Get the current user UID
      String uid = FirebaseAuth.instance.currentUser!.uid;

      try {
        // Create a reference to the user document
        final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);

        // Create a reference to the appliances subcollection
        final appliancesCollection = userDoc.collection('appliances');

        // Create a document for the selected appliance with the name as the document ID
        final applianceDoc = appliancesCollection.doc(_selectedAppliance);
        var usageTime = 0;
        var totalDailyUnits = 0.0;

        switch (_selectedAppliance) {
          case 'Refrigerator':
            usageTime = refrigeratorUsagetime;
            _watts = refrigeratorWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Television':
            usageTime = tvUsageTime;
            _watts = tvWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Washing Machine':
            usageTime = washMachineUsageTime;
            _watts = washMachineWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Microwave':
            usageTime = microwaveUsageTime;
            _watts = microwaveWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Oven':
            usageTime = ovenUsageTime;
            _watts = ovenWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Dishwasher':
            usageTime = dishWasherUsageTime;
            _watts = dishWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Air Conditioner':
            usageTime = acUsageTime;
            _watts = acWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'iron':
            usageTime = ironerUsageTime;
            _watts = ironerWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Fan':
            usageTime = fanUsageTime;
            _watts = fanWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Coffee Maker':
            usageTime = coffeeMakerUsageTime;
            _watts = coffeMakerWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Toaster':
            usageTime = toasterUsageTime;
            _watts = toasterWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Blender':
            usageTime = blenderUsageTime;
            _watts = blenderWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
          case 'Juicer':
            usageTime = juicerUsageTime;
            _watts = juicerWattage.toDouble();
            totalDailyUnits = _watts * usageTime * _quantity / 1000;
            break;
        }

        // Set the data for the appliance document
        await applianceDoc.set({
          'name': _selectedAppliance,
          'watts': _watts,
          'quantity': _quantity,
          'usageTime': usageTime,
          'totalDailyUnits': totalDailyUnits,
        });

        // Update the totalWatts field in the UID document
        final userData = await userDoc.get();
        final currentTotalWatts = userData['totalWatts'] ?? 0;
        final newTotalWatts = currentTotalWatts + (_watts * _quantity);
        await userDoc.update({'totalWatts': newTotalWatts});

        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return const TenantMainScreen();
        }));

        // Clear the form fields
        _formKey.currentState!.reset();
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        // Handle any errors that occur during the data submission
        showSnackBar(
            context, 'Oops!, sorry something went wrong, please try again.');
        // Show a snackbar or an error message to the user
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _wattsController.dispose();
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
      body: Container(
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
                text: 'Add your appliance',
                icon: Icons.arrow_back_outlined,
              ),
              SizedBox(height: Dimensions.height30),

              // APPLIANCE INPUT FIELD
              SmallText(
                text: 'Appliance name',
                size: Dimensions.font16,
              ),
              SizedBox(height: Dimensions.height7),
              DropdownButtonFormField<String>(
                value: _selectedAppliance,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAppliance = newValue;
                  });
                },
                items: homeAppliances
                    .map<DropdownMenuItem<String>>((String appliance) {
                  return DropdownMenuItem<String>(
                    value: appliance,
                    child: Text(appliance),
                  );
                }).toList(),
                menuMaxHeight: 300,
                iconEnabledColor: Theme.of(context).primaryColor,
                iconSize: Dimensions.iconSize24,
                alignment: AlignmentDirectional.bottomStart,
                focusColor: Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                decoration: InputDecoration(
                  labelText: 'Select Appliance name',
                  labelStyle: TextStyle(
                    fontSize: Dimensions.font15,
                    color: Theme.of(context).primaryColor,
                  ),
                  border: inputBorder,
                  focusedBorder: inputBorder,
                ),
              ),

              SizedBox(height: Dimensions.height20),

              //  NUMBER OF APPLIANCES.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmallText(text: 'Select number of appliances'),
                  DropdownButton<int>(
                    value: _quantity,
                    onChanged: (int? newValue) {
                      setState(() {
                        _quantity = newValue!;
                      });
                    },
                    items: List<DropdownMenuItem<int>>.generate(
                      20,
                      (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text((index + 1).toString()),
                      ),
                    ),
                    iconSize: Dimensions.iconSize30,
                    menuMaxHeight: 300,
                    borderRadius: BorderRadius.circular(Dimensions.radius20),
                    focusColor: Colors.transparent,
                  ),
                ],
              ),

              SizedBox(height: Dimensions.height30),

              // WATTAGE FIELD
              _selectedAppliance != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmallText(
                          text: 'Number of watts of a $_selectedAppliance.',
                          size: Dimensions.font16,
                        ),
                        SizedBox(width: Dimensions.width8),
                        BigText(text: getWattage().toString())
                      ],
                    )
                  : Container(),

              SizedBox(height: Dimensions.height30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _isLoading
                      ? SizedBox(
                          height: Dimensions.height30,
                          width: Dimensions.width30,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 2.5,
                          ),
                        )
                      : GestureDetector(
                          onTap: _addAppliance,
                          child: MultipurposeButton(
                            text: 'Add',
                            textColor: whiteColor,
                            backgroundColor: isDark ? greenColor : blackColor,
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
