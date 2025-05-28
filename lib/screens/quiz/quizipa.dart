import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'quiz.dart';

class QuizIpaScreen extends StatefulWidget {
  const QuizIpaScreen({Key? key}) : super(key: key);

  @override
  State<QuizIpaScreen> createState() => _QuizIpaScreenState();
}

class _QuizIpaScreenState extends State<QuizIpaScreen> {
  List<QuizData> ipaQuizzes = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchIpaQuizzes();
  }

  Future<void> fetchIpaQuizzes() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Fetch quizzes, schedules, and subjects data
      final quizzesResponse = await http.get(
        Uri.parse('http://3.0.151.126/api/admin/quizzes'),
      );
      
      final schedulesResponse = await http.get(
        Uri.parse('http://3.0.151.126/api/admin/jadwal-pelajarans'),
      );
      
      final subjectsResponse = await http.get(
        Uri.parse('http://3.0.151.126/api/admin/mata-pelajarans'),
      );

      if (quizzesResponse.statusCode == 200 && 
          schedulesResponse.statusCode == 200 && 
          subjectsResponse.statusCode == 200) {
        
        final quizzesData = json.decode(quizzesResponse.body);
        final schedulesData = json.decode(schedulesResponse.body);
        final subjectsData = json.decode(subjectsResponse.body);

        // Find IPA subject ID (mapel_id = 9 based on the data)
        dynamic ipaSubject;
        try {
          ipaSubject = (subjectsData['data'] as List).firstWhere(
            (subject) => subject['nama_mapel'] == 'IPA',
          );
        } catch (e) {
          throw Exception('Mata pelajaran IPA tidak ditemukan');
        }

        final ipaSubjectId = ipaSubject['id'];

        // Filter schedules for IPA subject
        final ipaSchedules = (schedulesData['data'] as List)
            .where((schedule) => schedule['mapel_id'] == ipaSubjectId)
            .toList();

        // Get schedule IDs for IPA
        final ipaScheduleIds = ipaSchedules.map((schedule) => schedule['id']).toSet();

        // Filter quizzes that belong to IPA schedules
        final filteredQuizzes = (quizzesData['data'] as List)
            .where((quiz) => ipaScheduleIds.contains(quiz['jadwal_id']))
            .map<QuizData>((quiz) => QuizData.fromJson(quiz))
            .toList();

        setState(() {
          ipaQuizzes = filteredQuizzes;
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data dari server');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

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
            'Quiz Ilmu Pengetahuan Alam',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF006181),
            ),
          ),
          const Spacer(),
          SizedBox(width: screenWidth * 0.08),
        ],
      ),
    );
  }

  Widget _buildQuizCard(QuizData quiz, double screenWidth, double screenHeight) {
    final double minHeight = screenHeight * 0.11;
    final double maxWidth = screenWidth * 0.85;

    // Parse waktu mulai dan selesai
    final DateTime startTime = DateTime.parse(quiz.waktuMulai);
    final DateTime endTime = DateTime.parse(quiz.waktuSelesai);
    final DateTime now = DateTime.now();
    
    // Tentukan status quiz
    String status;
    Color statusColor;
    bool canStart = false;

    if (now.isBefore(startTime)) {
      status = 'Belum Dimulai';
      statusColor = Colors.orange;
    } else if (now.isAfter(endTime)) {
      status = 'Selesai';
      statusColor = Colors.red;
    } else {
      status = 'Aktif';
      statusColor = Colors.green;
      canStart = true;
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minHeight: minHeight,
      ),
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    quiz.judulQuiz,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontFamily: 'Karla',
                      color: const Color(0xFF006181),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            if (quiz.deskripsi != null && quiz.deskripsi!.isNotEmpty) ...[
              SizedBox(height: screenHeight * 0.01),
              Text(
                quiz.deskripsi!,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.grey[600],
                  fontFamily: 'Karla',
                ),
              ),
            ],
            
            SizedBox(height: screenHeight * 0.01),
            
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'Durasi: ${quiz.durasi} menit',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                    fontFamily: 'Karla',
                  ),
                ),
              ],
            ),
            
            SizedBox(height: screenHeight * 0.005),
            
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Text(
                    'Mulai: ${_formatDateTime(startTime)} - Selesai: ${_formatDateTime(endTime)}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: Colors.grey[600],
                      fontFamily: 'Karla',
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: screenHeight * 0.015),
            
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: canStart ? () {
                  // Navigate to quiz detail atau quiz taking screen
                  // Navigator.push(...);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Memulai quiz: ${quiz.judulQuiz}'),
                      backgroundColor: const Color(0xFF006181),
                    ),
                  );
                } : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: canStart ? const Color(0xFF71E7FF) : Colors.grey[300],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    canStart ? 'Mulai' : 'Tidak Tersedia',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontFamily: 'Karla',
                      color: canStart ? const Color(0xFF006181) : Colors.grey[600],
                      fontWeight: FontWeight.w800,
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Quiz IPA yang harus dikerjakan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.039,
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w800,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.035),

                    // Content area
                    Expanded(
                      child: _buildContent(screenWidth, screenHeight),
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

  Widget _buildContent(double screenWidth, double screenHeight) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: screenWidth * 0.2,
              color: Colors.white,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Terjadi kesalahan',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(
              onPressed: fetchIpaQuizzes,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF006181),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (ipaQuizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: screenWidth * 0.2,
              color: Colors.white,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Tidak ada quiz IPA',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Belum ada quiz untuk mata pelajaran IPA saat ini',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: fetchIpaQuizzes,
      child: ListView.builder(
        itemCount: ipaQuizzes.length,
        itemBuilder: (context, index) {
          return _buildQuizCard(ipaQuizzes[index], screenWidth, screenHeight);
        },
      ),
    );
  }
}

// Model class untuk Quiz data
class QuizData {
  final int id;
  final int jadwalId;
  final String judulQuiz;
  final String? deskripsi;
  final String waktuMulai;
  final String waktuSelesai;
  final int durasi;
  final String status;

  QuizData({
    required this.id,
    required this.jadwalId,
    required this.judulQuiz,
    this.deskripsi,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.durasi,
    required this.status,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      id: json['id'],
      jadwalId: json['jadwal_id'],
      judulQuiz: json['judul_quiz'],
      deskripsi: json['deskripsi'],
      waktuMulai: json['waktu_mulai'],
      waktuSelesai: json['waktu_selesai'],
      durasi: json['durasi'],
      status: json['status'],
    );
  }
}