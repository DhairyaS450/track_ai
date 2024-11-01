import 'dart:developer';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/calendar',
      'https://www.googleapis.com/auth/calendar.events',
    ],
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      log(googleAccount!.email);
      return googleAccount;
    } catch (error) {
      log(error.toString());
      return null;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
  }

  Future<GoogleSignInAccount?> getCurrentUser() async {
    return _googleSignIn.currentUser;
  }
}
