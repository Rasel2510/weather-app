import 'package:flutter/material.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0D47A1), // dark blue
              Color(0xFF1976D2), // blue
              Color(0xFF4FC3F7), // light blue
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Image.asset(
              'assets/images/cloudy.png',
              height: 170,
              width: 170,
            ),
          ),
        ),
      ),
    );
  }
}
