import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Home/home.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<Authviewmodel>(context);

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height - 50,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 60,
                          ),
                          Text("Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 38)),
                          Text("Create an account"),
                        ],
                      ),
                      Column(children: [
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              hintText: "Username",
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              )), // OutlineInputBorder // InputDecoration
                        ), // TextField
                        SizedBox(
                          height: 20,
                        ), // SizedBack
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: Icon(Icons.mail),
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: Icon(Icons.password),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _confirmpassController,
                          decoration: InputDecoration(
                              fillColor: Colors.blue.withOpacity(0.1),
                              filled: true,
                              prefixIcon: Icon(Icons.password),
                              hintText: "Confirm password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  borderSide: BorderSide.none)),
                        ),
                      ]),
                      ElevatedButton(
                        onPressed: () {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final username = _usernameController.text.trim();
                          final confirmpass =
                              _confirmpassController.text.trim();
                          if (password != confirmpass) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Passwords do not match")));
                            return;
                          }
                          authViewModel.register(
                              email, password, username, context);
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: StadiumBorder()),
                      ),
                      Center(child: Text("------------ OR ------------")),
                      Container(
                          height: 45,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(24)),
                          child: TextButton(
                            onPressed: () {
                              authViewModel.signInWithGoogle(context);
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              AssetImage('images/google.png'),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const Text("Sign in with Google")
                                ]),
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account ?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 159, 159, 159)),
                            ),
                            TextButton(
                                onPressed: () => {Navigator.pop(context)},
                                child: Text("Sign In",
                                    style: TextStyle(color: Colors.blue)))
                          ])
                    ]))));
  }
}
