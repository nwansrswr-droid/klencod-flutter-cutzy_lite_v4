import 'dart:math';
import 'package:flutter/material.dart';
import 'avatar_painter.dart';
import 'data.dart';

class DressUpScreen extends StatefulWidget {
  const DressUpScreen({super.key, required this.character});
  final CharacterInfo character;

  @override
  State<DressUpScreen> createState() => _DressUpScreenState();
}

class _DressUpScreenState extends State<DressUpScreen> {
  late final Map<Category, String?> _outfit;
  Category _cat = Category.top;

  @override
  void initState() {
    super.initState();
    _outfit = {for (final c in Category.values) c: widget.character.defaults[c]};
  }

  /// Equipping a dress removes top + bottom, and vice versa.
  void _pick(Category cat, String? id) {
    setState(() {
      _outfit[cat] = id;
      if (id != null && cat == Category.dress) {
        _outfit[Category.top] = null;
        _outfit[Category.bottom] = null;
      }
      if (id != null && (cat == Category.top || cat == Category.bottom)) {
        _outfit[Category.dress] = null;
      }
    });
  }

  void _randomize() {
    final rnd = Random();
    setState(() {
      for (final c in Category.values) {
        final options = wardrobe.where((i) => i.cat == c).toList();
        final skip = c != Category.hair && rnd.nextInt(10) < 2;
        _outfit[c] = skip ? null : options[rnd.nextInt(options.length)].id;
      }
      if (_outfit[Category.dress] != null) {
        _outfit[Category.top] = null;
        _outfit[Category.bottom] = null;
      }
    });
  }

  void _clearAll() {
    setState(() {
      for (final c in Category.values) {
        _outfit[c] = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = wardrobe.where((i) => i.cat == _cat).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFFFE4EE),
      appBar: AppBar(
        title: Text(widget.character.name),
        backgroundColor: const Color(0xFFFF8FB1),
        actions: [
          IconButton(icon: const Icon(Icons.shuffle), tooltip: 'عشوائي', onPressed: _randomize),
          IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'امسحي الكل', onPressed: _clearAll),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomPaint(
                    painter: AvatarPainter(character: widget.character, outfit: _outfit),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 64,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  for (final c in Category.values)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      child: ChoiceChip(
                        avatar: Icon(c.icon, size: 18),
                        label: Text(c.label),
                        selected: _cat == c,
                        onSelected: (_) => setState(() => _cat = c),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                children: [
                  _ItemCard(
                    name: 'بدون',
                    color: Colors.grey.shade300,
                    selected: _outfit[_cat] == null,
                    onTap: () => _pick(_cat, null),
                  ),
                  for (final it in items)
                    _ItemCard(
                      name: it.name,
                      color: it.color,
                      selected: _outfit[_cat] == it.id,
                      onTap: () => _pick(_cat, it.id),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    required this.name,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 116,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFFF4F86) : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
