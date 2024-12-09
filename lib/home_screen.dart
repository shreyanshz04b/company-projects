import 'package:flutter/material.dart';
import 'package:hireflix/home_page.dart';
import 'package:hireflix/interview_preparation_screen.dart';
import 'package:hireflix/user_profile_screen.dart';
import 'package:hireflix/notifications_screen.dart';
import 'package:hireflix/company_info_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
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
    final screenWidth = MediaQuery.of(context).size.width;

    // List of screens to navigate
    List<Widget> _screens = [
      HomePage(),
      InterviewPreparationScreen(),
      UserProfileScreen(),
      NotificationsScreen(),
      CompanyInfoPage(),
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Dark Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // SafeArea content with selected screen
            SafeArea(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: screenWidth < 600 ? 24.0 : 30.0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, size: screenWidth < 600 ? 24.0 : 30.0),
            label: 'Interview Preparation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: screenWidth < 600 ? 24.0 : 30.0),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: screenWidth < 600 ? 24.0 : 30.0),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business, size: screenWidth < 600 ? 24.0 : 30.0),
            label: 'Company Finder',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.yellow,
        onTap: _onItemTapped,
        iconSize: screenWidth < 600 ? 24.0 : 32.0,
      ),
    );
  }
}
