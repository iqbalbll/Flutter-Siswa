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
  Map<int, String> mataPelajaranCache = {};
  bool isLoading = true;
  String? errorMessage;
  int? kelasId;

  @override
  void initState() {
    super.initState();
    print('Debug - Initializing JadwalWidget with role: ${widget.role}, id: ${widget.id}');
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Jika role siswa, kita perlu mendapatkan kelas_id dari relasi
      if (widget.role == 'siswa') {
        await _fetchKelasIdFromSiswa();
      }
      await _fetchJadwal();
    } catch (e) {
      print('Error in _initializeData: $e');
      setState(() {
        errorMessage = 'Terjadi kesalahan saat memuat jadwal. Silakan coba lagi.';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchKelasIdFromSiswa() async {
    try {
      print('Debug - Fetching kelas ID for siswa with pengguna_id: ${widget.id}');
      
      // Step 1: Get all siswa to find the one with matching pengguna_id
      final siswaResponse = await http.get(
        Uri.parse('http://3.0.151.126/api/admin/siswas'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (siswaResponse.statusCode == 200) {
        final siswaData = json.decode(siswaResponse.body);
        print('Debug - Siswa response: ${siswaResponse.body}');

        // Find siswa with matching pengguna_id
        final List<dynamic> siswaList = siswaData['data'];
        final siswa = siswaList.firstWhere(
          (s) => s['pengguna_id'].toString() == widget.id,
          orElse: () => null,
        );

        if (siswa != null) {
          print('Debug - Found siswa: ${siswa['nama_lengkap']}');
          final kId = siswa['id_kelas'];
          if (kId != null) {
            setState(() {
              kelasId = kId;
            });
            print('Debug - Set kelas_id to: $kelasId');
          } else {
            throw 'Kelas tidak ditemukan untuk siswa';
          }
        } else {
          throw 'Data siswa tidak ditemukan';
        }
      } else {
        throw 'Gagal mengambil data siswa. Status: ${siswaResponse.statusCode}';
      }
    } catch (e) {
      print('Error fetching kelas ID: $e');
      throw 'Gagal mendapatkan data kelas: $e';
    }
  }

  Future<void> _fetchJadwal() async {
    try {
      // Build URL based on role
      String url;
      if (widget.role == 'guru') {
        url = 'http://3.0.151.126/api/admin/jadwal-pelajarans?guru_id=${widget.id}';
        print('Debug - Fetching jadwal for guru_id: ${widget.id}');
      } else {
        if (kelasId == null) {
          throw 'Kelas ID tidak tersedia';
        }
        url = 'http://3.0.151.126/api/admin/jadwal-pelajarans?kelas_id=$kelasId';
        print('Debug - Fetching jadwal for kelas_id: $kelasId');
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> dataList = decoded['data'] ?? [];
        print('Debug - Jadwal response: ${response.body}');
        
        // Untuk siswa, filter jadwal berdasarkan kelas_id
        if (widget.role == 'siswa') {
          dataList = dataList.where((item) {
            final itemKelasId = item['kelas_id']?.toString();
            return itemKelasId != null && itemKelasId == kelasId.toString();
          }).toList();
        }
        
        print('Debug - Found ${dataList.length} jadwal entries');

        // Get unique mapel_ids
        Set<int> mapelIds = {};
        for (var item in dataList) {
          if (item['mapel_id'] != null) {
            mapelIds.add(int.parse(item['mapel_id'].toString()));
          }
        }

        // Fetch mata pelajaran names
        for (var mapelId in mapelIds) {
          await _fetchMataPelajaran(mapelId);
        }

        // Group by day
        Map<String, List<dynamic>> grouped = {};
        for (var item in dataList) {
          String hari = (item['hari'] ?? '').toString().toLowerCase();
          String formattedHari = hari.isNotEmpty
              ? hari[0].toUpperCase() + hari.substring(1)
              : 'Unknown';

          if (!grouped.containsKey(formattedHari)) {
            grouped[formattedHari] = [];
          }

          if (item['mapel_id'] != null) {
            int mapelId = int.parse(item['mapel_id'].toString());
            item['nama_mapel'] = mataPelajaranCache[mapelId] ?? '-';
          }

          grouped[formattedHari]!.add(item);
        }

        setState(() {
          jadwalData = grouped;
          isLoading = false;
          errorMessage = null;
        });
      } else {
        throw 'Gagal mengambil jadwal: ${response.statusCode}';
      }
    } catch (e) {
      print('Error in _fetchJadwal: $e');
      setState(() {
        errorMessage = 'Gagal memuat jadwal: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchMataPelajaran(int mapelId) async {
    if (mataPelajaranCache.containsKey(mapelId)) return;

    try {
      final response = await http.get(
        Uri.parse('http://3.0.151.126/api/admin/mata-pelajarans/$mapelId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final String namaMapel = decoded['data']['nama_mapel'] ?? '-';
        mataPelajaranCache[mapelId] = namaMapel;
        print('Debug - Cached mapel name for ID $mapelId: $namaMapel');
      }
    } catch (e) {
      print('Error fetching mata pelajaran $mapelId: $e');
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
