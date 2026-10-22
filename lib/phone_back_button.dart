import 'package:flutter/material.dart';
import 'design_tokens.dart';

// Botón redondo para volver al home del teléfono.
class PhoneBackButton extends StatelessWidget {
  const PhoneBackButton({super.key, this.light = true});

  final bool light;

  @override
  Widget build(BuildContext context) {
    final Color fg = light ? Colors.white : LoquitoTokens.ink;
    final Color bg = light
        ? Colors.white.withOpacity(0.14)
        : Colors.black.withOpacity(0.08);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: fg.withOpacity(0.45), width: 1),
        ),
        child: Icon(Icons.arrow_back_rounded, size: 18, color: fg),
      ),
    );
  }
}