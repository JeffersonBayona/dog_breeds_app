import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Contenido centrado
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pets, size: 100, color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  'Dog Breeds App',
                  style: GoogleFonts.lato(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Versión en la parte inferior
          Positioned(
            bottom: 20, // Ajusta la distancia desde la parte inferior
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Versión 1.0.0',
                style: GoogleFonts.lato(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
