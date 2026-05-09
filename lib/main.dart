import 'screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'ui/colors.dart';
import 'ui/duo_button.dart';

void main() {
  runApp(const LearnStudentsApp());
}

class LearnStudentsApp extends StatelessWidget {
  const LearnStudentsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learn Students',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto', // Flutter la trae por defecto
      ),
      home: const SplashScreen() ,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Aquí irá tu personaje de Blender pronto
              const Icon(
                Icons.school_rounded, 
                size: 100, 
                color: AppColors.primaryPurple
              ),
              const SizedBox(height: 40),
              const Text(
                "¡Bienvenido a\nLearn Students!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "¿Qué vamos a aprender hoy?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),
              DuoButton(
                text: "EMPEZAR AHORA",
                onPressed: () {
                  print("¡Botón presionado!");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}