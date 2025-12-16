import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/recipe_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload Image
  Future<String> uploadRecipeImage(XFile image, String uid) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('recipeImages/$uid/$fileName.jpg');

      // specific metadata for correct mime type handling
      final metadata = SettableMetadata(contentType: 'image/jpeg');

      // Use putData with readAsBytes for cross-platform support (Web & Mobile)
      // This avoids using dart:io File which crashes on Web
      Uint8List fileBytes = await image.readAsBytes();
      await ref.putData(fileBytes, metadata);

      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  // Create Recipe
  Future<void> createRecipe(RecipeModel recipe) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");
      String authorName = "Chef";

      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists && userDoc.data() != null) {
          authorName =
              userDoc.data()!['displayName'] ?? user.displayName ?? "Chef";
        } else {
          // Fallback to Auth displayName
          authorName = user.displayName ?? "Chef";
        }
      } catch (e) {
        print("Error fetching user name: $e");
        authorName = user.displayName ?? "Chef";
      }

      DocumentReference docRef = _firestore.collection('recipes').doc();
      RecipeModel newRecipe = RecipeModel(
        id: docRef.id,
        title: recipe.title,
        description: recipe.description,
        ingredients: recipe.ingredients,
        steps: recipe.steps,
        category: recipe.category,
        cookTimeMinutes: recipe.cookTimeMinutes,
        imageUrl: recipe.imageUrl,
        authorId: recipe.authorId,
        authorName: authorName,
        createdAt: recipe.createdAt,
        updatedAt: recipe.updatedAt,
      );

      await docRef.set(newRecipe.toMap());
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

  // Save Recipe
  Future<void> saveRecipe(String uid, String recipeId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('savedRecipes')
          .doc(recipeId)
          .set({'savedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      rethrow;
    }
  }

  // Unsave Recipe
  Future<void> unsaveRecipe(String uid, String recipeId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('savedRecipes')
          .doc(recipeId)
          .delete();
    } catch (e) {
      rethrow;
    }
  }

  // Get Saved Recipe IDs Stream
  Stream<List<String>> getSavedRecipeIds(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('savedRecipes')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.id).toList();
        });
  }

  Future<void> updateRecipe(String recipeId, Map<String, dynamic> data) async {
    await _firestore.collection('recipes').doc(recipeId).update(data);
  }

  Future<void> deleteRecipe(String recipeId) async {
    await _firestore.collection('recipes').doc(recipeId).delete();
  }
}
