import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/recipe_model.dart';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/recipe_service.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final RecipeService _recipeService = RecipeService();
  bool _isEditing = false;

  // Controllers for editable fields
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _cookTimeController;
  late TextEditingController _categoryController;
  late List<TextEditingController> _ingredientControllers;
  late List<TextEditingController> _stepControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.recipe.title);
    _descriptionController = TextEditingController(
      text: widget.recipe.description,
    );
    _cookTimeController = TextEditingController(
      text: widget.recipe.cookTimeMinutes.toString(),
    );
    _categoryController = TextEditingController(text: widget.recipe.category);

    _ingredientControllers = widget.recipe.ingredients
        .map((ingredient) => TextEditingController(text: ingredient))
        .toList();

    _stepControllers = widget.recipe.steps
        .map((step) => TextEditingController(text: step))
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cookTimeController.dispose();
    _categoryController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Delete Recipe",
            style: GoogleFonts.dmSerifText(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this recipe? This action cannot be undone.",
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
                Navigator.of(context).pop();
                await _deleteRecipe();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Delete",
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

  Future<void> _deleteRecipe() async {
    try {
      await _recipeService.deleteRecipe(widget.recipe.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Recipe deleted successfully"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error deleting recipe: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateRecipe() async {
    try {
      // Gather updated data
      final updatedRecipe = {
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _categoryController.text.trim(),
        'cookTimeMinutes':
            int.tryParse(_cookTimeController.text) ??
            widget.recipe.cookTimeMinutes,
        'ingredients': _ingredientControllers
            .map((c) => c.text.trim())
            .where((text) => text.isNotEmpty)
            .toList(),
        'steps': _stepControllers
            .map((c) => c.text.trim())
            .where((text) => text.isNotEmpty)
            .toList(),
        'updatedAt': DateTime.now(),
      };

      await _recipeService.updateRecipe(widget.recipe.id, updatedRecipe);

      if (context.mounted) {
        setState(() {
          _isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Recipe updated successfully"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating recipe: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredientControllers[index].dispose();
      _ingredientControllers.removeAt(index);
    });
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers[index].dispose();
      _stepControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    log('RecipeDetailsScreen building ');
    final user = FirebaseAuth.instance.currentUser;
    final isOwner = user != null && user.uid == widget.recipe.authorId;

    return Scaffold(
      backgroundColor: Color.fromRGBO(24, 25, 28, 100),
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
                    child: Image.network(
                      widget.recipe.imageUrl,
                      height: 380,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 380,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),

                  //back button
                  Positioned(
                    top: 30,
                    left: 25,
                    child: Container(
                      key: ValueKey('back_button'),
                      width: 50,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
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
                          onTap: () => Navigator.pop(context),
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
                  // save button
                  if (!_isEditing)
                    Positioned(
                      top: 20,
                      right: 15,
                      child: StreamBuilder<List<String>>(
                        stream: user != null && !user.isAnonymous
                            ? _recipeService.getSavedRecipeIds(user.uid)
                            : Stream.value([]),
                        builder: (context, snapshot) {
                          final savedIds = (snapshot.data ?? []).toSet();
                          final isSaved = savedIds.contains(widget.recipe.id);

                          return GestureDetector(
                            onTap: () async {
                              if (user == null || user.isAnonymous) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please log in to save recipes",
                                    ),
                                  ),
                                );
                                return;
                              }

                              try {
                                if (isSaved) {
                                  await _recipeService.unsaveRecipe(
                                    user.uid,
                                    widget.recipe.id,
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Removed from saved"),
                                      ),
                                    );
                                  }
                                } else {
                                  await _recipeService.saveRecipe(
                                    user.uid,
                                    widget.recipe.id,
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Recipe saved"),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Failed to save. Try again."),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSaved
                                    ? Colors.grey[700]
                                    : Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isSaved ? "Saved" : "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
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
                    // Category
                    _isEditing
                        ? _buildEditableField(
                            controller: _categoryController,
                            label: "Category",
                          )
                        : Text(
                            widget.recipe.category,
                            style: GoogleFonts.dmSerifText(
                              color: Colors.grey,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                    SizedBox(height: 10),

                    // Title
                    _isEditing
                        ? _buildEditableField(
                            controller: _titleController,
                            label: "Title",
                            fontSize: 32,
                          )
                        : Text(
                            widget.recipe.title,
                            style: GoogleFonts.dmSerifText(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    SizedBox(height: 10),

                    // Author and Cook Time Row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('pictures/logo.png'),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.recipe.authorName,
                          style: GoogleFonts.dmSerifText(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: const Color.fromRGBO(120, 165, 90, 100),
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cooking Time",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                  _isEditing
                                      ? SizedBox(
                                          width: 60,
                                          child: TextField(
                                            controller: _cookTimeController,
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.zero,
                                              suffixText: "hour",
                                              suffixStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Text(
                                          "${widget.recipe.cookTimeMinutes} hour",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Description
                    Text(
                      "Description",
                      style: GoogleFonts.dmSerifText(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _isEditing
                        ? _buildEditableField(
                            controller: _descriptionController,
                            label: "Description",
                            maxLines: 5,
                          )
                        : Text(
                            widget.recipe.description,
                            style: GoogleFonts.dmSerifText(
                              color: Colors.grey,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                    SizedBox(height: 30),

                    // Ingredients
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ingredients",
                          style: GoogleFonts.dmSerifText(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isEditing)
                          IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.green),
                            onPressed: _addIngredient,
                          ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ..._ingredientControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final controller = entry.value;

                      if (_isEditing) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.circle, size: 6, color: Colors.grey),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  style: GoogleFonts.dmSerifText(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Enter ingredient",
                                    hintStyle: GoogleFonts.dmSerifText(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => _removeIngredient(index),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.circle, size: 6, color: Colors.grey),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  controller.text,
                                  style: GoogleFonts.dmSerifText(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                    SizedBox(height: 30),

                    // Directions/Steps
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Directions",
                          style: GoogleFonts.dmSerifText(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isEditing)
                          IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.green),
                            onPressed: _addStep,
                          ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ..._stepControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final controller = entry.value;

                      if (_isEditing) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ",
                                style: GoogleFonts.dmSerifText(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  maxLines: null,
                                  style: GoogleFonts.dmSerifText(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Enter step",
                                    hintStyle: GoogleFonts.dmSerifText(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                onPressed: () => _removeStep(index),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}. ",
                                style: GoogleFonts.dmSerifText(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  controller.text,
                                  style: GoogleFonts.dmSerifText(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),

                    // edit/update button, if the post belongs to you
                    if (isOwner) ...[
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isEditing
                                  ? _updateRecipe
                                  : () {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    },
                              icon: Icon(
                                _isEditing ? Icons.save : Icons.edit,
                                size: 20,
                              ),
                              label: Text(
                                _isEditing ? "Update" : "Edit",
                                style: GoogleFonts.dmSerifText(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(
                                  120,
                                  165,
                                  90,
                                  100,
                                ),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          if (_isEditing) ...[
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                    _initializeControllers();
                                  });
                                },
                                icon: Icon(Icons.cancel, size: 20),
                                label: Text(
                                  "Cancel",
                                  style: GoogleFonts.dmSerifText(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[700],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (!_isEditing) ...[
                            SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _showDeleteConfirmation,
                                icon: Icon(Icons.delete, size: 20),
                                label: Text(
                                  "Delete",
                                  style: GoogleFonts.dmSerifText(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    double fontSize = 14,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.dmSerifText(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: fontSize > 20 ? FontWeight.bold : FontWeight.normal,
      ),
      decoration: InputDecoration(
        hintText: "Enter $label",
        hintStyle: GoogleFonts.dmSerifText(
          color: Colors.grey,
          fontSize: fontSize,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
