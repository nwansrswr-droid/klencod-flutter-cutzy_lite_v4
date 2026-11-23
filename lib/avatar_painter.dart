import 'package:flutter/material.dart';
import 'data.dart';

/// Artwork is authored on a 1080x1920 design canvas and scaled to fit
/// any screen (phones, tablets, 1080p and up) without losing alignment.
const double kDesignW = 1080;
const double kDesignH = 1920;

RRect _rr(double l, double t, double r, double b, double rad) =>
    RRect.fromRectAndRadius(Rect.fromLTRB(l, t, r, b), Radius.circular(rad));

Path _poly(List<Offset> pts) {
  final path = Path()..moveTo(pts.first.dx, pts.first.dy);
  for (final o in pts.skip(1)) {
    path.lineTo(o.dx, o.dy);
  }
  return path..close();
}

class AvatarPainter extends CustomPainter {
  AvatarPainter({required this.character, required this.outfit});

  final CharacterInfo character;
  final Map<Category, String?> outfit;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / kDesignW < size.height / kDesignH
        ? size.width / kDesignW
        : size.height / kDesignH;
    canvas.translate((size.width - kDesignW * scale) / 2, (size.height - kDesignH * scale) / 2);
    canvas.scale(scale);

    final hair = itemById(outfit[Category.hair]);
    final top = itemById(outfit[Category.top]);
    final bottom = itemById(outfit[Category.bottom]);
    final dress = itemById(outfit[Category.dress]);
    final shoes = itemById(outfit[Category.shoes]);
    final acc = itemById(outfit[Category.accessory]);
    final skin = Paint()..color = character.skin;

    // 1. Hair behind the head
    if (hair != null) {
      _hairBack(canvas, hair.style, hair.color);
    } else {
      _hairBack(canvas, 0, character.hair);
    }

    // 2. Skin: legs, neck, arms, torso
    canvas.drawRRect(_rr(425, 1100, 535, 1640, 30), skin);
    canvas.drawRRect(_rr(545, 1100, 655, 1640, 30), skin);
    canvas.drawRRect(_rr(490, 700, 590, 780, 20), skin);
    canvas.drawRRect(_rr(320, 780, 392, 1090, 36), skin);
    canvas.drawRRect(_rr(688, 780, 760, 1090, 36), skin);
    canvas.drawRRect(_rr(400, 740, 680, 1140, 70), skin);

    // 3. Clothes: a dress replaces top + bottom
    if (dress != null) {
      _dress(canvas, dress);
    } else {
      if (top != null) _top(canvas, top);
      if (bottom != null) _bottom(canvas, bottom);
    }

    // 4. Head and face
    canvas.drawCircle(const Offset(540, 560), 200, skin);
    _face(canvas);

    // 5. Front hair (fringe / cap)
    if (hair != null) {
      _hairFront(canvas, hair.style, hair.color);
    } else {
      _hairFront(canvas, 0, character.hair);
    }

