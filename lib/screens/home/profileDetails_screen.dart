import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfielDetailsScreen extends StatefulWidget {
  const ProfielDetailsScreen({super.key});

  @override
  State<ProfielDetailsScreen> createState() => _ProfielDetailsScreenState();
}

class _ProfielDetailsScreenState extends State<ProfielDetailsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    //todo: load the actuayl info from firebase
    _usernameController.text = "John";
    _emailController.text = "email@example.com";
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // TODO: Save changes to Firebase
    setState(() {
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
void _changeProfilePicture() {
    //todo: method to change the picture
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
            Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: AssetImage('pictures/login.png'), // TODO:replace with users actual image

                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    //the function to actually updae the piture
                    onTap: _changeProfilePicture,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(24, 25, 28, 100),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),



            Expanded(
              child: SingleChildScrollView(
                padding:  EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding:  EdgeInsets.all(20),
                  margin:  EdgeInsets.symmetric(horizontal: 20),
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
                        label: "Username",
                        controller: _usernameController,
                        icon: Icons.person_outline,
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        label: "Email",
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 30),

                      //button to save the changes, visible only when you click the text fields
                      if (_isEditing)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(120,
                                165,
                                90,
                                100,),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Save Changes',
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
              Icon(icon, size: 20, color: Colors.black54),
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
            style: GoogleFonts.dmSerifText(
              fontSize: 16,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter your $label',
              hintStyle: GoogleFonts.dmSerifText(
                fontSize: 16,
                color: Colors.black38,
              ),
            ),
            //if i click to edit, its gonna show me the button to save changes
            onTap: () {
              if (!_isEditing) {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}