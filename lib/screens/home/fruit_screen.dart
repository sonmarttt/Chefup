import 'package:chefup/models/fruit_model.dart';
import 'package:chefup/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FruitScreen extends StatefulWidget {
  const FruitScreen({super.key});

  @override
  State<FruitScreen> createState() => _FruitScreenState();
}

class _FruitScreenState extends State<FruitScreen> {
  List<Fruits>? fruits; //all the fruits from API
  List<Fruits>? displayedFruits; // store the fruit to allow searching
  var isLoaded = false;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();

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
        displayedFruits = data;
        isLoaded = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load fruits";
        isLoaded = true;
      });
    }
  }

  searchFruits(String query) {
    if (query.isEmpty) {
      setState(() {
        displayedFruits = fruits;
      });
      return;
    }

    final filteredFruits = fruits?.where((fruit) {
      final fruitName = fruit.name.toLowerCase();
      final input = query.toLowerCase();
      final matches = fruitName.contains(input);
      return matches;
    }).toList();

    setState(() {
      displayedFruits = filteredFruits;
    });
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
                        // Search Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 20,
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
                                  controller: _searchController,
                                  onChanged: (value) {
                                    //show/hide clear icon
                                    setState(() {});
                                  },
                                  onSubmitted: (value) {
                                    searchFruits(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    hintStyle: GoogleFonts.dmSerifText(
                                      color: Color.fromRGBO(120, 165, 90, 100),
                                    ),
                                    prefixIcon:
                                        _searchController.text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              _searchController.clear();
                                              searchFruits('');
                                              setState(() {});
                                            },
                                            icon: Icon(Icons.clear),
                                            color: Colors.grey,
                                          )
                                        : Icon(
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
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: CircleBorder(),
                                          backgroundColor: Color.fromRGBO(
                                            120,
                                            165,
                                            90,
                                            100,
                                          ),
                                        ),
                                        onPressed: () {
                                          searchFruits(_searchController.text);
                                        },
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                      ),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
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

            //fruit list
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
                        : displayedFruits == null || displayedFruits!.isEmpty
                        ? Center(
                            child: Text(
                              _searchController.text.isNotEmpty
                                  ? "No fruits found"
                                  : "No fruits available",
                              style: GoogleFonts.dmSerifText(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemCount: displayedFruits!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.only(bottom: 15),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //the name of the fruit
                                      Text(
                                        displayedFruits![index].name
                                            .toUpperCase(),
                                        style: GoogleFonts.dmSerifText(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(
                                            120,
                                            165,
                                            90,
                                            100,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 8),

                                      //info about the fruit
                                      Text(
                                        "Family: ${displayedFruits![index].family}  •  Order: ${fruits![index].order}",
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        "Genus: ${displayedFruits![index].genus}",
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),

                                      const SizedBox(height: 15),

                                      //row for the nutrition info
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 5,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _nutritionItem(
                                              "Calories",
                                              displayedFruits![index]
                                                  .nutritions
                                                  .calories,
                                            ),
                                            _nutritionItem(
                                              "Fat",
                                              displayedFruits![index]
                                                  .nutritions
                                                  .fat,
                                            ),
                                            _nutritionItem(
                                              "Sugar",
                                              displayedFruits![index]
                                                  .nutritions
                                                  .sugar,
                                            ),
                                            _nutritionItem(
                                              "Carbs",
                                              displayedFruits![index]
                                                  .nutritions
                                                  .carbohydrates,
                                            ),
                                            _nutritionItem(
                                              "Protein",
                                              displayedFruits![index]
                                                  .nutritions
                                                  .protein,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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

  Widget _nutritionItem(String label, double value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
