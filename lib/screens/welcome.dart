import 'package:flutter/material.dart';
import 'login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFC971), Color(0xFF008EBD)],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.05),
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/logo-nm.png',
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.065,
                      fontFamily: 'Karla',
                      fontWeight: FontWeight.w800,
                      color: const Color.fromRGBO(0, 97, 129, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Di Sistem Informasi SMPN 5 Lamongan.',
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      fontFamily: 'Karla',
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(0, 97, 129, 1),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/welcome.png',
                  width: screenWidth * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(_createRouteToLogin()),
              child: Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.04),
                width: screenWidth * 0.8,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                decoration: BoxDecoration(
                  color: const Color(0xEE71E7FF),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(2, 2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Masuk untuk melanjutkan',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontFamily: 'Karla',
                      fontWeight: FontWeight.w800,
                      color: const Color.fromRGBO(0, 97, 129, 1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRouteToLogin() {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0), // dari kanan ke kiri
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));

      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
}

