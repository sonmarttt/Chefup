import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/recipe_model.dart';
import '../../services/recipe_service.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();

  String _selectedCategory = 'Chicken'; // Default
  final List<String> _categories = ['Chicken', 'Soup', 'Drinks', 'Baked', 'Beef', 'Seafood', 'Vegetarian'];

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final RecipeService _recipeService = RecipeService();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _postRecipe() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      // Upload Image
      String imageUrl = await _recipeService.uploadRecipeImage(_imageFile!, user.uid);

      // Create Recipe Model
      RecipeModel newRecipe = RecipeModel(
        id: '', // Will be generated
        title: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        ingredients: _ingredientsController.text.split('\n').where((s) => s.isNotEmpty).toList(),
        steps: _directionsController.text.split('\n').where((s) => s.isNotEmpty).toList(),
        category: _selectedCategory,
        cookTimeMinutes: int.tryParse(_timeController.text) ?? 0,
        imageUrl: imageUrl,
        authorId: user.uid,
        authorName: user.displayName ?? 'Chef',
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      await _recipeService.createRecipe(newRecipe);

      if (mounted) {
        Navigator.pop(context); // Go back to My Posts
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe posted successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My Posts-Add", style: GoogleFonts.dmSerifText(color: Colors.grey)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[800]!),
                    image: _imageFile != null
                        ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _imageFile == null
                      ? Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(120, 165, 90, 100),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Upload An Image",
                        style: GoogleFonts.dmSerifText(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                      : null,
                ),
              ),
              SizedBox(height: 30),

              // Type
              _buildDropdownField("Type:", _selectedCategory, (val) {
                setState(() {
                  _selectedCategory = val!;
                });
              }),

              // Name
              _buildTextField("Name:", _nameController),

              // Cooking Time
              _buildTextField("Cooking Time:", _timeController, isNumber: true),

              // Description
              _buildTextField("Description:", _descriptionController, maxLines: 3),

              // Ingredients
              _buildTextField("Ingredients:", _ingredientsController, maxLines: 5),

              // Directions
              _buildTextField("Directions:", _directionsController, maxLines: 5),

              SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    backgroundColor: const Color.fromRGBO(120, 165, 90, 100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading ? null : _postRecipe,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "Post",
                    style: GoogleFonts.dmSerifText(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.dmSerifText(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: isNumber ? TextInputType.number : TextInputType.multiline,
              style: TextStyle(color: Colors.white),
              validator: (val) => val!.isEmpty ? 'Required' : null,
              decoration: InputDecoration(
                hintText: label.replaceAll(':', ''),
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.dmSerifText(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  dropdownColor: Colors.grey[900],
                  style: TextStyle(color: Colors.white),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
