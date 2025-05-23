import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? userId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }
  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');
    print('Loaded userId from SharedPreferences: $id');
    setState(() {
      userId = id;
    });
  }  Future<String?> fetchProfilePhotoUrl() async {
    if (userId == null) {
      print('UserId is null, cannot fetch profile photo');
      return null;
    }

    try {
      print('Fetching profile photo for userId: $userId');
      final response = await http.get(
        Uri.parse('http://3.0.151.126/api/admin/penggunas/$userId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        // Pastikan kita mengakses data dengan benar sesuai struktur response
        final Map<String, dynamic>? userData = data['data'];
        if (userData == null) {
          print('No user data found in response');
          return null;
        }

        final profilePic = userData['profile_picture'];
        print('Profile picture value from API: $profilePic');
        
        if (profilePic != null && profilePic.toString().isNotEmpty) {
          // Membuat URL lengkap untuk foto profil
          String photoUrl;
          if (profilePic.toString().startsWith('http')) {
            photoUrl = profilePic.toString();
          } else {
            // Menghapus slash di awal jika ada untuk menghindari double slash
            final cleanPath = profilePic.toString().startsWith('/') 
                ? profilePic.toString().substring(1) 
                : profilePic.toString();
            photoUrl = 'http://3.0.151.126/storage/$cleanPath';
          }
          
          print('Full photo URL generated: $photoUrl');
          return photoUrl;
        } else {
          print('No profile picture found for user');
          return null;
        }
      } else {
        print('Failed to fetch profile. Status: ${response.statusCode}');
        return null;
      }
    } catch (e, stackTrace) {
      print('Error fetching profile photo: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchNamaDanNis() async {
    if (userId == null) return null;
    final response = await http.get(
      Uri.parse('http://3.0.151.126/api/admin/siswas'),
    );
    print('userId: $userId');
    print('API response: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] is List) {
        // Cari guru dengan pengguna_id yang sesuai userId login
        final siswa = data['data'].firstWhere(
          (item) => item['pengguna_id'] == userId,
          orElse: () => null,
        );
        if (siswa != null) {
          return {
            'nama_lengkap': siswa['nama_lengkap'],
            'nis': siswa['nis'],
          };
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Container
              Container(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.95),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(screenWidth * 0.08),
                    bottomRight: Radius.circular(screenWidth * 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(screenWidth * 0.01, screenWidth * 0.01),
                      blurRadius: screenWidth * 0.08,
                      spreadRadius: -screenWidth * 0.03,
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.06,
                  screenWidth * 0.1,
                  screenWidth * 0.06,
                  screenWidth * 0.06,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Tombol Back
                    Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                        color: const Color(0xFF006181),
                      ),
                    ),
                    // Judul tengah
                    Flexible(
                      flex: 3,
                      child: Center(
                        child: Text(
                          'Profile Page',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    // Spacer kanan supaya title tetap di tengah
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Konten utama hanya foto profil
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [                      FutureBuilder<String?>(
                        future: fetchProfilePhotoUrl(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          
                          if (snapshot.hasError) {
                            print('Error in FutureBuilder: ${snapshot.error}');
                            return Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              child: const Icon(
                                Icons.error_outline,
                                size: 100,
                                color: Colors.red,
                              ),
                            );
                          }
                          
                          return Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                              image: snapshot.data != null
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        snapshot.data!,
                                        headers: {
                                          'Cache-Control': 'no-cache',
                                          'Accept': 'image/*',
                                        },
                                      ),
                                      fit: BoxFit.cover,
                                      onError: (error, stackTrace) {
                                        print('Error loading image: $error');
                                        print('Image URL that failed: ${snapshot.data}');
                                        print('Stack trace: $stackTrace');
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: snapshot.data == null
                                ? const Icon(
                                    Icons.person,
                                    size: 100,
                                    color: Colors.white,
                                  )
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      FutureBuilder<Map<String, dynamic>?>(
                        future: fetchNamaDanNis(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                            return const Text('Nama dan NIP tidak tersedia');
                          }
                          final namaLengkap = snapshot.data!['nama_lengkap'] ?? '-';
                          final nis = snapshot.data!['nis'] ?? '-';
                          return Column(
                            children: [
                              Text(
                                namaLengkap,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'NIS: $nis',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
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
    );
  }
}
