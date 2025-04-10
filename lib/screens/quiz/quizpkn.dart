import 'package:flutter/material.dart';
import 'quiz.dart';

/// Widget header yang bisa digunakan ulang
Widget _buildHeader(BuildContext context, double screenWidth, double screenHeight) {
  return Container(
    width: screenWidth,
    padding: EdgeInsets.symmetric(
      horizontal: screenWidth * 0.06,
      vertical: screenHeight * 0.025,
    ),
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
    ),
    child: Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const QuizScreen()),
            );
          },
          child: Image.asset(
            'assets/icons/out.png',
            width: screenWidth * 0.08,
            height: screenWidth * 0.08,
            fit: BoxFit.contain,
          ),
        ),
        const Spacer(),
        Text(
          'Quiz pendidikan Pancasila',
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF006181),
          ),
        ),
        const Spacer(), // agar teks berada di tengah, seimbang dengan ikon
        SizedBox(width: screenWidth * 0.08), // Placeholder untuk posisi out icon
      ],
    ),
  );
}

class QuizpknScreen extends StatelessWidget {
  const QuizpknScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double minHeight = screenHeight * 0.11;
    final double maxWidth = screenWidth * 0.85;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 208, 243, 255),
              Color(0xFF008EBD),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context, screenWidth, screenHeight),
            SizedBox(height: screenHeight * 0.03),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Quiz yang harus dikerjakan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.039,
                      fontFamily: 'Karla',
                      fontWeight: FontWeight.w800,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035),

                  // Kartu Sub BAB
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                      minHeight: minHeight,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(-5, -5),
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.25),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sub BAB',
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontFamily: 'Karla',
                              color: const Color(0xFF006181),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                                vertical: screenHeight * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF71E7FF),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text(
                                'Mulai',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontFamily: 'Karla',
                                  color: const Color(0xFF006181),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
