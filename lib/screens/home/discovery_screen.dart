import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/recipe_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/recipe_service.dart';
import '../recipe/recipe_details_screen.dart';
import 'dart:developer';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final RecipeService _recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
    log('discovery building ');
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
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
                ), // radius in pixels
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
                              CircleAvatar(
                                radius: 20,
                                //TODO: replace with user profile picture
                                backgroundImage: AssetImage(
                                  'pictures/logo.png',
                                ), // Placeholder
                              ),
                              SizedBox(width: 15),
                              Text(
                                //TODO: replace with user's name
                                "Hello, Chef!",
                                style: GoogleFonts.dmSerifText(
                                  fontSize: 20,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
                                height: 45,
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

                        // Tabs (Visual only for now)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 20,
                          ),
                          child: Row(
                            children: [
                              //Todo: fetch the categories from firebase
                              _buildTab("All", true),
                              _buildTab("Soup", false),
                              _buildTab("Drinks", false),
                              _buildTab("Baked", false),
                              _buildTab("Cooked", false),
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
              child: StreamBuilder<List<RecipeModel>>(
                stream: _recipeService.getAllRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading recipes"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final recipes = snapshot.data ?? [];

                  if (recipes.isEmpty) {
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
                        return _buildRecipe(
                          //fetch the information from firebase
                          recipe.title,
                          0,
                          recipe.imageUrl,
                          isNetworkImage: true,
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
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    //fetches from database
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailsScreen(recipe: recipe),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    recipe.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[300],
                                              child: Icon(Icons.broken_image),
                                            ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      recipe.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.dmSerifText(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${recipe.cookTimeMinutes} min",
                                          style: GoogleFonts.dmSerifText(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Icon(Icons.favorite_border, size: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildTab(String text, bool isSelected) {
    return Container(
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
    );
  }

  Widget _buildRecipe(
    String name,
    int likes,
    String imagePath, {
    VoidCallback? onTap,
    bool isNetworkImage = false, // Add this parameter
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
                  onPressed: () {
                    //TODO: add in the saved
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(8),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Icon(Icons.bookmark, color: Colors.black, size: 20),
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
                Text(
                  likes.toString(),
                  style: GoogleFonts.dmSerifText(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    // Handle like action
                    print('liked');
                  },
                  child: Icon(Icons.favorite, color: Colors.black, size: 20),
                ),
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
