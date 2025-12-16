import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/recipe_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/recipe_service.dart';
import '../recipe/recipe_details_screen.dart';
import 'dart:developer';
import 'setting_screen.dart';
import '../../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final RecipeService _recipeService = RecipeService();
  final AuthService _authService = AuthService();
  bool _isAdmin = false;
  String _searchQuery = "";
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    bool admin = await _authService.isAdmin(
      FirebaseAuth.instance.currentUser?.uid,
    );
    if (mounted) {
      setState(() {
        _isAdmin = admin;
      });
      if (_isAdmin) {
        log('Current user is ADMIN');
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    log('discovery building ');
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            //top side of the page
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
                  //user info, search, categories
                  Positioned.fill(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (isGuest) {
                                    _showLoginPrompt(context);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SettingsScreen(),
                                      ),
                                    );
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: AssetImage(
                                    'pictures/logo.png',
                                  ), // Placeholder
                                ),
                              ),
                              SizedBox(width: 15),
                              StreamBuilder<DocumentSnapshot>(
                                stream:
                                    FirebaseAuth.instance.currentUser != null
                                    ? FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid,
                                          )
                                          .snapshots()
                                    : null,
                                builder: (context, snapshot) {
                                  String displayName = "Chef";
                                  if (FirebaseAuth.instance.currentUser ==
                                      null) {
                                    displayName = "Guest";
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data!.exists) {
                                    final data =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>;
                                    displayName = data['displayName'] ?? "Chef";
                                  } else {
                                    displayName =
                                        FirebaseAuth
                                            .instance
                                            .currentUser
                                            ?.displayName ??
                                        "Chef";
                                  }

                                  return Text(
                                    "Hello, $displayName!",
                                    style: GoogleFonts.dmSerifText(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),

                        // Search Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Container(
                                height: 50,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                  textAlign: TextAlign.left,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    hintStyle: GoogleFonts.dmSerifText(
                                      color: Color.fromRGBO(120, 165, 90, 100),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    suffixIcon: Container(
                                      margin: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(
                                          120,
                                          165,
                                          90,
                                          100,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Tabs
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 20,
                          ),
                          child: Row(
                            children: [
                              _buildTab("All", _selectedCategory == "All", () {
                                setState(() {
                                  _selectedCategory = "All";
                                });
                              }),
                              _buildTab(
                                "Soup",
                                _selectedCategory == "Soup",
                                () {
                                  setState(() {
                                    _selectedCategory = "Soup";
                                  });
                                },
                              ),
                              _buildTab(
                                "Drinks",
                                _selectedCategory == "Drinks",
                                () {
                                  setState(() {
                                    _selectedCategory = "Drinks";
                                  });
                                },
                              ),
                              _buildTab(
                                "Baked",
                                _selectedCategory == "Baked",
                                () {
                                  setState(() {
                                    _selectedCategory = "Baked";
                                  });
                                },
                              ),
                              _buildTab(
                                "Cooked",
                                _selectedCategory == "Cooked",
                                () {
                                  setState(() {
                                    _selectedCategory = "Cooked";
                                  });
                                },
                              ),
                              _buildTab(
                                "Beef",
                                _selectedCategory == "Beef",
                                () {
                                  setState(() {
                                    _selectedCategory = "Beef";
                                  });
                                },
                              ),
                              SizedBox(width: 200),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  //the picture
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

            // Grid of Recipes
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: user != null && !user.isAnonymous
                    ? _recipeService.getSavedRecipeIds(user.uid)
                    : Stream.value([]),
                builder: (context, savedSnapshot) {
                  final savedIds = (savedSnapshot.data ?? []).toSet();

                  return StreamBuilder<List<RecipeModel>>(
                    stream: _recipeService.getAllRecipes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Error loading recipes"));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      var recipes = snapshot.data ?? [];

                      // Apply Client-Side Filtering
                      // 1. Category
                      if (_selectedCategory != "All") {
                        recipes = recipes
                            .where((r) => r.category == _selectedCategory)
                            .toList();
                      }

                      // 2. Search
                      if (_searchQuery.isNotEmpty) {
                        final q = _searchQuery.toLowerCase().trim();
                        recipes = recipes
                            .where((r) => r.title.toLowerCase().contains(q))
                            .toList();
                      }

                      if (recipes.isEmpty) {
                        return Center(
                          child: Text(
                            "No recipes found",
                            style: GoogleFonts.dmSerifText(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = recipes[index];
                          final isSaved = savedIds.contains(recipe.id);

                          return _buildRecipe(
                            recipe.title,
                            0, // Placeholder for likes count
                            recipe.imageUrl,
                            isNetworkImage: true,
                            isSaved: isSaved,
                            onSave: () async {
                              if (isGuest) {
                                _showLoginPrompt(context);
                                return;
                              }
                              try {
                                if (isSaved) {
                                  await _recipeService.unsaveRecipe(
                                    user!.uid,
                                    recipe.id,
                                  );
                                } else {
                                  await _recipeService.saveRecipe(
                                    user!.uid,
                                    recipe.id,
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error updating save: $e"),
                                    ),
                                  );
                                }
                              }
                            },
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailsScreen(recipe: recipe),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 35,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAEAEA) : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.dmSerifText(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildRecipe(
    String name,
    int likes,
    String imagePath, {
    VoidCallback? onTap,
    bool isNetworkImage = false,
    bool isSaved = false,
    VoidCallback? onSave,
  }) {
    final content = Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: isNetworkImage
                    ? Image.network(
                        imagePath,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[300],
                          child: Icon(Icons.broken_image),
                        ),
                      ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(8),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.dmSerifText(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }

    return content;
  }
}
