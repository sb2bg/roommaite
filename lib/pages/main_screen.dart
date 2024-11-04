import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:roommaite/pages/matches_page.dart';
import 'package:roommaite/pages/profile_page.dart';
import 'package:roommaite/pages/search_page.dart';
import 'package:roommaite/util/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    // HomePage(),
    const SearchPage(),
    const MatchesPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            tabBackgroundColor: AppColors.purple,
            color: Colors.white,
            textStyle: const TextStyle(color: Colors.white),
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 200),
            tabs: const [
              // GButton(
              //   icon: CupertinoIcons.home,
              //   text: 'Home',
              // ),
              GButton(
                iconActiveColor: Colors.white,
                icon: CupertinoIcons.person_2_alt,
                text: 'Search',
              ),
              GButton(
                icon: CupertinoIcons.heart,
                iconActiveColor: Colors.white,
                text: 'Matches',
              ),
              GButton(
                icon: CupertinoIcons.person,
                iconActiveColor: Colors.white,
                text: 'Profile',
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
