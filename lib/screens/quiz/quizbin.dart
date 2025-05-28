import 'package:flutter/material.dart';
import 'quiz.dart';
import 'QuizStart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizbinScreen extends StatefulWidget {
  const QuizbinScreen({Key? key}) : super(key: key);

  @override
  _QuizbinScreenState createState() => _QuizbinScreenState();
}

class _QuizbinScreenState extends State<QuizbinScreen> {
  List<dynamic> quizzes = [];
  String subjectName = 'Bahasa Indonesia';
  bool isLoading = true;
  bool isLoadingSubject = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchSubjectName();
    fetchQuizzes();
  }

  Future<void> fetchSubjectName() async {
    try {
      final response = await http.get(
          Uri.parse('http://3.0.151.126/api/admin/mata-pelajarans'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final subjects = data['data'] as List;
        
        final bahasaIndonesiaSubject = subjects.firstWhere(
          (subject) => subject['id'] == 7,
          orElse: () => {'nama_mapel': 'Bahasa Indonesia'},
        );
        
        setState(() {
          subjectName = bahasaIndonesiaSubject['nama_mapel'];
          isLoadingSubject = false;
        });
      } else {
        setState(() {
          isLoadingSubject = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingSubject = false;
      });
      debugPrint('Error fetching subject name: $e');
    }
  }

  Future<void> fetchQuizzes() async {
    try {
      final response = await http.get(
          Uri.parse('http://3.0.151.126/api/admin/quizzes'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          quizzes = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load quizzes. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching quizzes: ${e.toString()}';
      });
    }
  }

  Widget _buildHeader(BuildContext context, double screenWidth) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.06,
        vertical: 20,
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

  Widget _buildQuizCard(dynamic quiz, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.85,
      margin: const EdgeInsets.only(bottom: 20),
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
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz['judul_quiz'] ?? 'Quiz $subjectName',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontFamily: 'Karla',
                color: const Color(0xFF006181),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizApp(quizId: quiz.id, quizDuration: quiz.durasi),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading || isLoadingSubject) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            errorMessage,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.quiz_outlined,
              size: 60,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            Text(
              'Tidak ada quiz yang tersedia',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        return _buildQuizCard(quizzes[index], context);
      },
    );
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
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, screenWidth),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Quiz yang harus dikerjakan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.039,
                    fontFamily: 'Karla',
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchQuizzes,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          if (!isLoading && !isLoadingSubject && errorMessage.isEmpty)
                            ...quizzes.map((quiz) => _buildQuizCard(quiz, context)).toList(),
                        ],
                      ),
                    ),
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