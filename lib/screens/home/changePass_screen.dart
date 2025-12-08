import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangepassScreen extends StatefulWidget {
  const ChangepassScreen({super.key});

  @override
  State<ChangepassScreen> createState() => _ChangepassScreenState();
}

class _ChangepassScreenState extends State<ChangepassScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _ConfirmNewPassController =
      TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _passwordController.dispose();
    _newPassController.dispose();
    _ConfirmNewPassController.dispose();
    super.dispose();
  }

  Future<void> updatePass() async {
    if (_newPassController.text.trim() !=
        _ConfirmNewPassController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("New passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPassController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password must be at least 6 characters"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Re-authenticate first
      await _authService.reauthenticate(_passwordController.text.trim());

      // Update password
      await _authService.updatePassword(_newPassController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // Clear fields
      _passwordController.clear();
      _newPassController.clear();
      _ConfirmNewPassController.clear();
      
      // Optionally pop back
      // Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message = "Error updating password";
      if (e.code == 'wrong-password') {
        message = "Current password is incorrect";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 20),
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
                      _buildTextField(
                        label: "Current Password",
                        controller: _passwordController,
                        icon: Icons.lock,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: "New Password",
                        controller: _newPassController,
                        icon: Icons.lock,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: "Confirm Password",
                        controller: _ConfirmNewPassController,
                        icon: Icons.lock,
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: updatePass,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(
                              120,
                              165,
                              90,
                              100,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Update Password',
                            style: GoogleFonts.dmSerifText(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.black),
              SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.dmSerifText(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: true, // Hide password
            style: GoogleFonts.dmSerifText(
              fontSize: 16,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintStyle: GoogleFonts.dmSerifText(
                fontSize: 16,
                color: Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}