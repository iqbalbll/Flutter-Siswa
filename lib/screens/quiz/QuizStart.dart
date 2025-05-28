import 'package:flutter/material.dart';
import 'quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class QuizApp extends StatefulWidget {
  final int quizId;
  final int quizDuration; // Add duration parameter
  const QuizApp({Key? key, required this.quizId, required this.quizDuration}) : super(key: key);

  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  List<SoalQuiz> questions = [];
  List<List<JawabanQuiz>> answerOptions = []; // Store options for each question
  int currentQuestionIndex = 0;
  bool isLoading = true;
  String? error;
  int? selectedOptionIndex;
  int remainingTime = 0; // Will be initialized from quiz duration
  late Timer _timer;
  int totalScore = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    // Calculate time per question or use total duration
    final timePerQuestion = widget.quizDuration * 60 ~/ (questions.length > 0 ? questions.length : 1);
    remainingTime = timePerQuestion;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        timer.cancel();
        _goToNextQuestion();
      }
    });
  }

  Future<void> fetchQuestions() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Fetch questions
      final questionsResponse = await http.get(
        Uri.parse('http://3.0.151.126/api/admin/soal-quizzes?quiz_id=${widget.quizId}'),
      );

      if (questionsResponse.statusCode == 200) {
        final data = json.decode(questionsResponse.body);
        final List<dynamic> questionList = data['data'];
        
        // Fetch answers for each question
        List<SoalQuiz> loadedQuestions = [];
        List<List<JawabanQuiz>> loadedAnswers = [];
        
        for (var q in questionList) {
          final question = SoalQuiz.fromJson(q);
          loadedQuestions.add(question);
          
          // Fetch options for this question
          final answersResponse = await http.get(
            Uri.parse('http://3.0.151.126/api/admin/jawaban-quizzes?soal_id=${question.id}'),
          );
          
          if (answersResponse.statusCode == 200) {
            final answersData = json.decode(answersResponse.body);
            final List<dynamic> answerList = answersData['data'];
            loadedAnswers.add(answerList.map((a) => JawabanQuiz.fromJson(a)).toList());
          } else {
            loadedAnswers.add([]); // Empty if no answers
          }
        }

        setState(() {
          questions = loadedQuestions;
          answerOptions = loadedAnswers;
          isLoading = false;
          if (questions.isNotEmpty) {
            _startTimer();
          }
        });
      } else {
        throw Exception('Failed to load questions: ${questionsResponse.statusCode}');
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _goToNextQuestion() {
    // Calculate score if answer was selected
    if (selectedOptionIndex != null && 
        currentQuestionIndex < answerOptions.length &&
        selectedOptionIndex! < answerOptions[currentQuestionIndex].length) {
      final selectedAnswer = answerOptions[currentQuestionIndex][selectedOptionIndex!];
      if (selectedAnswer.isCorrect) {
        totalScore += questions[currentQuestionIndex].bobotNilai;
      }
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
        _timer.cancel();
        _startTimer();
      });
    } else {
      _timer.cancel();
      // Show results screen instead of going back
      _showResults();
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quiz Selesai'),
        content: Text('Skor Anda: $totalScore dari ${questions.fold(0, (sum, q) => sum + q.bobotNilai)}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Go back to quiz list
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _selectOption(int index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF6EC6F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _timer.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const QuizScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Matematika', // You might want to pass this as a parameter
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Quiz: ${currentQuestionIndex + 1}/${questions.length}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
              child: _buildQuestionContent(screenWidth, screenHeight),
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildNextButton(),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionContent(double screenWidth, double screenHeight) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: screenWidth * 0.15,
              color: Colors.white,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Gagal memuat soal',
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
              onPressed: fetchQuestions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_outlined,
              size: screenWidth * 0.15,
              color: Colors.white,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Tidak ada soal tersedia',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Belum ada soal untuk quiz ini',
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

    final currentQuestion = questions[currentQuestionIndex];
    final currentOptions = currentQuestionIndex < answerOptions.length 
        ? answerOptions[currentQuestionIndex] 
        : <JawabanQuiz>[];

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: screenHeight * 0.04),
          padding: EdgeInsets.all(screenWidth * 0.05),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Pertanyaan ${currentQuestionIndex + 1}',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                currentQuestion.pertanyaan,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              if (currentQuestion.gambarSoal != null)
                Image.network(
                  'http://3.0.151.126/storage/${currentQuestion.gambarSoal}',
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.2,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, error, stackTrace) => 
                      const Icon(Icons.broken_image, size: 100),
                ),
              SizedBox(height: screenHeight * 0.03),
              Expanded(
                child: ListView.builder(
                  itemCount: currentOptions.length,
                  itemBuilder: (context, index) {
                    return OptionTile(
                      option: String.fromCharCode(65 + index),
                      text: currentOptions[index].jawaban,
                      isSelected: selectedOptionIndex == index,
                      onTap: () => _selectOption(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: screenWidth * 0.05,
          top: 0,
          child: CircleAvatar(
            radius: screenWidth * 0.07,
            backgroundColor: Colors.white,
            child: Text(
              remainingTime.toString(),
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: selectedOptionIndex != null ? _goToNextQuestion : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: const StadiumBorder(),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.height * 0.02,
          ),
        ),
        child: Text(
          currentQuestionIndex < questions.length - 1 ? 'Lanjut' : 'Selesai',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.04,
          ),
        ),
      ),
    );
  }
}

class SoalQuiz {
  final int id;
  final int quizId;
  final String pertanyaan;
  final String jenisSoal;
  final String? gambarSoal;
  final int bobotNilai;

  SoalQuiz({
    required this.id,
    required this.quizId,
    required this.pertanyaan,
    required this.jenisSoal,
    this.gambarSoal,
    required this.bobotNilai,
  });

  factory SoalQuiz.fromJson(Map<String, dynamic> json) {
    return SoalQuiz(
      id: json['id'],
      quizId: json['quiz_id'],
      pertanyaan: json['pertanyaan'],
      jenisSoal: json['jenis_soal'],
      gambarSoal: json['gambar_soal'],
      bobotNilai: json['bobot_nilai'],
    );
  }
}

class JawabanQuiz {
  final int id;
  final int soalId;
  final String jawaban;
  final bool isCorrect;

  JawabanQuiz({
    required this.id,
    required this.soalId,
    required this.jawaban,
    required this.isCorrect,
  });

  factory JawabanQuiz.fromJson(Map<String, dynamic> json) {
    return JawabanQuiz(
      id: json['id'],
      soalId: json['soal_id'],
      jawaban: json['jawaban'],
      isCorrect: json['is_correct'] == 1,
    );
  }
}

class OptionTile extends StatelessWidget {
  final String option;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    Key? key,
    required this.option,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6EC6F3).withOpacity(0.2) : const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.circular(15),
          border: isSelected
              ? Border.all(color: const Color(0xFF6EC6F3), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              offset: const Offset(2, 3),
              blurRadius: 5,
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isSelected ? const Color(0xFF6EC6F3) : Colors.grey[300],
            child: Text(
              option,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
          title: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFF006181) : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}