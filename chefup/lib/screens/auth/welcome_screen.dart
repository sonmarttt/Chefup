import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import '../main_wrapper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("pictures/login.png"),
            fit: BoxFit.cover, //  it fill the entire screen
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 60),
            Image.asset('pictures/logo.png', width: 250, fit: BoxFit.contain),
            SizedBox(height: 390),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 55),
                backgroundColor: const Color.fromRGBO(120, 165, 90, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                "Login | Sign up",
                style: GoogleFonts.dmSerifText(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 55),
                backgroundColor: const Color.fromRGBO(238, 239, 238, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Navigates to MainWrapper as Guest

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainWrapper(isGuest: true),
                  ),
                );
              },
              child: Text(
                "Continue as Guest",
                style: GoogleFonts.dmSerifText(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
