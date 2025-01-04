import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hintText,
      IconData? prefixIcon,
      bool isPassword = false,
      bool obscureText = false,
      VoidCallback? toggleVisibility}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Colors.blue.withOpacity(0.1),
        filled: true,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: isPassword
            ? IconButton(
                icon:
                    Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: toggleVisibility)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

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
                children: const [
                  SizedBox(height: 60),
                  Text(
                    "Sign Up",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
                  ),
                  Text("Create an account"),
                ],
              ),
              Column(
                children: [
                  _buildTextField(
                    controller: _usernameController,
                    hintText: "Username",
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    hintText: "Email",
                    prefixIcon: Icons.mail,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    prefixIcon: Icons.key,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    toggleVisibility: _togglePasswordVisibility,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _confirmpassController,
                    hintText: "Confirm Password",
                    prefixIcon: Icons.key,
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    toggleVisibility: _toggleConfirmPasswordVisibility,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();
                  final username = _usernameController.text.trim();
                  final confirmpass = _confirmpassController.text.trim();

                  if (username.isEmpty || email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Please fill in all fields")),
                    );
                    return;
                  }

                  if (password != confirmpass) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Passwords do not match")),
                    );
                    return;
                  }
                  authViewModel.register(email, password, username, context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Sign up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const Center(child: Text("------------ OR ------------")),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextButton(
                  onPressed: () {
                    authViewModel.signInWithGoogle(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/google.png',
                        height: 30.0,
                        width: 30.0,
                      ),
                      const Text("Sign in with Google"),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account ?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 159, 159, 159),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
