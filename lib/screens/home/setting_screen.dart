import 'package:chefup/screens/home/faq_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'aboutUs_screen.dart';
import 'faq_screen.dart';
import 'privacy_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profileDetails_screen.dart';
import 'changePass_screen.dart';
import 'package:chefup/screens/auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(24, 25, 28, 100),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(140),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 30,
                    left: 25,
                    child: Container(
                      key: ValueKey('back_button'),
                      width: 50,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.pop(context),
                          child: Center(
                            child: Icon(
                              Icons.keyboard_backspace,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 80,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        "Settings",
                        style: GoogleFonts.dmSerifText(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 0,
                    right: -55,
                    child: Column(
                      children: [
                        Image.asset(
                          'pictures/discoveryFood.png',
                          width: 200,
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //settings content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      //TODO: Fetch user data dynamically to show the username and the pfp icon
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('pictures/logo.png'),
                          ),
                          SizedBox(width: 15),
                          Text(
                            "Anabelle",
                            style: GoogleFonts.dmSerifText(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    //settings Options
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            icon: Icons.person,
                            title: "Profile Details",
                            onTap: () {
                              //todo: show profile details: username and email
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfielDetailsScreen(),
                                ),
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey[200],
                          ),
                          _buildSettingsItem(
                            icon: Icons.lock,
                            title: "Change Password",
                            onTap: () {
                              //todo: change password
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ChangepassScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSettingsItem(
                            icon: Icons.privacy_tip_outlined,
                            title: "Privacy Policy",
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PrivacyScreen(),
                                ),
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey[200],
                          ),
                          _buildSettingsItem(
                            icon: Icons.info_outline,
                            title: "About Us",
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AboutusScreen(),
                                ),
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey[200],
                          ),
                          _buildSettingsItem(
                            icon: Icons.question_answer_outlined,
                            title: "FAQ",
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FAQScreen(),
                                ),
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey[200],
                          ),
                          _buildSettingsItem(
                            icon: Icons.logout,
                            title: "Log Out",
                            iconColor: Colors.red,
                            textColor: Colors.red,
                            onTap: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                    (route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.black87, size: 24),
            SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.dmSerifText(
                fontSize: 16,
                color: textColor ?? Colors.black87,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
