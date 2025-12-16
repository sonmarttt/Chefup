import 'package:chefup/screens/home/saved_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/welcome_screen.dart';
import 'home/discovery_screen.dart';
import 'home/saved_screen.dart';
import 'home/fruit_screen.dart';
import 'home/my_posts_screen.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';

class MainWrapper extends StatefulWidget {
  final bool isGuest;
  const MainWrapper({super.key, this.isGuest = false});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 1;
  final AuthService _authService = AuthService();

  final List<Widget> _screens = [
    SavedScreen(),
    DiscoveryScreen(),
    FruitScreen(),
    MyPostsScreen(),
  ];

  void _showLoginPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Login Required",
            style: GoogleFonts.dmSerifText(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "You need to be logged in to access this feature.",
            style: GoogleFonts.dmSerifText(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: GoogleFonts.dmSerifText(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(120, 165, 90, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Login",
                style: GoogleFonts.dmSerifText(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    if (isGuest && index != 1) {
      _showLoginPrompt(context);
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If guest just show the app.
    if (widget.isGuest) {
      return _buildScaffold();
    }

    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData) {
          return WelcomeScreen();
        }

        return _buildScaffold();
      },
    );
  }

  Widget _buildScaffold() {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        color: const Color(0xFF1E1E1E), // Dark background for nav bar
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Saved Screen - Protected
            IconButton(
              icon: Icon(
                Icons.bookmark,
                color: _selectedIndex == 0 ? Colors.white : Colors.grey,
              ),
              onPressed: () => _onItemTapped(0),
            ),
            // Discovery Screen - Public (accessible to all)
            IconButton(
              icon: Icon(
                Icons.restaurant_menu,
                color: _selectedIndex == 1 ? Colors.white : Colors.grey,
              ),
              onPressed: () => _onItemTapped(1),
            ),
            // Fruit/Shopping List Screen - Protected
            IconButton(
              icon: Icon(
                Icons.list,
                color: _selectedIndex == 2 ? Colors.white : Colors.grey,
              ),
              onPressed: () => _onItemTapped(2),
            ),
            // My Posts Screen - Protected
            IconButton(
              icon: Icon(
                Icons.menu_book,
                color: _selectedIndex == 3 ? Colors.white : Colors.grey,
              ),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
