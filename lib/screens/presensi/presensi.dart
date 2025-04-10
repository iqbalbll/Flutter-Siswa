import 'package:flutter/material.dart';
import '../../widgets/bottom_nav_bar.dart';

class PresensiScreen extends StatefulWidget {
  const PresensiScreen({Key? key}) : super(key: key);

  @override
  _PresensiScreenState createState() => _PresensiScreenState();
}

class _PresensiScreenState extends State<PresensiScreen> {
  int _currentIndex = 1;

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
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/quiz');
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
      // appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF71E7FF), // biru muda
              Color(0xFF008EBD), // biru tua
            ],
            stops: [0.019, 0.19], // atur posisi transisi warnanya
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
                        'Presensi',
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
                          'Silakan lakukan presensi untuk mencatat kehadiran Anda. Jangan lupa, kehadiran Anda penting!',
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
                      // bawah flat (tanpa radius)
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
                          title: 'Matematika',
                          images: [
                            'assets/images/mtk.png',
                          ],
                          screenWidth: screenWidth,
                          onTap: () {
                            Navigator.pushNamed(context, '/presensi_mtk');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'Bahasa Inggris',
                          images: [
                            'assets/images/bing.png',
                          ],
                          screenWidth: screenWidth,
                          onTap: () {
                            Navigator.pushNamed(context, '/presensi_bing');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'Pendidikan Kewarga \nNegaraan',
                          images: [
                            'assets/images/pkn.png',
                          ],
                          screenWidth: screenWidth,
                          onTap: () {
                            Navigator.pushNamed(context, '/presensi_pkn');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'Bahasa Indonesia',
                          images: [
                            'assets/images/bind1.png',
                            'assets/images/bind2.png',
                          ],
                          screenWidth: screenWidth,
                          imageWidthFactor: 0.19,
                          imageHeightFactor: 0.19,
                          onTap: () {
                            Navigator.pushNamed(context, '/presensi_bind');
                          },
                        ),
                        SizedBox(height: screenWidth * 0.04),
                        _buildRowCard(
                          title: 'Agama Islam',
                          images: [
                            'assets/images/PAI.png',
                          ],
                          screenWidth: screenWidth,
                          imageWidthFactor: 0.19,
                          imageHeightFactor: 0.19,
                          onTap: () {
                            Navigator.pushNamed(context, '/presensi_pai');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0),
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
    VoidCallback? onTap, // Tambahkan parameter onTap
  }) {
    return GestureDetector(
      onTap: onTap, // Navigasi saat kartu diklik
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
            // Gambar ditampilkan di tengah
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: images
                    .map(
                      (url) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.015,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.02,
                          ),
                          child: Image.network(
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

            // Gradien di belakang teks
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(0),
                ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF008EBD).withOpacity(0.9),
                      Color(0xFF008EBD).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Teks judul dengan shadow putih
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
