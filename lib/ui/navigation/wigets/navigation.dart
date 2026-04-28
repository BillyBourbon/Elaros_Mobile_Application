// home page. routes to the other views.
import 'package:elaros_mobile_app/ui/common/widgets/bottom_navbar.dart';
import 'package:elaros_mobile_app/ui/home_page/widgets/home_page.dart';
import 'package:elaros_mobile_app/ui/hr_zones_page/widgets/hr_zone.dart';
import 'package:elaros_mobile_app/ui/profile_page/wigets/profile_screen.dart';
import 'package:elaros_mobile_app/ui/test_page_three/wigets/test_page_three_new.dart';
import 'package:elaros_mobile_app/ui/user_goals/widgets/user_goals_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        return HomePage();
      case 1:
        return const Center(child: Text('Health Tips'));
      case 2:
        return HrZoneScreen();
      case 3:
        return ProfileScreen();
      case 4:
        return UserGoalsScreen();
      case 5:
        return TestPageThree();
      default:
        return HomePage();
    }
  }
}
