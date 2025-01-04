import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> loginWithEmail(String email, String password) async {
    try {
      String realEmail = '';
      String username = "";
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: email)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        realEmail = querySnapshot.docs.first['email'];
        username = email;
      } else {
        realEmail = email;
        querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          username = querySnapshot.docs.first['username'];
        }
      }
      // Sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: realEmail,
        password: password,
      );
      return username;
    } catch (e) {
      throw Exception("Failed to login: $e");
    }
  }

  Future<User?> registerWithEmail(
      String email, String username, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').add({
        'username': username,
        'email': email,
      });
      return userCredential.user;
    } catch (e) {
      throw Exception("Failed to register user: $e");
    }
  }

  Future<User?> loginWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final String? user = userCredential.user?.email;
      if (user != null) {
        return userCredential.user;
      }
    } catch (e) {
      throw Exception("Failed to login with google: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
