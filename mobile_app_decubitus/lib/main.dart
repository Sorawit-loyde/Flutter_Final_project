// import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'components/manage_screen_properties.dart';
import 'firebase_options.dart';
import 'screen/createAccount_page.dart';
import 'screen/login_page.dart';
import 'screen/startUp_page.dart';

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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Decubitus App',
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/create-account': (context) => CreateAccountPage(),
      },
    );
  }
}
