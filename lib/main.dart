import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Lista de Tareas',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF010409),
          foregroundColor: Color(0xFFE6EDF3),
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF161B22),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Color(0xFF21262D)),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF388BFD),
          onPrimary: Color(0xFFE6EDF3),
          surface: Color(0xFF161B22),
          onSurface: Color(0xFFE6EDF3),
        ),
        textTheme: GoogleFonts.interTextTheme(textTheme).apply(
          bodyColor: const Color(0xFFE6EDF3),
          displayColor: const Color(0xFFE6EDF3),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF388BFD),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF010409),
          selectedItemColor: const Color(0xFF388BFD), // Primary blue
          unselectedItemColor: const Color(0xFF8B949E), // Lighter grey for contrast
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: Color(0xFF388BFD),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(const Color(0xFF388BFD)),
          checkColor: MaterialStateProperty.all(const Color(0xFFE6EDF3)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}