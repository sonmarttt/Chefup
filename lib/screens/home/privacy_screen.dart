import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
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

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
                  Text(
                    "About Us",
                    style: GoogleFonts.dmSerifText(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Effective Date: December 2024",
                    style: GoogleFonts.dmSerifText(
                      fontSize: 14,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 24),
                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 24),

                  _buildSection(
                    title: "Information We Collect",
                    content: "When you use ChefUp, we collect and store the following information:",
                    bulletPoints: [
                      "Account information (email address, username, password)",
                      "Recipes you create, save, and favorite",
                      "User preferences and app settings",
                      "Device information and usage data",
                    ],
                  ),

                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 24),

                  _buildSection(
                    title: "How We Use Your Information",
                    content: "We use your information to:",
                    bulletPoints: [
                      "Provide and maintain your account",
                      "Store and sync your recipes across devices",
                      "Improve app functionality and user experience",
                      "Send important updates about the service",
                    ],
                  ),

                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 24),

                  _buildSection(
                    title: "Data Storage",
                    content: "Your data is securely stored using Firebase, a service provided by Google. Firebase employs industry-standard security measures to protect your information. For more details, visit Google's Privacy Policy at https://policies.google.com/privacy",
                  ),

                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 24),

                  _buildSection(
                    title: "Your Data Rights",
                    content: "You have the right to:",
                    bulletPoints: [
                      "Access your personal data at any time",
                      "Edit or delete your recipes and account information",
                      "Request complete account deletion",
                    ],
                  ),

                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 24),

                  _buildSection(
                    title: "Data Sharing",
                    content: "We do not sell, trade, or share your personal information with third parties. Your recipes and personal data remain private and are only visible to you unless you choose to share them.",
                  ),

                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 24),

                  _buildSection(
                    title: "Changes to This Policy",
                    content: "We may update this privacy policy from time to time. We will notify users of any significant changes through the app.",
                  ),

                  Divider(color: Colors.grey[300], thickness: 1),
                  SizedBox(height: 24),

                  _buildSection(
                    title: "Contact Us",
                    content: "If you have questions about this privacy policy, please contact us at support@chefup.com",
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    List<String>? bulletPoints,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.dmSerifText(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 12),
        Text(
          content,
          style: GoogleFonts.dmSerifText(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        if (bulletPoints != null) ...[
          SizedBox(height: 8),
          ...bulletPoints.map((point) => Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "• ",
                  style: GoogleFonts.dmSerifText(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: GoogleFonts.dmSerifText(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ],
    );
  }
}