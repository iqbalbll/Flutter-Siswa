import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 2;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/presensi');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF71E7FF), Color(0xFF008EBD)],
            stops: [0.019, 0.19],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenWidth * 0.04),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quiz',
                        style: TextStyle(
                          color: const Color.fromRGBO(0, 97, 129, 1),
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Karla',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 17, top: 8),
                        child: Text(
                          'Kerjakan quiz dengan jujur dan teliti! Jawablah dengan penuh perhatian untuk hasil terbaik. Semangat! 🚀📚',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Karla',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.08),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.04),
                      topRight: Radius.circular(screenWidth * 0.04),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: screenWidth * 0.05,
                        offset: Offset(0, screenWidth * 0.02),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      children: [
                        _buildRowCard(
                          title: 'Quiz Matematika',
                          images: ['assets/images/mtk.png'],
                          screenWidth: screenWidth,
                          ontap: () {
                            Navigator.pushNamed(context, '/quizmtk');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'Quiz Bahasa Inggris',
                          images: ['assets/images/bing.png'],
                          screenWidth: screenWidth,
                          ontap: () {
                            Navigator.pushNamed(context, '/quizbing');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'Quiz PKN',
                          images: ['assets/images/pkn.png'],
                          screenWidth: screenWidth,
                          ontap: () {
                            Navigator.pushNamed(context, '/quizpkn');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'Quiz Bahasa Indonesia',
                          images: [
                            'assets/images/bind1.png',
                            'assets/images/bind2.png',
                          ],
                          screenWidth: screenWidth,
                          imageWidthFactor: 0.19,
                          imageHeightFactor: 0.19,
                          ontap: () {
                            Navigator.pushNamed(context, '/quizbin');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'Quiz Agama Islam',
                          images: ['assets/images/PAI.png'],
                          screenWidth: screenWidth,
                          imageWidthFactor: 0.19,
                          imageHeightFactor: 0.19,
                          ontap: () {
                            Navigator.pushNamed(context, '/quizpai');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'ilmu Pengetahuan Alam',
                          images: ['assets/images/ipa.png'],
                          screenWidth: screenWidth,
                          imageWidthFactor: 0.19,
                          imageHeightFactor: 0.19,
                          ontap: () {
                            Navigator.pushNamed(context, '/quizipa');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'ilmu Pengetahuan Sosial',
                          images: ['assets/images/ips.png'],
                          screenWidth: screenWidth,
                          imageWidthFactor: 0.19,
                          imageHeightFactor: 0.19,
                          ontap: () {
                            Navigator.pushNamed(context, '/quizips');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildRowCard({
    required String title,
    required List<String> images,
    required double screenWidth,
    double imageWidthFactor = 0.35,
    double imageHeightFactor = 0.2,
    VoidCallback? ontap,
  }) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: double.infinity,
        height: screenWidth * 0.28,
        padding: EdgeInsets.all(screenWidth * 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(0),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: screenWidth * 0.05,
              offset: Offset(0, screenWidth * 0.015),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    images
                        .map(
                          (url) => Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.015,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.02,
                              ),
                              child: Image.asset(
                                url,
                                width: screenWidth * imageWidthFactor,
                                height: screenWidth * imageHeightFactor,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFFFC971).withOpacity(0.9),
                      Color(0xFFFFC971).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenWidth * 0.02,
              left: screenWidth * 0.03,
              child: Text(
                title,
                style: TextStyle(
                  color: const Color(0xFF006181),
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Karla',
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 2.0,
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(-1.0, -1.0),
                      blurRadius: 2.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
