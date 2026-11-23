import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(const CutzyApp());

class CutzyApp extends StatelessWidget {
  const CutzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cutzy Lite',
      theme: ThemeData(colorSchemeSeed: const Color(0xFFFF8FB1), useMaterial3: true),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const HomeScreen(),
    );
  }
}