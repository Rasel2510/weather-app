import 'package:flutter/material.dart';
import 'package:weather_r/features/weather/presentation/home_screen.dart';
import 'package:weather_r/spalsh_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    loadingData();
    super.initState();
  }

  loadingData() async {
    await Future.delayed(Duration(seconds: 1));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpalshScreen();
  }
}
