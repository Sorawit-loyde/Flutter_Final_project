import 'package:flutter/material.dart';
import 'components/manage_screen_properties.dart';
import 'screen/createAccount_page.dart';
import 'screen/login_page.dart';
import 'screen/startUp_page.dart';

void main() {
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
        '/create-account': (context) => const CreateAccountPage(),
      },
    );
  }
}
