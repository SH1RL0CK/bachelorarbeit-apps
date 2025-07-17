import 'package:flutter/material.dart';

import 'package:flutter_app/screens/navigation_screen.dart';

class CineLinesApp extends StatelessWidget {
  const CineLinesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineLines',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const NavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
