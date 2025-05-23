import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'jadwal.dart';
import 'login.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String namaLengkap = "User";

  @override
  void initState() {
    super.initState();
    _loadNamaLengkap();
  }
  Future<void> _loadNamaLengkap() async {
    final nama = await fetchNamaLengkap();
    if (nama != null && mounted) {
      setState(() {
        namaLengkap = nama;
      });
    }
  }

  Future<String?> fetchNamaLengkap() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Try to get name from SharedPreferences first
    final savedName = prefs.getString('namaLengkap');
    if (savedName != null) {
      return savedName;
    }

    // If not found in SharedPreferences, fetch from API
    final userId = prefs.getInt('userId');
    if (userId == null) return 'User';
    
    final response = await http.get(
      Uri.parse('http://3.0.151.126/api/admin/penggunas/$userId'),
    );
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null) {
        final nama = data['data']['nama'];
        if (nama != null) {
          // Save name to SharedPreferences for future use
          await prefs.setString('namaLengkap', nama);
          return nama;
        }
      }
    }
    return 'User';
  }

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
                  Text('Selamat Datang', style: AppTheme.karlaBlue),
                  const SizedBox(height: 4),
                  Text(namaLengkap, style: AppTheme.karlaBold),
                ],
              ),              InkWell(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear(); // Clear all saved data including name and userId
                  if (!mounted) return;
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
                      onTap: () async {
                        // Ambil role dan id dari SharedPreferences
                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getInt('userId')?.toString() ?? '';
                        final userRole =
                            prefs.getString('userRole') ??
                            'siswa'; // default siswa
                        if (userId.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      JadwalWidget(role: userRole, id: userId),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('User belum login!')),
                          );
                        }
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
