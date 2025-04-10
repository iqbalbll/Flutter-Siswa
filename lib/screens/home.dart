import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import 'jadwal.dart';
import 'login.dart';
import '../widgets/bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SizedBox(
        width: screenWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, screenWidth),
              _buildScheduleCard(screenWidth, context),
              _buildRecommenderSection(screenWidth),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/presensi');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/quiz');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profil');
              break;
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF71E7FF), Color(0xFF008EBD)],
        ),
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
      padding: const EdgeInsets.only(top: 57, left: 16, right: 16, bottom: 12),
      child: Column(
        children: [
          // Row untuk teks dan tombol keluar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selamat Pagi', style: AppTheme.karlaBlue),
                  Text('User', style: AppTheme.karlaBold),
                ],
              ),
              InkWell(
                onTap: () {
                  print("Menuju halaman Home...");
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/logout.png',
                      width: screenWidth * 0.08,
                      height: screenWidth * 0.08,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: screenWidth * 0.01),
                    Text(
                      'Keluar',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            child: Image.asset(
              'assets/images/home.png',
              width: screenWidth,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(double screenWidth, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Container(
        width: screenWidth * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.5,
              ), // Warna bayangan lebih gelap
              offset: const Offset(4, 4), // Offset lebih besar
              blurRadius: 30, // Blur lebih besar
              spreadRadius: 1, // Spread lebih besar
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/jadwal.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50);
                },
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text('Jadwal', style: AppTheme.scheduleTitle),
                  const SizedBox(height: 18),
                  Text(
                    'Cek Jadwal kamu disini',
                    style: AppTheme.scheduleSubtitle,
                  ),
                  const SizedBox(height: 25),
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: 26,
                      maxWidth: 84,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 142, 189, 1),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                            0.5,
                          ), // Warna bayangan lebih gelap
                          offset: const Offset(4, 4), // Offset lebih besar
                          blurRadius: 30, 
                          spreadRadius: -11, // Spread lebih besar
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JadwalWidget(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Lihat',
                              style: AppTheme.scheduleSubtitle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommenderSection(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 17),
            child: Text(
              'Web EduBook Recommender',
              style: AppTheme.scheduleTitle,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              const url = 'https://buku.kemdikbud.go.id/';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(4, 4),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Image.network(
                'assets/images/sibi.png',
                width: screenWidth,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
