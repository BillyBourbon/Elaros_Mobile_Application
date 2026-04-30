// home page. routes to the other views.
import 'package:elaros_mobile_app/ui/common/widgets/bottom_navbar.dart';
import 'package:elaros_mobile_app/ui/health_tips_page/widgets/health_tips_page.dart';
import 'package:elaros_mobile_app/ui/home_page/widgets/home_page.dart';
import 'package:elaros_mobile_app/ui/hr_zones_page/widgets/hr_zone.dart';
import 'package:elaros_mobile_app/ui/profile_page/wigets/profile_screen.dart';
import 'package:elaros_mobile_app/ui/user_goals/widgets/user_goals_screen.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return HomeScreen();
      case 1:
        return HealthTipsScreen();
      case 2:
        return HrZoneScreen();
      case 3:
        return ProfileScreen();
      case 4:
        return UserGoalsScreen();
      default:
        return HomeScreen();
    }
  }
}
