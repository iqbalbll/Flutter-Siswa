import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/presensi/presensi.dart';
import 'screens/presensi/presensi_mtk.dart';
import 'screens/presensi/presensi_bing.dart';
import 'screens/presensi/presensi_bind.dart';
import 'screens/presensi/presensi_pai.dart';
import 'screens/presensi/presensi_pkn.dart';
import 'screens/presensi/presensi_ipa.dart';
import 'screens/presensi/presensi_ips.dart';
import 'screens/quiz/quiz.dart';
import 'screens/quiz/quizmtk.dart';
import 'screens/quiz/quizbing.dart';
import 'screens/quiz/quizbin.dart';
import 'screens/quiz/quizpai.dart';
import 'screens/quiz/quizpkn.dart';
import 'screens/quiz/quizipa.dart';
import 'screens/quiz/quizips.dart';
import 'screens/quiz/QuizStart.dart';
import 'screens/profil/profil.dart';
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/welcome':
            return MaterialPageRoute(builder: (context) => const WelcomeScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginScreen());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/presensi':
            return MaterialPageRoute(builder: (context) => const PresensiScreen());
          case '/presensi_mtk':
            return MaterialPageRoute(builder: (context) => const PresensimtkScreen());
          case '/presensi_bing':
            return MaterialPageRoute(builder: (context) => const PresensibingScreen());
          case '/presensi_bind':
            return MaterialPageRoute(builder: (context) => const PresensibindScreen());
          case '/presensi_pai':
            return MaterialPageRoute(builder: (context) => const PresensipaiScreen());
          case '/presensi_pkn':
            return MaterialPageRoute(builder: (context) => const PresensipknScreen());
          case '/presensi_ipa':
            return MaterialPageRoute(builder: (context) => const PresensiipaScreen());
          case '/presensi_ips':
            return MaterialPageRoute(builder: (context) => const PresensiipsScreen());
          case '/quiz':
            return MaterialPageRoute(builder: (context) => const QuizScreen());
          case '/quizmtk':
            return MaterialPageRoute(builder: (context) => const QuizmtkScreen());
          case '/quizbing':
            return MaterialPageRoute(builder: (context) => const QuizbingScreen());
          case '/quizbin':
            return MaterialPageRoute(builder: (context) => const QuizbinScreen());
          case '/quizpai':
            return MaterialPageRoute(builder: (context) => const QuizpaiScreen());
          case '/quizpkn':
            return MaterialPageRoute(builder: (context) => const QuizpknScreen());
          case '/quizipa':
            return MaterialPageRoute(builder: (context) => const QuizIpaScreen());
          case '/quizips':
            return MaterialPageRoute(builder: (context) => const QuizipsScreen());
         case '/QuizStart':
          // Extract arguments
          final args = settings.arguments as Map<String, dynamic>?;
          
          // Ensure required parameters exist
          if (args == null || args['quizId'] == null || args['quizDuration'] == null) {
            // Handle missing parameters - you might want to show an error or return to previous screen
            return MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text('Invalid quiz parameters'),
                ),
              ),
            );
          }

          final quizId = args['quizId'] as int;
          final quizDuration = args['quizDuration'] as int;
          
          return MaterialPageRoute(
            builder: (context) => QuizApp(quizId: quizId, quizDuration: quizDuration),
          );
          case '/profil':
            return MaterialPageRoute(builder: (context) => const ProfilePage());
          default:
            return MaterialPageRoute(builder: (context) => const WelcomeScreen());
        }
      },
    );
  }
}