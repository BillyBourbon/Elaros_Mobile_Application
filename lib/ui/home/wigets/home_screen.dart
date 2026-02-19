// home page. routes to the other views.
import 'package:elaros_mobile_app/ui/test_page/wigets/test_page.dart';
import 'package:elaros_mobile_app/ui/profile_page/wigets/profile_screen.dart';
import 'package:elaros_mobile_app/ui/test_page/wigets/test_page.dart';
import 'package:elaros_mobile_app/ui/user_goals/wigets/user_goals_screen.dart';
import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Center,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:elaros_mobile_app/ui/common/widgets/bottom_navbar.dart';

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
      appBar: AppBar(title: const Text('Elaros Mobile Health App'), centerTitle: true),
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
        return TestPage();
      case 3:
        return ProfileScreen();
      case 4:
        return UserGoalsScreen();
      default:
        return const Center(child: Text('Home'));
    }
  }
}
