import 'package:flutter/material.dart';

class ProfilSetting extends StatelessWidget {
  const ProfilSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: Colors.white,
            width: screenWidth,
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Header dengan gradient dan foto profil
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Background gradient
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.38,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF71E7FF), Color(0xFF008EBD)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                    ),

                    // Tombol keluar custom (ikon + teks)
                    Positioned(
                      top: screenHeight * 0.05,
                      left: screenWidth * 0.05,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/profil', 
                          );
                        },

                        child: Column(
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
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Logo di tengah atas
                    Positioned(
                      top: 0,
                      left: (screenWidth / 2) - (screenWidth * 0.09),
                      child: Image.asset(
                        'assets/images/logo-nm.png',
                        width: screenWidth * 0.18,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Foto profil bulat
                    Positioned(
                      bottom: -screenWidth * 0.12,
                      left: (screenWidth / 2) - (screenWidth * 0.12),
                      child: Container(
                        width: screenWidth * 0.24,
                        height: screenWidth * 0.24,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.01),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/icons/profile.png',
                            color: const Color.fromARGB(255, 0, 142, 189),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.15),

                // Form input dan tombol simpan
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(),

                      const SizedBox(height: 20),
                      const Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(),

                      const SizedBox(height: 20),
                      const Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(obscure: true),

                      SizedBox(height: screenHeight * 0.06),

                      Center(
                        child: Container(
                          width: screenWidth * 0.5,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF71E7FF), Color(0xFF008EBD)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // TODO: Tambahkan fungsi simpan
                            },
                            child: const Text(
                              "SIMPAN",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.06),
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

  Widget _buildTextField({bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
