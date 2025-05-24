import 'package:flutter/material.dart';

import 'package:flutter_app/cine_lines_app.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'CineLines',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CineLinesApp(),
    ),
  );
}
