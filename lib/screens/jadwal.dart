import 'package:flutter/material.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JadwalWidget extends StatefulWidget {
  final String role;
  final String id;
  const JadwalWidget({Key? key, required this.role, required this.id})
    : super(key: key);

  @override
  State<JadwalWidget> createState() => _JadwalWidgetState();
}

class _JadwalWidgetState extends State<JadwalWidget> {
  Map<String, List<dynamic>> jadwalData = {};
  Map<int, String> mataPelajaranCache =
      {}; // Cache untuk menyimpan nama mata pelajaran
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJadwal(role: widget.role, id: int.parse(widget.id));
  }

  // Fungsi untuk mengambil data mata pelajaran berdasarkan ID
  Future<String> fetchMataPelajaran(int mapelId) async {
    // Cek apakah data sudah ada di cache
    if (mataPelajaranCache.containsKey(mapelId)) {
      return mataPelajaranCache[mapelId] ?? '-';
    }

    try {
      final response = await http.get(
        Uri.parse('http://3.0.151.126/api/admin/mata-pelajarans/$mapelId'),
        headers: {'Accept': 'application/json'},
      );

      print('Debug - Mata Pelajaran API Response: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final String namaMapel = decoded['data']['nama_mapel'] ?? '-';
        // Simpan ke cache
        mataPelajaranCache[mapelId] = namaMapel;
        return namaMapel;
      }
    } catch (e) {
      print('Error fetching mata pelajaran: $e');
    }
    return '-';
  }

  Future<void> fetchJadwal({required String role, required int id}) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Base URL untuk jadwal
      String url = 'http://3.0.151.126/api/admin/jadwal-pelajarans';

      // Filter berdasarkan role
      if (role == 'guru') {
        url += '?guru_id=$id';
      } else if (role == 'siswa') {
        url += '?kelas_id=$id';
      }

      print('Debug - Fetching URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> dataList = decoded['data'] ?? [];

        // Mengumpulkan semua mapel_id yang unik
        Set<int> mapelIds = {};
        for (var item in dataList) {
          if (item['mapel_id'] != null) {
            mapelIds.add(int.parse(item['mapel_id'].toString()));
          }
        }

        // Mengambil data mata pelajaran untuk semua mapel_id
        await Future.wait(
          mapelIds.map((mapelId) => fetchMataPelajaran(mapelId)),
        );

        Map<String, List<dynamic>> grouped = {};
        for (var item in dataList) {
          String hari = (item['hari'] ?? '').toString().toLowerCase();
          String formattedHari =
              hari.isNotEmpty
                  ? hari[0].toUpperCase() + hari.substring(1)
                  : 'Unknown';

          if (!grouped.containsKey(formattedHari)) {
            grouped[formattedHari] = [];
          }

          // Tambahkan nama mata pelajaran ke item
          if (item['mapel_id'] != null) {
            int mapelId = int.parse(item['mapel_id'].toString());
            String namaMapel = mataPelajaranCache[mapelId] ?? '-';
            item['nama_mapel'] = namaMapel;
            print('Debug - Added mapel name for ID $mapelId: $namaMapel');
          }

          grouped[formattedHari]!.add(item);
        }

        setState(() {
          jadwalData = grouped;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load jadwal: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching jadwal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth * 0.95,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(screenWidth * 0.08),
                            bottomRight: Radius.circular(screenWidth * 0.08),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(
                                screenWidth * 0.01,
                                screenWidth * 0.01,
                              ),
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
                            Flexible(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => const HomePage(),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/icons/out.png',
                                      width: screenWidth * 0.08,
                                      height: screenWidth * 0.08,
                                    ),
                                    SizedBox(height: screenWidth * 0.01),
                                    Text(
                                      'Keluar',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.05),
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

                      // Grid Hari
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                        ),
                        child: Column(
                          children: [
                            _buildDayRow(['Senin'], screenWidth),
                            const SizedBox(height: 23),
                            _buildDayRow(['Selasa'], screenWidth),
                            const SizedBox(height: 23),
                            _buildDayRow(['Rabu'], screenWidth),
                            const SizedBox(height: 23),
                            _buildDayRow(['Kamis'], screenWidth),
                            const SizedBox(height: 23),
                            _buildDayRow(["Jum'at"], screenWidth),
                            const SizedBox(height: 30),
                            _buildDayRow(['Sabtu'], screenWidth),
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
      children:
          days
              .map((day) => Expanded(child: _buildDayCard(day, screenWidth)))
              .toList(),
    );
  }

  Widget _buildDayCard(String day, double screenWidth) {
    List<Map<String, String>> dayJadwal = _getJadwalByHari(day);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,  
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(screenWidth * 0.08),
          bottomLeft: Radius.circular(screenWidth * 0.08),
        ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                day,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: const Color(0xFF006181),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...dayJadwal.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      // Center text horizontally
                      child: Text(
                        'Mata Pelajaran: ${item['nama_mapel']}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center, // extra assurance
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Jam Mulai: ${item['jam_mulai']}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      'Jam Selesai: ${item['jam_selesai']}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getJadwalByHari(String hari) {
    final List<dynamic> jadwalList = jadwalData[hari] ?? [];

    return jadwalList.map((item) {
      // Ambil nama mapel yang sudah ditambahkan saat fetch data
      String namaMapel = item['nama_mapel']?.toString() ?? '-';

      // Format jam
      final jam_mulai = _formatJam(item['jam_mulai']?.toString() ?? '-');
      final jam_selesai = _formatJam(item['jam_selesai']?.toString() ?? '-');

      return {
        'nama_mapel': namaMapel,
        'jam_mulai': jam_mulai,
        'jam_selesai': jam_selesai,
      };
    }).toList();
  }

  // Helper function untuk format jam
  String _formatJam(String jam) {
    if (jam == '-') return jam;
    try {
      // Mengambil hanya bagian jam:menit dari format waktu
      final parts = jam.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
    } catch (e) {
      print('Debug - Error formatting jam: $e');
    }
    return jam;
  }
}
