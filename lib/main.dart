import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/presensi/presensi.dart';
import 'screens/presensi/presensi_mtk.dart';
import 'screens/presensi/presensi_bing.dart';
import 'screens/presensi/presensi_bind.dart';
import 'screens/presensi/presensi_pai.dart';
import 'screens/presensi/presensi_pkn.dart';
import 'screens/quiz/quiz.dart';
import 'screens/quiz/quizmtk.dart';
import 'screens/quiz/quizbing.dart';
import 'screens/quiz/quizbin.dart';
import 'screens/quiz/quizpai.dart';
import 'screens/quiz/quizpkn.dart';
import 'screens/profil/profil.dart';
import 'screens/profil/setting.dart';
import 'screens/login.dart';
import 'screens/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomePage(),
        '/presensi': (context) => const PresensiScreen(),
         '/presensi_mtk': (context) => const PresensimtkScreen(),
         '/presensi_bing': (context) => const PresensibingScreen(),
         '/presensi_bind': (context) => const PresensibindScreen(),
         '/presensi_pai': (context) => const PresensipaiScreen(),
         '/presensi_pkn': (context) => const PresensipknScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/quizmtk': (context) => const QuizmtkScreen(),
        '/quizbing': (context) => const QuizbingScreen(),
        '/quizbin': (context) => const QuizbinScreen(),
        '/quizpai': (context) => const QuizpaiScreen(),
        '/quizpkn': (context) => const QuizpknScreen(),
        '/profil': (context) => const ProfilScreen(),
        '/setting': (context) => const ProfilSetting(),
      },
    );
  }
}
