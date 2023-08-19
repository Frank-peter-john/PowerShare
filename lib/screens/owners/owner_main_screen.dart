import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:powershare/screens/inbox/inbox_home.dart';
import 'package:powershare/screens/owners/account/owner_account_home.dart';
import 'package:powershare/screens/owners/account/tenants_payments.dart';
import 'package:powershare/screens/owners/apartment/my_tenants.dart';
import 'package:powershare/screens/owners/tenant_bills.dart';
import 'package:powershare/utils/colors.dart';
import '../../utils/dimensions.dart';

class OwnerMainScreen extends StatefulWidget {
  final String apartmentName;
  final String location;
  const OwnerMainScreen({
    super.key,
    this.apartmentName = '',
    this.location = '',
  });

  @override
  State<OwnerMainScreen> createState() => _OwnerMainScreenState();
}

class _OwnerMainScreenState extends State<OwnerMainScreen> {
  int _selectedIndex = 0;

  void onTapNav(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // List of all pages.
    List pages = [
      MyTenantsScreen(
        apartmentName: widget.apartmentName,
        location: widget.location,
      ),
      const TenantsBillsScreen(),
      const PaymentsScreen(),
      const InboxFeedScreen(),
      const OwnerAccountHomeScreen(),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDark ? blackColor : whiteColor,
        useLegacyColorScheme: false,
        iconSize: Dimensions.iconSize24,
        selectedItemColor: greenColor,
        unselectedItemColor: greyColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex /*shows which icon is active*/,
        selectedFontSize: 0.0,
        unselectedFontSize: 0.0,
        onTap: onTapNav,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            activeIcon: Icon(Icons.people_outlined),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt_outlined),
            label: "Bills",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.payments_outlined),
            activeIcon: Icon(Icons.payments_outlined),
            label: "Payments",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/svgs/message-regular.svg',
              width: Dimensions.iconSize22,
              height: Dimensions.iconSize22,
              color: greyColor,
            ),
            activeIcon: SvgPicture.asset(
              'assets/svgs/message-regular.svg',
              width: Dimensions.iconSize24,
              height: Dimensions.iconSize24,
              color: isDark ? whiteColor : greenColor,
            ),
            label: "inbox",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person_outline),
            label: "profile",
          )
        ],
      ),
    );
  }
}
