import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            width: screenWidth,
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Header profil dengan background & foto
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
                    ),
                    Positioned(
                      top: 0,
                      left: (screenWidth / 2) - (screenWidth * 0.09),
                      child: Image.asset(
                        'assets/images/logo-nm.png',
                        width: screenWidth * 0.18,
                        fit: BoxFit.contain,
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
                            color: const Color.fromARGB(255, 0, 142, 189),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.15),

                // Stack informasi dengan background logo
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.04),
                      child: Transform.translate(
                        offset: Offset(screenWidth * 0.6, -screenHeight * -0.13),
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
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoCard('Nama Lengkap :'),
                          SizedBox(height: screenHeight * 0.02),
                          _buildInfoCard('Email Pengguna :'),
                          SizedBox(height: screenHeight * 0.02),
                          _buildInfoCard('Nomor Induk :'),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.06),

                // Setting di bawah tengah
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/setting');
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/setting.png',
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 1),
                        const Text(
                          "Pengaturan",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.1), // agar tidak terlalu dekat nav bar
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/presensi');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/quiz');
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }

  Widget _buildInfoCard(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'Karla',
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
