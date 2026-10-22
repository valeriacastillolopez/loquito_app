import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// Textura de corcho: puntitos aleatorios (pero con semilla fija, para que
/// no "parpadeen" en cada rebuild) que simulan la porosidad del corcho.
class CorkTexturePainter extends CustomPainter {
  const CorkTexturePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = LoquitoTokens.cork;
    canvas.drawRect(Offset.zero & size, base);

    final speck = Paint()..color = LoquitoTokens.corkDark.withOpacity(0.5);
    final rnd = math.Random(7); // semilla fija: textura estable
    for (int i = 0; i < 260; i++) {
      final dx = rnd.nextDouble() * size.width;
      final dy = rnd.nextDouble() * size.height;
      final r = 0.6 + rnd.nextDouble() * 1.6;
      canvas.drawCircle(Offset(dx, dy), r, speck);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Un punto donde debe amarrarse un hilo: el centro de un ícono en el
/// espacio del [CustomPaint].
typedef PinPoint = Offset;

/// Dibuja hilos rojos ligeramente curvos entre pares de puntos, como en un
/// tablero de investigación casero.
class StringBoardPainter extends CustomPainter {
  const StringBoardPainter({required this.points, required this.links});

  final List<PinPoint> points;

  /// Pares de índices de [points] que deben conectarse.
  final List<(int, int)> links;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = LoquitoTokens.string.withOpacity(0.85)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    for (final (a, b) in links) {
      final p1 = points[a];
      final p2 = points[b];
      final mid = Offset(
        (p1.dx + p2.dx) / 2 + (p2.dy - p1.dy) * 0.06,
        (p1.dy + p2.dy) / 2 - (p2.dx - p1.dx) * 0.06,
      );
      final path = Path()
        ..moveTo(p1.dx, p1.dy)
        ..quadraticBezierTo(mid.dx, mid.dy, p2.dx, p2.dy);
      canvas.drawPath(path, paint);
    }

    // chinches en cada punto
    final pin = Paint()..color = LoquitoTokens.string;
    final pinShine = Paint()..color = Colors.white.withOpacity(0.5);
    for (final p in points) {
      canvas.drawCircle(p, 4.2, pin);
      canvas.drawCircle(p - const Offset(1, 1), 1.2, pinShine);
    }
  }

  @override
  bool shouldRepaint(covariant StringBoardPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.links != links;
  }
}