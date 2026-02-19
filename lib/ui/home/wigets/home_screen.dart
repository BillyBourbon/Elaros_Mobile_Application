// home page. routes to the other views.
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
      appBar: AppBar(title: const Text('Home Screen')),
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
        return const Center(child: Text('Home'));
      case 1:
        return const Center(child: Text('Health Tips'));
      case 2:
        return const Center(child: Text('HR Zone'));
      case 3:
        return const Center(child: Text('Profile'));
      default:
        return const Center(child: Text('Home'));
    }
  }
}
