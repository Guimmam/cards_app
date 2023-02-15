import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  linkEmailGoogle() async {
    //get currently logged in user
    User? existingUser = await FirebaseAuth.instance.currentUser;

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //now link these credentials with the existing user
    await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      final credential =
          EmailAuthProvider.credential(email: email, password: password);
      await FirebaseAuth.instance.signInWithCredential(credential);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future createAccountWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await user!.updateDisplayName(username);
      linkEmailGoogle();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future linkAccounts(AuthCredential credential) async {
    try {
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
    }
  }

  Future logout() async {
    try {
      await googleSignIn.disconnect();
    } catch (e) {
      print(e);
    } finally {
      FirebaseAuth.instance.signOut();
      notifyListeners();
    }
  }
}
