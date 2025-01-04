import 'package:flutter/material.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/services/auth_service.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Home/home.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Auth/login.dart';

class Authviewmodel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<bool> register(String email, String password, String username,
      BuildContext context) async {
    try {
      final user =
          await _authService.registerWithEmail(email, username, password);
      notifyListeners(); // Notifie les widgets que l'état a changé
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(username: username)));
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
      final String? username =
          await _authService.loginWithEmail(email, password);
      notifyListeners();
      // Notifie les widgets que l'état a changé
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(username: username)));
      return username != null;
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
    } catch (e) {
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la déconnexion : $e")),
      );
    }
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      final user = await _authService.loginWithGoogle();
      notifyListeners(); // Notifie les widgets que l'état a changé
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(username: user!.email!)));
      return user != null;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    notifyListeners();
  }
}
