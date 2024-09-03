import 'package:flutter/material.dart';
import 'screen/login_page.dart';
import 'screen/startUp_page.dart';
import 'components/manage_bottom_navbar.dart';
import 'screen/createAccount_page.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decubitus App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const FirstScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/create-account': (context) => const CreateaccountPage(),
      },
    );
  }
}
