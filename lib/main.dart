import 'package:flutter/material.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/view-models/Authviewmodel.dart';
import 'package:flutter_movies_app_mohamedhedi_magherbi/views/Auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Hello',
  //     theme: ThemeData(
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),
  //     home:  LoginPage(),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Authviewmodel()),
        ],
        child: MaterialApp(
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
          home: LoginPage(),
        ));
  }
}
