import 'package:flutter/material.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final String useremail = "3123521032"; 
  final String pass = "123";
  String notif = " ";

  void login(String email, String password) {
  if (email == useremail && password == pass) {
    setState(() {
      notif = " ";
    });

    Navigator.of(context).push(_createFadeRoute());
  } else {
    setState(() {
      notif = "Nomor Induk atau password salah";
    });
  }
}


  // Fungsi validasi nomor induk berbasis angka
  String? validateNomorInduk(String? value) {
    const pattern = r'^[0-9]{6,12}$'; // hanya angka, 6 sampai 12 digit
    final regex = RegExp(pattern);
    return value == null || !regex.hasMatch(value)
        ? 'Masukkan Nomor Induk yang valid (hanya angka)'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Center(
            child: Container(
              color: Colors.white,
              width: screenWidth,
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  // HEADER
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: screenWidth,
                        height: screenHeight * 0.38,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF71E7FF), Color(0xFF008EBD)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.05),
                            child: Image.asset(
                              'assets/images/login.png',
                              height: screenHeight * 0.2,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -screenWidth * 0.12,
                        left: (screenWidth / 2) - (screenWidth * 0.12),
                        child: Container(
                          width: screenWidth * 0.24,
                          height: screenWidth * 0.24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.01),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/icons/profile.png',
                              color: const Color(0xFF008EBD),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.13),

                  // FORM LOGIN + DEKORASI LOGO
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.04),
                        child: Transform.translate(
                          offset: Offset(screenWidth * 0.6, screenHeight * 0.13),
                          child: Opacity(
                            opacity: 0.5,
                            child: Image.asset(
                              'assets/images/LOGO.png',
                              width: screenWidth * 0.6,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.1,
                          vertical: screenHeight * 0.02,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nomor Induk',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildInputField(
                              controller: emailController,
                              hintText: 'Ketik Disini',
                              iconPath: 'assets/icons/user.png',
                              validator: validateNomorInduk,
                            ),
                            const SizedBox(height: 16),

                            const Text(
                              'Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildInputField(
                              controller: passwordController,
                              hintText: 'Ketik Disini',
                              iconPath: 'assets/icons/lock.png',
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),

                            Center(
                              child: SizedBox(
                                width: screenWidth * 0.4,
                                child: ElevatedButton(
                                  onPressed: () => login(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF008EBD),
                                    foregroundColor: const Color(0xFF71E7FF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Log-in',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Karla',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Text(
                                notif,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String iconPath,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              iconPath,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: Color(0xFF868686),
                  fontSize: 14,
                  fontFamily: 'Karla',
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createFadeRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
    transitionDuration: const Duration(milliseconds: 600),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

