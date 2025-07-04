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
      home: const NavigationScreen(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: Theme.of(
                context,
              ).colorScheme.surface, // ⬅ Hintergrund für ganzen Canvas
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: child ?? const SizedBox(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
