import 'package:flutter/material.dart';
import 'home.dart';

class JadwalWidget extends StatelessWidget {
  const JadwalWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header container atas
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
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(screenWidth * 0.01, screenWidth * 0.01),
                      blurRadius: screenWidth * 0.08,
                      spreadRadius: -screenWidth * 0.03,
                    ),
                  ],
                ),
                padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.06,
                  screenWidth * 0.06,
                  screenWidth * 0.06,
                  screenWidth * 0.1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon keluar + teks
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          print("Menuju halaman Home...");
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/out.png',
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
                    ),

                    SizedBox(width: screenWidth * 0.05),

                    // Teks Judul Jadwal
                    Flexible(
                      flex: 3,
                      child: Text(
                        'Jadwal',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          color: const Color(0xFF006181),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const Spacer(),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Days Grid Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    _buildDayRow(['Senin', 'Selasa'], screenWidth),
                    const SizedBox(height: 23),
                    _buildDayRow(['Rabu', 'Kamis'], screenWidth),
                    const SizedBox(height: 23),
                    _buildDayRow(["Jum'at", 'Sabtu'], screenWidth),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayRow(List<String> days, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map((day) => Expanded(child: _buildDayCard(day, screenWidth)))
          .toList(),
    );
  }

  Widget _buildDayCard(String day, double screenWidth) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(2, 2),
            blurRadius: 30,
            spreadRadius: -11,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenWidth * 0.03,
        ),
        child: Column(
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: const Color(0xFF006181),
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: screenWidth * 0.2),
          ],
        ),
      ),
    );
  }
}
