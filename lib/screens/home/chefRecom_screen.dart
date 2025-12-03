import 'package:chefup/models/fruit_model.dart';
import 'package:chefup/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChefRecScreen extends StatefulWidget {
  const ChefRecScreen({super.key});

  @override
  State<ChefRecScreen> createState() => _ChefRecScreenState();
}

class _ChefRecScreenState extends State<ChefRecScreen> {
  List<Welcome>? fruits;
  var isLoaded = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      final data = await ApiServices().getFruits();

      if (!mounted) return;

      setState(() {
        fruits = data;
        isLoaded = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load fruits";
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
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
                                backgroundImage: AssetImage(
                                  'pictures/logo.png',
                                ), // Placeholder
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

            const SizedBox(height: 20),

            // FRUIT LIST
            Expanded(
              child: isLoaded
                  ? errorMessage != null
                        ? Center(
                            child: Text(
                              errorMessage!,
                              style: GoogleFonts.dmSerifText(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                          )
                        : fruits == null || fruits!.isEmpty
                        ? Center(
                            child: Text(
                              "No fruits available",
                              style: GoogleFonts.dmSerifText(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemCount: fruits!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // NAME
                                    Text(
                                      fruits![index].name.toUpperCase(),
                                      style: GoogleFonts.dmSerifText(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // INFO ROW
                                    Text(
                                      "Family: ${fruits![index].family}  •  Order: ${fruits![index].order}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "Genus: ${fruits![index].genus}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 15),

                                    // NUTRITION GRID
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _nutritionItem(
                                          "Calories",
                                          fruits![index].nutritions.calories,
                                        ),
                                        _nutritionItem(
                                          "Fat",
                                          fruits![index].nutritions.fat,
                                        ),
                                        _nutritionItem(
                                          "Sugar",
                                          fruits![index].nutritions.sugar,
                                        ),
                                        _nutritionItem(
                                          "Carbs",
                                          fruits![index]
                                              .nutritions
                                              .carbohydrates,
                                        ),
                                        _nutritionItem(
                                          "Protein",
                                          fruits![index].nutritions.protein,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                  : const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(120, 165, 90, 100),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nutritionItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
