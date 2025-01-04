import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Auth/signup.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Home/home.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<Authviewmodel>(context);
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _header(),
            _inputfield(authViewModel, context),
            _signInWithGoogle(authViewModel, context),
            _signUp(context),
          ],
        ),
      ),
    );
  }
}

_header() {
  return Column(
    children: [
      Text(
        "MoviesDB",
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      Text("Enter your credentials to login !")
    ],
  );
}

_inputfield(Authviewmodel authviewmodel, BuildContext context) {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      TextField(
        controller: _emailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
          filled: true,
          prefixIcon: Icon(Icons.person),
          fillColor: Colors.blue.withOpacity(0.1),
          hintText: "Email/Username",
        ),
      ),
      SizedBox(
        height: 10,
      ),
      TextField(
        controller: _passwordController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            filled: true,
            prefixIcon: Icon(Icons.key),
            fillColor: Colors.blue.withOpacity(0.1),
            hintText: "Password"),
      ),
      SizedBox(
        height: 10,
      ),
      ElevatedButton(
          onPressed: () {
            final email = _emailController.text.trim();
            final password = _passwordController.text.trim();
            authviewmodel.login(email, password, context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: StadiumBorder(),
          ),
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ))
    ],
  );
}

_forgetPass() {
  return TextButton(
    onPressed: () {},
    child: const Text(
      "Forget Password",
      style: TextStyle(fontSize: 16, color: Colors.blue),
    ),
  );
}

_signInWithGoogle(Authviewmodel authViewModel, BuildContext context) {
  return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
    Center(child: Text("------------ OR ------------")),
    Container(
        height: 45,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(24)),
        child: TextButton(
          onPressed: () {
            authViewModel.signInWithGoogle(context);
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 30.0,
              width: 30.0,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/google.png'),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle),
            ),
            const Text("Sign in with Google")
          ]),
        )),
  ]);
}

_signUp(context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _forgetPass(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account? ",
            style: TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 159, 159, 159)),
          ),
          TextButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              )
            },
            child: Text(
              "Sign Up",
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    ],
  );
}
