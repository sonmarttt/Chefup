import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/welcome_screen.dart';
import 'home/discovery_screen.dart';
import 'home/my_posts_screen.dart';
import '../services/auth_service.dart';

class MainWrapper extends StatefulWidget {
  final bool isGuest;
  const MainWrapper({super.key, this.isGuest = false});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 1; // Default to Home
  final AuthService _authService = AuthService();

  final List<Widget> _screens = [
    Placeholder(), // Saved (Placeholder)
    DiscoveryScreen(),
    MyPostsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If guest, we don't check auth stream, we just show the app.
    if (widget.isGuest) {
      return _buildScaffold();
    }

    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // If waiting, show loading? Or just show nothing.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // If no user, show Welcome
        if (!snapshot.hasData) {
          return WelcomeScreen();
        }

        // If user, show App
        return _buildScaffold();
      },
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFF1E1E1E), // Dark background for nav bar
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.bookmark, color: _selectedIndex == 0 ? Colors.white : Colors.grey),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.home, color: _selectedIndex == 1 ? Colors.white : Colors.grey),
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: Icon(Icons.menu_book, color: _selectedIndex == 2 ? Colors.white : Colors.grey),
              onPressed: () => _onItemTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}
