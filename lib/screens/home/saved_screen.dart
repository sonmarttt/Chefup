import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/recipe_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/recipe_service.dart';
import '../recipe/recipe_details_screen.dart';
import '../recipe/add_recipe_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'setting_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final RecipeService _recipeService = RecipeService();
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    if (_uid == null) {
      return Scaffold(
        body: Center(child: Text("Please login to see your saved recipes")),
      );
    }

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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SettingsScreen(),
                                    ),
                                  );
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
                                      vertical: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            "Saved Recipes",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.dmSerifText(
                              fontSize: 26,
                              color: Colors.white,
                            ),
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
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: _recipeService.getSavedRecipeIds(_uid!),
                builder: (context, savedSnapshot) {
                  if (savedSnapshot.hasError) {
                    return Center(child: Text("Error loading saved recipes"));
                  }

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

                      final allRecipes = snapshot.data ?? [];
                      final savedRecipes = allRecipes
                          .where((r) => savedIds.contains(r.id))
                          .toList();

                      if (savedRecipes.isEmpty) {
                        return Center(
                          child: Text(
                            "No saved recipes yet",
                            style: GoogleFonts.dmSerifText(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: savedRecipes.length,
                        itemBuilder: (context, index) {
                          final recipe = savedRecipes[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _buildRecipe(
                              recipe.title,
                              0, // likes placeholder
                              recipe.imageUrl,
                              recipe.description,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RecipeDetailsScreen(recipe: recipe),
                                  ),
                                );
                              },
                            ),
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

  Widget _buildRecipe(
    String name,
    int likes,
    String imagePath,
    String description, {
    VoidCallback? onTap,
  }) {
    final content = Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image section
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 130,
                      width: 130,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image),
                    ),
                  )
                : Image.asset(
                    imagePath,
                    height: 130,
                    width: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 130,
                      width: 130,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image),
                    ),
                  ),
          ),
          // Content section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and likes row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.dmSerifText(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Description
                  Expanded(
                    child: Text(
                      description,
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
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
