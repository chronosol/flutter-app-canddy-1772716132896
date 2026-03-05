// lib/main.dart — MINIMAL TEMPLATE FOR YOUR VISUAL BUILDER
// This file will be 100% overwritten by your builder — it's just a valid entry point

import 'package:flutter/material.dart';

void main() {
  runApp(const GeneratedApp());
}

// This widget name MUST stay exactly "GeneratedApp"
// Your builder will replace the build() method completely
class GeneratedApp extends StatelessWidget {
  const GeneratedApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Your visual builder will replace everything inside here
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text(
            'Your app is being generated...\nThis screen will be replaced automatically.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}