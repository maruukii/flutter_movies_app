import 'package:flutter/material.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/services/auth_service.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Home/home.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Auth/login.dart';

class Authviewmodel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  String? username = "";
  String? email = "";
  Future<bool> register(String email, String password, String username,
      BuildContext context) async {
    try {
      final user =
          await _authService.registerWithEmail(email, username, password);
      username = username;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in as $username")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
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
      username = user;
      notifyListeners();
      // Notifie les widgets que l'état a changé
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in as $username")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
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
      username = user?.displayName?.split(" ")[0];
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logged in as $username")),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
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
