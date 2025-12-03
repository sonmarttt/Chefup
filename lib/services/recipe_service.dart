import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recipe_model.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload Image
  Future<String> uploadRecipeImage(File image, String uid) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('recipeImages/$uid/$fileName.jpg');

      // Upload the file and wait for it to complete
      await ref.putFile(image);

      // Get the download URL from the SAME reference
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  // Create Recipe
  Future<void> createRecipe(RecipeModel recipe) async {
    try {
      // We use the recipe.id if it's set, or let Firestore generate one if we passed an empty one?

      DocumentReference docRef = _firestore.collection('recipes').doc();

      // Create a map from the recipe but with the new ID
      Map<String, dynamic> data = recipe.toMap();
      data['id'] = docRef.id; // Ensure the ID in the document matches the doc ID

      await docRef.set(data);
    } catch (e) {
      rethrow;
    }
  }

  // Get All Recipes
  Stream<List<RecipeModel>> getAllRecipes() {
    return _firestore
        .collection('recipes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RecipeModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get Recipes by Author
  Stream<List<RecipeModel>> getRecipesByAuthor(String uid) {
    return _firestore
        .collection('recipes')
        .where('authorId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RecipeModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
