import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/recipe_model.dart';
import '../../services/recipe_service.dart';
import '../recipe/recipe_details_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final RecipeService _recipeService = RecipeService();

  @override
  Widget build(BuildContext context) {
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
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(140)), // radius in pixels
              ),
              child: Stack(
                children: [
                  //user info, search, categories
                  Positioned.fill(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage('pictures/logo.png'), // Placeholder
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
                        SizedBox(height: 15,),

                        // Search Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
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
                                    hintStyle: GoogleFonts.dmSerifText(color: Color.fromRGBO(120, 165, 90, 100),),
                                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                                    suffixIcon: Container(
                                      margin: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(120, 165, 90, 100),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.arrow_forward, color: Colors.white, size: 22,),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                              left: 10, right: 10, bottom: 20),
                          child: Row(
                            children: [
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
                    top: 0,right: -55,
                    child: Column(
                      children: [
                        Image.asset('pictures/discoveryFood.png', width: 200, height:200,),
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
                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          GridView.count(
                            shrinkWrap: true, // Important: allows GridView to size itself
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.75,
                            children: [
                              _buildRecipe("Beef Stew", 56, "pictures/beef_stew.png"),
                              _buildRecipe("Chocolate Mousse", 42, "pictures/choco_mousse.png"),
                              _buildRecipe("Raspberry Cocktail", 38, "pictures/strawberry_drink.png"),
                              _buildRecipe("Cranberry-Orange Roast Ducklings", 29, "pictures/chicken.png"),
                              _buildRecipe("Cranberry-Orange Roast Ducklings", 29, "pictures/chicken.png"),
                              _buildRecipe("Cranberry-Orange Roast Ducklings", 29, "pictures/chicken.png"),
                              _buildRecipe("Cranberry-Orange Roast Ducklings", 29, "pictures/chicken.png"),
                            ],
                          )
                        ],

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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailsScreen(recipe: recipe),
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
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                  child: Image.network(
                                    recipe.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(color: Colors.grey[300], child: Icon(Icons.broken_image)),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildRecipe(String name, int likes, String imagePath){
    return Container(
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
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Image.asset(
              imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
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
                     // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(width: 8),

                // Likes count
                Text(
                  likes.toString(),
                  style: GoogleFonts.dmSerifText(
                    fontSize: 14,
                    //fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                SizedBox(width: 4),

                // Heart icon
                Icon(
                  Icons.favorite,
                  color: Colors.black,
                  size: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
