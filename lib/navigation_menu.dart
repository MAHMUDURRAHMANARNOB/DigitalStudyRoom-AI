import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:digital_study_room/utils/helpers/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

import 'features/courses/Screens/courses.dart';
import 'features/home/screens/home.dart';
import 'features/profile/profile_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedMobileIndex = 0;

  @override
  Widget build(BuildContext context) {
    final darkMode = THelperFunction.isDarkMode(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        _onWillPop();
      },
      child: Scaffold(
        body: Center(
          child: Container(
            child: _getSelectedMobileScreen(_selectedMobileIndex),
          ),
        ),
        bottomNavigationBar: NavigationBar(
          // height: 80,
          elevation: 0,
          selectedIndex: _selectedMobileIndex,
          onDestinationSelected: _onItemTapped,
          backgroundColor: darkMode ? Colors.black : Colors.white,
          indicatorColor: darkMode
              ? TColors.white.withOpacity(0.3)
              : TColors.primaryColor.withOpacity(0.3),
          destinations: const [
            NavigationDestination(
                icon: Icon(
                  Iconsax.home,
                ),
                label: "Home"),
            // NavigationDestination(icon: Icon(Iconsax.book), label: "Courses"),
            /*NavigationDestination(
                icon: Icon(Iconsax.brifecase_cross), label: "Jobs"),*/
            NavigationDestination(icon: Icon(Iconsax.user), label: "Profile"),
          ],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedMobileIndex == 0) {
      // Show confirmation dialog if user is on the first item
      final shouldExit = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false), // Cancel exit
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              }, // Confirm exit
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      return shouldExit ?? false; // Handle null case (e.g., dialog dismissed)
    } else {
      // Navigate to the first item if not on the first item
      setState(() {
        _selectedMobileIndex = 0;
      });
      return false; // Prevent further navigation handling by Flutter
    }
  }

  void _onItemTapped(int index) {
    if (index == 0 && _selectedMobileIndex != 0) {
      _selectedMobileIndex = 0;
    }
    setState(() {
      _selectedMobileIndex = index;
    });
  }

  Widget _getSelectedMobileScreen(int selectedIndex) {
    Widget screen;
    switch (selectedIndex) {
      case 0:
        return const HomeScreen() /*Container(color: Colors.blue)*/;
        break;
      /*case 1:
        return const CoursesScreen() *//*Container(color: Colors.green)*//*;
        break;*/
      /*case 2:
        return const ExamScreen() Container(color: Colors.orange);
        break;*/
      case 1:
        return const ProfileScreen() /*Container(color: Colors.purple)*/;
        break;
      default:
        return const Text('Select a screen');
    }
  }
}
