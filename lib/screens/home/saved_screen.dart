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
        body: Center(child: Text("Please login to see your posts")),
      );
    }

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
                                  //TODO: replace with user profile picture
                                  backgroundImage: AssetImage(
                                    'pictures/logo.png',
                                  ), // Placeholder
                                ),
                              ),
                              SizedBox(width: 15),
                              Text(
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
            // List of Recipes
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
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        children: [
                          //logic to pass the recipe data to recipe details screen through firebase
                          //it should iterate through the database and show every recipe
                          _buildRecipe(
                            "Beef Stew",
                            56,
                            "pictures/beef_stew.png",
                            "A hearty comfort meal featuring tender chunks of beef with vegetables slow-cooked in a rich, savory sauce. Perfect for cold winter nights. The slow cooking process...",
                            onTap: () {
                              final sample = RecipeModel(
                                //change based on firebase data
                                //pass the fields so it can be accessed in details screen
                                //just need the picutre, category, likes number, username, username profile, cook time, title, description, ingredients, steps
                                id: 'sample-beef-stew',
                                title: 'Beef Stew',
                                description:
                                    'A hearty and delicious beef stew perfect for cold days.',
                                ingredients: ['random ingredient'],
                                steps: ['1. Do this', '2. Do that'],
                                category: 'chicken',
                                cookTimeMinutes: 56,
                                imageUrl: 'pictures/beef_stew.png',
                                authorId: 'idk',
                                authorName: 'some name',
                                createdAt: Timestamp.now(),
                                updatedAt: Timestamp.now(),
                              );
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecipeDetailsScreen(recipe: sample),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 15),
                          //dummy data for visual purposes
                          _buildRecipe(
                            'Smoked Salmon...',
                            112,
                            'pictures/chicken.png',
                            'A perfect light and smoky fish dinner for the weeknight. With cheesy mashed potatoes, this delicious recipe comes together in so...',
                            onTap: () {
                              // Navigate to recipe detail
                            },
                          ),
                          SizedBox(height: 15),
                          _buildRecipe(
                            'Raspberry Ch...',
                            50,
                            'pictures/choco_mousse.png',
                            'A delightfully sweet dessert with the tart sweetness of fresh raspberries. This impressive treat served over crushed ice is a...',
                            onTap: () {
                              // Navigate to recipe detail
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        //the information should be fetched from firebase
                        child: _buildRecipe(
                          recipe.title,
                          203, //the number of likes
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
                      Row(
                        children: [
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
                            child: Icon(
                              Icons.favorite,
                              color: Colors.black,
                              size: 18,
                            ),
                          ),
                        ],
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
