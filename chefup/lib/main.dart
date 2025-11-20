import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'firebase_test_page.dart';

// Connection of the firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

//--------------------------------------------Welcome page-----------------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Welcome());
  }
}

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("pictures/login.png"),
            fit: BoxFit.cover, // makes it fill the entire screen
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
                  MaterialPageRoute(builder: (context) => Login()),
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

              // Test the firebase as guest it will ask for a message and
              // will show that message to the firebase with timestamp
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirebaseTestPage(),
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

//-------------------------------------------------------Login----------------------------------------------------------------
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // the input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Transform.translate(
                offset: Offset(0, -270),
                child: Image.asset("pictures/login.png", fit: BoxFit.cover),
              ),
            ),
          ),
          //the button to go back
          Positioned(
            top: 30, // Adjust position
            left: 25,
            child: Container(
              width: 50,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), // Glassy effect
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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Welcome()),
                    );
                  },
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

          Column(
            children: [
              SizedBox(height: 60),
              Image.asset('pictures/logo.png', width: 250, fit: BoxFit.contain),
              SizedBox(height: 270),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("pictures/wavy.png"),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  children: [
                    Text(
                      "Welcome back",
                      style: GoogleFonts.dmSerifText(
                        color: const Color.fromRGBO(120, 165, 90, 100),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Login to your account",
                      style: GoogleFonts.dmSerifText(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),

                    // Email field
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.dmSerifText(
                            color: const Color.fromRGBO(120, 165, 90, 100),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            size: 20,
                            Icons.email,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(238, 239, 238, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Password field
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: GoogleFonts.dmSerifText(
                            color: const Color.fromRGBO(120, 165, 90, 100),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            size: 20,
                            Icons.lock,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(238, 239, 238, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassInsertEmail(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot password?",
                          style: GoogleFonts.dmSerifText(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(250, 50),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            //TODO: change this route to discovery page
                            builder: (context) => Welcome(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                        style: GoogleFonts.dmSerifText(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.dmSerifText(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Register(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: GoogleFonts.dmSerifText(
                              color: const Color.fromRGBO(120, 165, 90, 100),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//----------------------------------------Register page----------------------------------------------
class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // the input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("pictures/login.png"),
            fit: BoxFit.cover, // makes it fill the entire screen
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 50,
                  height: 25,

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05), // Glassy effect
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
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
              SizedBox(height: 30),

              Text(
                "Create An Account",
                style: GoogleFonts.dmSerifText(
                  color: Colors.white,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 90),
              // input fields
              SizedBox(
                height: 55,
                width: 300,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: GoogleFonts.dmSerifText(
                      color: const Color.fromARGB(156, 0, 0, 0),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      size: 20,
                      Icons.person,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(238, 239, 238, 0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 45),
              SizedBox(
                height: 55,
                width: 300,
                child: TextField(
                  controller: _emailController,

                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: GoogleFonts.dmSerifText(
                      color: const Color.fromARGB(156, 0, 0, 0),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      size: 20,
                      Icons.email,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: const Color.fromRGBO(238, 239, 238, 0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(height: 45),
              SizedBox(
                height: 55,
                width: 300,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: GoogleFonts.dmSerifText(
                      color: const Color.fromARGB(156, 0, 0, 0),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(size: 20, Icons.lock, color: Colors.black),
                    filled: true,
                    fillColor: const Color.fromRGBO(238, 239, 238, 0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 45),
              SizedBox(
                height: 55,
                width: 300,
                child: TextField(
                  controller: _confirmPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: GoogleFonts.dmSerifText(
                      color: const Color.fromARGB(156, 0, 0, 0),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(size: 20, Icons.lock, color: Colors.black),
                    filled: true,
                    fillColor: const Color.fromRGBO(238, 239, 238, 0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 210),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(230, 55),
                  backgroundColor: Color.fromRGBO(120, 165, 90, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      //TODO: add user to db, chekc if the passwords were matching
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: Text(
                  "Sign Up",
                  style: GoogleFonts.dmSerifText(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//------------------------------------------insert email for forgot pass-------------------------------------------------
class ForgotPassInsertEmail extends StatefulWidget {
  const ForgotPassInsertEmail({super.key});

  @override
  State<ForgotPassInsertEmail> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassInsertEmail> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Transform.translate(
                offset: Offset(0, -270),
                child: Image.asset("pictures/login.png", fit: BoxFit.cover),
              ),
            ),
          ),
          //the button to go back
          Positioned(
            top: 30, // Adjust position
            left: 25,
            child: Container(
              width: 50,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), // Glassy effect
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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
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

          Column(
            children: [
              SizedBox(height: 60),
              Image.asset('pictures/logo.png', width: 250, fit: BoxFit.contain),
              SizedBox(height: 270),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("pictures/wavy.png"),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  children: [
                    Text(
                      "Forgot Password",
                      style: GoogleFonts.dmSerifText(
                        color: const Color.fromRGBO(120, 165, 90, 100),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Please enter your registered email",
                      style: GoogleFonts.dmSerifText(
                        color: const Color.fromARGB(255, 104, 0, 0),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),

                    // Email field
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.dmSerifText(
                            color: const Color.fromRGBO(120, 165, 90, 100),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            size: 20,
                            Icons.email,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(238, 239, 238, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 120),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(250, 50),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPassword(),
                          ),
                        );
                      },
                      child: Text(
                        "Next",
                        style: GoogleFonts.dmSerifText(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "You will receive a confirmation email",
                      style: GoogleFonts.dmSerifText(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//------------------------------------------Reset password page----------------------------------------------------------------
class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Transform.translate(
                offset: Offset(0, -270),
                child: Image.asset("pictures/login.png", fit: BoxFit.cover),
              ),
            ),
          ),
          //the button to go back
          Positioned(
            top: 30, // Adjust position
            left: 25,
            child: Container(
              width: 50,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), // Glassy effect
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
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPassInsertEmail(),
                      ),
                    );
                  },
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

          Column(
            children: [
              SizedBox(height: 60),
              Image.asset('pictures/logo.png', width: 250, fit: BoxFit.contain),
              SizedBox(height: 270),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("pictures/wavy.png"),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Column(
                  children: [
                    Text(
                      "Reset Password",
                      style: GoogleFonts.dmSerifText(
                        color: const Color.fromRGBO(120, 165, 90, 100),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Enter your new password",
                      style: GoogleFonts.dmSerifText(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),

                    // Email field
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: GoogleFonts.dmSerifText(
                            color: const Color.fromRGBO(120, 165, 90, 100),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            size: 20,
                            Icons.lock,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(238, 239, 238, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Password field
                    SizedBox(
                      height: 45,
                      child: TextField(
                        controller: _confirmPassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: GoogleFonts.dmSerifText(
                            color: const Color.fromRGBO(120, 165, 90, 100),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            size: 20,
                            Icons.lock,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: const Color.fromRGBO(238, 239, 238, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 55),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(250, 50),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Reset",
                        style: GoogleFonts.dmSerifText(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