    // 6. Shoes, then accessories on top
    if (shoes != null) _shoes(canvas, shoes);
    if (acc != null) _accessory(canvas, acc);
  }

  void _face(Canvas c) {
    final eye = Paint()..color = const Color(0xFF3B2A22);
    c.drawOval(Rect.fromCenter(center: const Offset(470, 590), width: 42, height: 54), eye);
    c.drawOval(Rect.fromCenter(center: const Offset(610, 590), width: 42, height: 54), eye);
    final shine = Paint()..color = Colors.white;
    c.drawCircle(const Offset(482, 576), 8, shine);
    c.drawCircle(const Offset(622, 576), 8, shine);
    final cheek = Paint()..color = const Color(0x55FF6F91);
    c.drawCircle(const Offset(420, 660), 32, cheek);
    c.drawCircle(const Offset(660, 660), 32, cheek);
    final mouth = Paint()
      ..color = const Color(0xFFB5443F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    c.drawPath(Path()..moveTo(505, 680)..quadraticBezierTo(540, 712, 575, 680), mouth);
  }

  void _hairBack(Canvas c, int style, Color color) {
    final p = Paint()..color = color;
    switch (style) {
      case 1:
        c.drawRRect(_rr(330, 380, 750, 1020, 120), p);
        break;
      case 2:
        c.drawRRect(_rr(730, 480, 820, 990, 45), p);
        c.drawCircle(const Offset(770, 500), 100, p);
        break;
      case 3:
        c.drawCircle(const Offset(380, 400), 100, p);
        c.drawCircle(const Offset(700, 400), 100, p);
        c.drawRRect(_rr(350, 380, 730, 720, 120), p);
        break;
      case 4:
        for (final o in const <Offset>[
          Offset(360, 520), Offset(380, 650), Offset(720, 520), Offset(700, 650),
          Offset(360, 780), Offset(720, 780), Offset(440, 380), Offset(640, 380),
        ]) {
          c.drawCircle(o, 80, p);
        }
        break;
      default:
        c.drawRRect(_rr(350, 380, 730, 720, 120), p);
    }
  }

  void _hairFront(Canvas c, int style, Color color) {
    final p = Paint()..color = color;
    c.drawRRect(
      RRect.fromLTRBAndCorners(
        340, 340, 740, 520,
        topLeft: const Radius.circular(200),
        topRight: const Radius.circular(200),
        bottomLeft: const Radius.circular(40),
        bottomRight: const Radius.circular(40),
      ),
      p,
    );
    if (style == 4) {
      c.drawCircle(const Offset(400, 420), 70, p);
      c.drawCircle(const Offset(540, 360), 80, p);
      c.drawCircle(const Offset(680, 420), 70, p);
    }
  }

  void _top(Canvas c, Item item) {
    final p = Paint()..color = item.color;
    final sleeveL = _rr(310, 770, 400, 920, 40);
    final sleeveR = _rr(680, 770, 770, 920, 40);
    if (item.style == 4) {
      // Tank top: no sleeves
      c.drawRRect(_rr(430, 740, 650, 1100, 40), p);
    } else if (item.style == 1) {
      // Hoodie
      c.drawRRect(_rr(310, 770, 400, 1040, 40), p);
      c.drawRRect(_rr(680, 770, 770, 1040, 40), p);
      c.drawRRect(_rr(380, 740, 700, 1120, 70), p);
      c.drawRRect(_rr(470, 690, 610, 790, 60), p);
      c.drawRRect(_rr(440, 960, 640, 1040, 20), Paint()..color = const Color(0x22000000));
    } else if (item.style == 2) {
      // Blouse with bow
      c.drawRRect(sleeveL, p);
      c.drawRRect(sleeveR, p);
      c.drawRRect(_rr(380, 740, 700, 1100, 60), p);
      final bow = Paint()..color = Colors.white;
      c.drawCircle(const Offset(520, 790), 20, bow);
      c.drawCircle(const Offset(560, 790), 20, bow);
    } else if (item.style == 3) {
      // Striped sweater
      c.drawRRect(sleeveL, p);
      c.drawRRect(sleeveR, p);
      c.drawRRect(_rr(380, 740, 700, 1100, 60), p);
      final stripe = Paint()..color = const Color(0x66FFFFFF);
      c.drawRect(Rect.fromLTRB(380, 900, 700, 930), stripe);
      c.drawRect(Rect.fromLTRB(380, 960, 700, 990), stripe);
    } else {
      // T-shirt
      c.drawRRect(sleeveL, p);
      c.drawRRect(sleeveR, p);
      c.drawRRect(_rr(380, 740, 700, 1100, 60), p);
    }
  }

  void _bottom(Canvas c, Item item) {
    final p = Paint()..color = item.color;
    if (item.style == 0) {
      // Shorts
      c.drawRRect(_rr(420, 1090, 660, 1330, 30), p);
    } else if (item.style == 2 || item.style == 4) {
      // Skirt (4 = pleated)
      c.drawPath(_poly([const Offset(400, 1090), const Offset(680, 1090), const Offset(740, 1340), const Offset(340, 1340)]), p);
      if (item.style == 4) {
        final pleat = Paint()
          ..color = const Color(0x33000000)
          ..strokeWidth = 4;
        for (var x = 380.0; x <= 700; x += 40) {
          c.drawLine(Offset(x, 1100), Offset(540 + (x - 540) * 1.2, 1340), pleat);
        }
      }
    } else {
      // Pants / jeans
      c.drawRRect(_rr(420, 1080, 660, 1200, 40), p);
      c.drawRRect(_rr(425, 1100, 535, 1640, 30), p);
      c.drawRRect(_rr(545, 1100, 655, 1640, 30), p);
    }
  }

  void _dress(Canvas c, Item item) {
    final p = Paint()..color = item.color;
    switch (item.style) {
      case 1: // puffy
        c.drawPath(_poly([const Offset(440, 740), const Offset(640, 740), const Offset(610, 1000), const Offset(760, 1520), const Offset(320, 1520), const Offset(470, 1000)]), p);
        break;
      case 2: // spaghetti straps
        c.drawRRect(_rr(455, 700, 485, 770, 10), p);
        c.drawRRect(_rr(595, 700, 625, 770, 10), p);
        c.drawPath(_poly([const Offset(470, 760), const Offset(610, 760), const Offset(700, 1500), const Offset(380, 1500)]), p);
        break;
      case 3: // long gown
        c.drawPath(_poly([const Offset(430, 740), const Offset(650, 740), const Offset(700, 1700), const Offset(380, 1700)]), p);
        break;
      case 4: // sailor dress
        c.drawRRect(_rr(410, 740, 670, 1080, 50), p);
        c.drawPath(_poly([const Offset(480, 740), const Offset(600, 740), const Offset(540, 870)]), Paint()..color = Colors.white);
        c.drawPath(_poly([const Offset(380, 1080), const Offset(700, 1080), const Offset(740, 1480), const Offset(340, 1480)]), p);
        c.drawRect(Rect.fromLTRB(340, 1440, 740, 1475), Paint()..color = Colors.white);
        break;
      default: // A-line
        c.drawPath(_poly([const Offset(430, 740), const Offset(650, 740), const Offset(740, 1520), const Offset(340, 1520)]), p);
    }
  }

  void _shoes(Canvas c, Item item) {
    final p = Paint()..color = item.color;
    final top = item.style == 1 ? 1520.0 : 1600.0; // boots go higher
    c.drawRRect(_rr(420, top, 540, 1670, 30), p);
    c.drawRRect(_rr(540, top, 660, 1670, 30), p);
    if (item.style == 2) {
      // heels
      c.drawRRect(_rr(450, 1670, 470, 1710, 8), p);
      c.drawRRect(_rr(610, 1670, 630, 1710, 8), p);
    }
  }

  void _accessory(Canvas c, Item item) {
    final p = Paint()..color = item.color;
    final stroke = Paint()
      ..color = item.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    if (item.style == 0) {
      // Bow
      c.drawPath(_poly([const Offset(720, 400), const Offset(670, 365), const Offset(670, 435)]), p);
      c.drawPath(_poly([const Offset(720, 400), const Offset(770, 365), const Offset(770, 435)]), p);
      c.drawCircle(const Offset(720, 400), 14, p);
    } else if (item.style == 1) {
      // Necklace
      c.drawPath(Path()..moveTo(470, 790)..quadraticBezierTo(540, 870, 610, 790), stroke..strokeWidth = 6);
      c.drawCircle(const Offset(540, 858), 16, p);
    } else if (item.style == 2) {
      // Glasses
      c.drawCircle(const Offset(470, 590), 52, stroke..strokeWidth = 8);
      c.drawCircle(const Offset(610, 590), 52, stroke..strokeWidth = 8);
      c.drawLine(const Offset(522, 590), const Offset(558, 590), stroke..strokeWidth = 8);
    } else if (item.style == 3) {
      // Hat
      c.drawRRect(_rr(360, 330, 720, 375, 22), p);
      c.drawRRect(_rr(450, 220, 630, 345, 40), p);
      c.drawRect(Rect.fromLTRB(450, 300, 630, 322), Paint()..color = const Color(0x55000000));
    } else {
      // Earrings
      c.drawCircle(const Offset(326, 620), 14, p);
      c.drawCircle(const Offset(754, 620), 14, p);
    }
  }

  @override
  bool shouldRepaint(covariant AvatarPainter old) => true;
}
