import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:powershare/screens/inbox/inbox_home.dart';
import 'package:powershare/screens/tenants/home_screen.dart';
import 'package:powershare/screens/tenants/my_payments.dart';
import 'package:powershare/screens/tenants/other_tenants.dart/other_tenants.dart';
import 'package:powershare/utils/colors.dart';
import '../../utils/dimensions.dart';
import 'account/tenant_account_home_screen.dart';

class TenantMainScreen extends StatefulWidget {
  final String landLordName;
  final String apartmentName;
  const TenantMainScreen({
    super.key,
    this.landLordName = 'Uknown',
    this.apartmentName = 'unknown',
  });

  @override
  State<TenantMainScreen> createState() => _TenantMainScreenState();
}

class _TenantMainScreenState extends State<TenantMainScreen> {
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
      TenantsHomeScreen(
        apartmentName: widget.apartmentName,
        landLordName: widget.landLordName,
      ),
      const MyPaymentsScreen(),
      const OtherTenantsScreen(),
      const InboxFeedScreen(),
      const TenantAccountHomeScreen(),
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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.payments_outlined),
            activeIcon: Icon(Icons.payments_outlined),
            label: "Payments",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            activeIcon: Icon(Icons.people_outlined),
            label: "Other tenants",
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
