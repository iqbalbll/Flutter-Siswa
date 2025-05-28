import 'package:flutter/material.dart';
import 'quiz.dart';
import 'QuizStart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizmtkScreen extends StatefulWidget {
  const QuizmtkScreen({Key? key}) : super(key: key);

  @override
  _QuizmtkScreenState createState() => _QuizmtkScreenState();
}

class _QuizmtkScreenState extends State<QuizmtkScreen> {
  List<QuizData> mtkQuizzes = [];
  String subjectName = 'Matematika';
  bool isLoading = true;
  String? error;
  final int subjectId = 4; // ID for Matematika

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final responses = await Future.wait([
        http.get(Uri.parse('http://3.0.151.126/api/admin/mata-pelajarans')),
        http.get(Uri.parse('http://3.0.151.126/api/admin/jadwal-pelajarans')),
        http.get(Uri.parse('http://3.0.151.126/api/admin/quizzes')),
      ]);

      for (var response in responses) {
        if (response.statusCode != 200) {
          throw Exception('Failed to load data: ${response.statusCode}');
        }
      }

      final Map<String, dynamic> subjectsData = json.decode(responses[0].body);
      final Map<String, dynamic> schedulesData = json.decode(responses[1].body);
      final Map<String, dynamic> quizzesData = json.decode(responses[2].body);

      final subject = (subjectsData['data'] as List).firstWhere(
        (subj) => subj['id'] == subjectId,
        orElse: () => {'nama_mapel': subjectName},
      );

      final List<dynamic> subjectSchedules = (schedulesData['data'] as List)
          .where((schedule) => schedule['mapel_id'] == subjectId)
          .toList();

      final List<int> subjectScheduleIds = subjectSchedules
          .map<int>((s) => s['id'] as int)
          .toList();

      final List<QuizData> subjectQuizzes = (quizzesData['data'] as List)
          .where((quiz) => subjectScheduleIds.contains(quiz['jadwal_id']))
          .map<QuizData>((quiz) => QuizData.fromJson(quiz))
          .toList();

      setState(() {
        subjectName = subject['nama_mapel'] ?? subjectName;
        mtkQuizzes = subjectQuizzes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

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
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/icons/out.png',
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          Text(
            'Quiz $subjectName',
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

    final DateTime startTime = DateTime.parse(quiz.waktuMulai);
    final DateTime endTime = DateTime.parse(quiz.waktuSelesai);
    final DateTime now = DateTime.now();
    
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizApp(quizId: quiz.id, quizDuration: quiz.durasi),
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
                      'Quiz Matematika yang harus dikerjakan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.039,
                        fontFamily: 'Karla',
                        fontWeight: FontWeight.w800,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.035),
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
              onPressed: fetchData,
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

    if (mtkQuizzes.isEmpty) {
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
              'Tidak ada quiz Matematika',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Belum ada quiz untuk mata pelajaran Matematika saat ini',
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
      onRefresh: fetchData,
      child: ListView.builder(
        itemCount: mtkQuizzes.length,
        itemBuilder: (context, index) {
          return _buildQuizCard(mtkQuizzes[index], screenWidth, screenHeight);
        },
      ),
    );
  }
}

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