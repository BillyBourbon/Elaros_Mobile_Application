import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety),
          label: 'Health Tips',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'HR Zone'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Goals'),
        BottomNavigationBarItem(icon: Icon(Icons.square), label: 'Test 3'),
      ],
      currentIndex: selectedIndex,
      onTap: onTap,
      backgroundColor: colorScheme.primary,
      selectedItemColor: colorScheme.onPrimary,
      unselectedItemColor: Colors.black38,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: theme.textTheme.labelMedium,
      unselectedLabelStyle: theme.textTheme.labelSmall,
      elevation: 0.4,
    );
  }
}
