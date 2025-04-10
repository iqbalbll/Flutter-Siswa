import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> labels = ['Home', 'Presensi', 'Quiz', 'Profil'];
    List<String> icons = [
      'assets/icons/home.png',
      'assets/icons/bell.png',
      'assets/icons/idea.png',
      'assets/icons/user.png',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(-5, -5),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(labels.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigasi berdasarkan index
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
                    Navigator.pushReplacementNamed(context, '/profil');
                    break;
                }
                onTap(index); // Memanggil callback untuk memperbarui state
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    icons[index],
                    width: 30,
                    height: 30,
                    color:
                        currentIndex == index
                            ? const Color(0xFF008EBD)
                            : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    labels[index],
                    style: AppTheme.navBarLabel.copyWith(
                      fontSize: 12,
                      color:
                          currentIndex == index
                              ? const Color(0xFF008EBD)
                              : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
