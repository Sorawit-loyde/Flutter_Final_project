import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/auth_service.dart';
import 'package:mobile_app_decubitus/screen/otp_send_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _checkLoginInfo();
  }

  Future<void> _checkLoginInfo() async {
    final loginInfo = await _authService.getLoginInfo();
    if (loginInfo != null) {
      _ssidController.text = loginInfo['ssid']!;
      _passwordController.text = loginInfo['password']!;
      _signIn();
    }
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signIn(
            _ssidController.text, _passwordController.text);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() {
          _errorMessage = "Login failed. Please try again.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor1,
      body: Center(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 10),
                      _buildWelcomeMessage(),
                      const SizedBox(height: 30),
                      _buildImage(),
                      const SizedBox(height: 30),
                      _buildSsidField(),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 10),
                      _buildForgotPasswordButton(),
                      const SizedBox(height: 10),
                      _buildSignInButton(),
                      const SizedBox(height: 20),
                      _buildCreateAccountButton(context),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'เข้าสู่ระบบ',
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w900,
        color: primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildWelcomeMessage() {
    return const Text(
      'เข้าสู่ระบบด้วยหมายเลขบัตรประชาชน',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
      softWrap: false,
    );
  }

  Widget _buildImage() {
    return Image.asset(
      logoImage,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  Widget _buildSsidField() {
    return TextField(
      controller: _ssidController,
      decoration: InputDecoration(
        labelText: 'เลขบัตรประชาชน',
        filled: true,
        fillColor: secondaryColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: primaryColor)),
        contentPadding: const EdgeInsets.all(15),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'รหัสผ่าน',
        filled: true,
        fillColor: secondaryColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: primaryColor)),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: primaryColor,
          ),
        ),
        contentPadding: const EdgeInsets.all(15),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtpSendPage()),
          );
        },
        child: const Text(
          'ลืมรหัสผ่าน?',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (_ssidController.text.isEmpty ||
              _passwordController.text.isEmpty) {
            setState(() {
              _errorMessage = "เลขบัตรประชาชนหรือรหัสผ่านต้องเว้นว่าง";
            });
            return;
          }

          try {
            await _authService.signIn(
                _ssidController.text, _passwordController.text);
            Navigator.pushReplacementNamed(context, '/home');
          } catch (e) {
            setState(() {
              _errorMessage =
                  "เลขบัตรประชาชนหรือรหัสผ่านไม่ถูกต้อง กรุณาลองใหม่";
            });
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.center,
        child: const Text(
          'เข้าสู่ระบบ',
          style: TextStyle(color: backGroundColor1),
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/create-account');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.center,
        child: const Text(
          'สร้างบัญชีผู้ใช้',
          style: TextStyle(color: backGroundColor1),
        ),
      ),
    );
  }
}
