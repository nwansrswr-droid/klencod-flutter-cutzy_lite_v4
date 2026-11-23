import 'package:flutter/material.dart';
import 'data.dart';
import 'dressup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4EE),
      appBar: AppBar(
        title: const Text('Cutzy Lite'),
        backgroundColor: const Color(0xFFFF8FB1),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'اختاري شخصيتك',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          for (final c in kCharacters)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: c.skin, radius: 26),
                title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => DressUpScreen(character: c)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
