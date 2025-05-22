import 'package:flutter/material.dart';
import 'presensi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PresensimtkScreen extends StatefulWidget {
  const PresensimtkScreen({Key? key}) : super(key: key);

  @override
  State<PresensimtkScreen> createState() => _PresensimtkScreenState();
}

class _PresensimtkScreenState extends State<PresensimtkScreen> {
  List<dynamic> presensiList = [];

  @override
  void initState() {
    super.initState();
    fetchPresensi();
  }

  Future<void> fetchPresensi() async {
    final response = await http.get(Uri.parse('http://3.0.151.126/api/admin/absensis'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        presensiList = data['data'];
      });
    } else {
      print("Gagal mengambil data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F9FF),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: EdgeInsets.only(top: screenHeight * 0.03),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.04),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const PresensiScreen()),
                        );
                      },
                      child: Image.asset(
                        'assets/icons/out.png',
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.12),
                Container(
                  width: screenWidth * 0.9,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.07,
                    vertical: screenHeight * 0.03,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 8),
                        blurRadius: 16,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(2, 2),
                              blurRadius: 8,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Matematika',
                                style: TextStyle(
                                  color: const Color(0xFF004D61),
                                  fontSize: screenWidth * 0.06,
                                  fontFamily: 'Karla',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nama guru:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Text(
                                      'Jadwal:',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contoh 1',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Kamis, 20 Maret 2025',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        fontFamily: 'Karla',
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.08,
                                  vertical: screenHeight * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00C2FF),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 4),
                                      blurRadius: 6,
                                      color: Colors.black.withOpacity(0.15),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'Presensi',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontFamily: 'Karla',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.015,
                          horizontal: screenWidth * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(4, 4),
                              blurRadius: 12,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'History Presensi',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontFamily: 'Karla',
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Table(
                              columnWidths: const {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(2),
                              },
                              border: TableBorder.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF71E7FF),
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(screenWidth * 0.03),
                                      child: Text(
                                        'ID',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(screenWidth * 0.03),
                                      child: Text(
                                        'Tanggal',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                ...presensiList.map<TableRow>((item) {
                                  return TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(screenWidth * 0.03),
                                        child: Text(
                                          item['id'].toString(),
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(screenWidth * 0.03),
                                        child: Text(
                                          item['tanggal'],
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
