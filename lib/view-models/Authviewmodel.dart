import 'package:flutter/material.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/services/auth_service.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Auth/login.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/navigation.dart';

class Authviewmodel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? username = "";
  String email = "";
  Future<bool> register(String email, String password, String username,
      BuildContext context) async {
    try {
      final user =
          await _authService.registerWithEmail(email, username, password);
      await getUserData(context);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in as $username")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigationPage()));
      return user != null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      final String? user = await _authService.loginWithEmail(email, password);
      await getUserData(context);
      notifyListeners();
      // Notifie les widgets que l'état a changé
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in as $username")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigationPage()));
      return user != null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      notifyListeners();
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _authService.logout();

      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("you have been disconnected successfully.")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
      username = "";
      email = "";
    } catch (e) {
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error while disconnecting : $e")),
      );
    }
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      final user = await _authService.loginWithGoogle();
      notifyListeners();
      await getUserData(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in as $username")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => NavigationPage()));
      return user != null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      notifyListeners();
      return false;
    }
  }

  Future<void> getUserData(BuildContext context) async {
    final userData = await _authService.getUserData();
    username = userData.docs.first["username"] ?? 'Unknown';
    email = userData.docs.first["email"] ?? 'No Email';
    // _base64Image = userData.docs.first["email"];
  }

  void clearError() {
    notifyListeners();
  }
}
