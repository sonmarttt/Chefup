import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
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

            SizedBox(height: 20),
            Text(
              "FAQ",
              style: GoogleFonts.dmSerifText(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),


            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildFAQCard(
                        question: "Can I edit my recipes after saving them?",
                        answer: "Yes, you can edit any recipe you've saved at any time. Just open the recipe and click the edit button to make changes to ingredients, instructions, or other details."
                    ),
                    SizedBox(height: 12),
                    _buildFAQCard(
                        question: "Can I search for specific type of food?",
                        answer: "Our App provides categories that allows the user to filter the recipes for their desired type"
                    ),
                    SizedBox(height: 12),
                    _buildFAQCard(
                        question: "Is my recipe collection private?",
                        answer: "Your recipes are private by default and only visible to you. Some apps offer optional sharing features if you want to share recipes with friends or family."
                    ),
                    SizedBox(height: 12),
                    _buildFAQCard(
                        question: "Is there a feature to verify the ingredients nutrition?",
                        answer: "Yes! We have a page that shares information on various ingredients. We are planning to expand our database in the future!"
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard({required String question, required String answer}) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: GoogleFonts.dmSerifText(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 12),
          Text(
            answer,
            style: GoogleFonts.dmSerifText(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}