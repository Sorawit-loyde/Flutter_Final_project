import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/manage_screen_properties.dart';
import 'screen/createAccount_page.dart';
import 'screen/login_page.dart';
import 'screen/startUp_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final hasLoginInfo =
      prefs.containsKey('ssid') && prefs.containsKey('password');
  runApp(MyApp(initialRoute: hasLoginInfo ? '/home' : '/'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Decubitus App',
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const StartupPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/create-account': (context) => const CreateAccountPage(),
      },
    );
  }
}
