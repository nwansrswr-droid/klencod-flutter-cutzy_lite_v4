import 'package:flutter/material.dart';
import 'data.dart';
import 'dressup.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showCredits(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('الاعتمادات'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الرسوم: THE13RUIN'),
            SizedBox(height: 8),
            Text('مرخصة بموجب CC BY-SA 4.0'),
            SizedBox(height: 8),
            Text('https://creativecommons.org/licenses/by-sa/4.0/'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4EE),
      appBar: AppBar(
        title: const Text('Cutzy Lite'),
        backgroundColor: const Color(0xFFFF8FB1),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'الاعتمادات',
            onPressed: () => _showCredits(context),
          ),
        ],
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
