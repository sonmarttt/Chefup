import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/recipe_model.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final RecipeModel recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Image.asset(
                      recipe.imageUrl,
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  // BACK BUTTON
                  Positioned(
                    top: 20,
                    left: 15,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // SAVE BUTTON
                  Positioned(
                    top: 20,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE
                    Text(
                      recipe.title,
                      style: GoogleFonts.dmSerifText(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // AUTHOR + TIME
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              //placeholder for author image
                              backgroundImage: AssetImage("pictures/logo.png"),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              recipe.authorName,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Cooking Time: ${recipe.cookTimeMinutes} min",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),

                    _sectionTitle("Description"),
                    SizedBox(height: 8),
                    Text(
                      recipe.description,
                      style: TextStyle(color: Colors.white70, height: 1.5),
                    ),

                    SizedBox(height: 25),

                    // ✅ INGREDIENTS (DUMMY)
                    _sectionTitle("Ingredients"),
                    SizedBox(height: 8),
                    Text(
                      recipe.ingredients.join('\n'),
                      style: TextStyle(color: Colors.white70, height: 1.6),
                    ),

                    SizedBox(height: 25),
                    _sectionTitle("Directions"),
                    SizedBox(height: 8),
                    Text(
                      recipe.steps.join('\n\n'),
                      style: TextStyle(color: Colors.white70, height: 1.6),
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSerifText(fontSize: 20, color: Colors.white),
    );
  }
}
