import 'package:flutter/material.dart';

enum Category { hair, top, bottom, dress, shoes, accessory }

extension CategoryInfo on Category {
  String get label {
    switch (this) {
      case Category.hair:
        return 'تسريحات';
      case Category.top:
        return 'بلايز';
      case Category.bottom:
        return 'بناطيل';
      case Category.dress:
        return 'فساتين';
      case Category.shoes:
        return 'أحذية';
      case Category.accessory:
        return 'إكسسوارات';
    }
  }

  IconData get icon {
    switch (this) {
      case Category.hair:
        return Icons.face;
      case Category.top:
        return Icons.checkroom;
      case Category.bottom:
        return Icons.straighten;
      case Category.dress:
        return Icons.woman;
      case Category.shoes:
        return Icons.hiking;
      case Category.accessory:
        return Icons.diamond;
    }
  }
}

/// One wardrobe piece. [style] picks the drawing shape, [color] its colour.
class Item {
  const Item(this.id, this.name, this.cat, this.style, this.color);
  final String id;
  final String name;
  final Category cat;
  final int style;
  final Color color;
}

const List<Item> wardrobe = [
  // Hair (style 0-4)
  Item('h1', 'بوب', Category.hair, 0, Color(0xFF3E2723)),
  Item('h2', 'شعر طويل', Category.hair, 1, Color(0xFF6B4226)),
  Item('h3', 'ذيل حصان', Category.hair, 2, Color(0xFFE64A9B)),
  Item('h4', 'كحكة', Category.hair, 3, Color(0xFF7E57C2)),
  Item('h5', 'كيرلي', Category.hair, 4, Color(0xFFD4A24C)),
  // Tops
  Item('t1', 'تيشيرت أحمر', Category.top, 0, Color(0xFFE53935)),
  Item('t2', 'هودي أصفر', Category.top, 1, Color(0xFFFFD54F)),
  Item('t3', 'بلوزة بوو', Category.top, 2, Color(0xFFF8BBD0)),
  Item('t4', 'سويتر مخطط', Category.top, 3, Color(0xFF42A5F5)),
  Item('t5', 'تانك تركواز', Category.top, 4, Color(0xFF26C6DA)),
  // Bottoms
  Item('b1', 'شورت', Category.bottom, 0, Color(0xFF283593)),
  Item('b2', 'بنطلون أسود', Category.bottom, 1, Color(0xFF212121)),
  Item('b3', 'تنورة بيج', Category.bottom, 2, Color(0xFFD7CCC8)),
  Item('b4', 'جينز', Category.bottom, 3, Color(0xFF1E88E5)),
  Item('b5', 'تنورة مكشكشة', Category.bottom, 4, Color(0xFF8E24AA)),
  // Dresses
  Item('d1', 'فستان صيفي', Category.dress, 0, Color(0xFF81D4FA)),
  Item('d2', 'فستان منفوش', Category.dress, 1, Color(0xFFFFB3C6)),
  Item('d3', 'فستان بحمالات', Category.dress, 2, Color(0xFFCE93D8)),
  Item('d4', 'فستان طويل', Category.dress, 3, Color(0xFFFFCC80)),
  Item('d5', 'فستان بحري', Category.dress, 4, Color(0xFF1A237E)),
  // Shoes
  Item('s1', 'سنيكرز', Category.shoes, 0, Color(0xFFFFFFFF)),
  Item('s2', 'بوت', Category.shoes, 1, Color(0xFF8D6E63)),
  Item('s3', 'كعب', Category.shoes, 2, Color(0xFFFF80AB)),
  Item('s4', 'صندل', Category.shoes, 3, Color(0xFFD7A86E)),
  Item('s5', 'لوفر أسود', Category.shoes, 4, Color(0xFF263238)),
  // Accessories
  Item('a1', 'فيونكة', Category.accessory, 0, Color(0xFFFF4081)),
  Item('a2', 'عقد', Category.accessory, 1, Color(0xFFFFD700)),
  Item('a3', 'نظارة', Category.accessory, 2, Color(0xFF37474F)),
  Item('a4', 'قبعة', Category.accessory, 3, Color(0xFF5D4037)),
  Item('a5', 'حلق', Category.accessory, 4, Color(0xFFB0BEC5)),
];

Item? itemById(String? id) {
  if (id == null) return null;
  for (final i in wardrobe) {
    if (i.id == id) return i;
  }
  return null;
}

class CharacterInfo {
  const CharacterInfo(this.name, this.skin, this.hair, this.defaults);
  final String name;
  final Color skin;
  final Color hair; // used when no hair piece is equipped
  final Map<Category, String> defaults;
}

const List<CharacterInfo> kCharacters = [
  CharacterInfo('لينا', Color(0xFFF8D9BF), Color(0xFF6B4226), {
    Category.hair: 'h2',
    Category.top: 't1',
    Category.bottom: 'b1',
    Category.shoes: 's1',
  }),
  CharacterInfo('سارة', Color(0xFFE0AC7E), Color(0xFF1F1F1F), {
    Category.hair: 'h1',
    Category.top: 't3',
    Category.bottom: 'b3',
    Category.shoes: 's3',
  }),
  CharacterInfo('مايا', Color(0xFF8D5524), Color(0xFFE64A9B), {
    Category.hair: 'h3',
    Category.top: 't5',
    Category.bottom: 'b4',
    Category.shoes: 's5',
  }),
];
