import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth State Changes Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Create user document in Firestore
        UserModel newUser = UserModel(
          uid: user.uid,
          email: email,
          displayName: name,
          role: 'user',
          createdAt: Timestamp.now(),
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Login
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Check if user is Guest
  bool get isGuest {
    return _auth.currentUser?.isAnonymous ?? true;
  }

  // Check if user is Admin
  Future<bool> isAdmin(String? uid) async {
    if (uid == null) return false;
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['role'] == 'admin';
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
