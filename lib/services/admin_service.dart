import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetching all users
  Stream<List<Map<String, dynamic>>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id; // Include UID in the map
        return data;
      }).toList();
    });
  }

  // Deleting user data
  Future<void> deleteUserData(String uid) async {
    try {
      // 1. Deleting user's recipes
      final recipesSnapshot = await _firestore
          .collection('recipes')
          .where('authorId', isEqualTo: uid)
          .get();

      for (var doc in recipesSnapshot.docs) {
        await doc.reference.delete();
      }

      // 2. Deleting user's saved recipes subcollection
      final savedRecipesSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('savedRecipes')
          .get();
      
      for (var doc in savedRecipesSnapshot.docs) {
        await doc.reference.delete();
      }

      // 3. Deleting the user document itself
      await _firestore.collection('users').doc(uid).delete();

    } catch (e) {
      print("Error deleting user data: $e");
      rethrow;
    }
  }
}
