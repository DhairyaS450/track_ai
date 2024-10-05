import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();

  // Sign up with email and password
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
    required String levelOfStudy,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        //Create document in firestore database
        await _firestoreDatabase.createUser(
          userId: user.uid,
          name: name,
          email: email,
          levelOfStudy: levelOfStudy,
        );
      }

      return user;
    } on FirebaseAuthException catch (e) {
      log('Error: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log('Error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log('Error signing out: $e');
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw 'No user to send verification to.';
    }
  }

  // Get the currently signed-in user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream for auth changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
