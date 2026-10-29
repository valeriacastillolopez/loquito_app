import 'package:flutter/material.dart';
import '../../design_tokens.dart';

// Panel inferior para compartir" una teoría
class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key, required this.onPick});

  final ValueChanged<String> onPick;

  static const _options = [
    ('Susurros', Icons.chat_bubble_rounded, Color(0xFF3E5C8A)),
    ('Testigos', Icons.groups_rounded, Color(0xFF3E6E63)),
    ('Copiar enlace', Icons.link_rounded, Color(0xFF5A5750)),
    ('Más', Icons.more_horiz_rounded, Color(0xFF444444)),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1B1A17),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Compartir teoría',
                style: LoquitoTokens.marker(size: 16, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final o in _options)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                        onPick(o.$1);
                      },
                      child: SizedBox(
                        width: 72,
                        child: Column(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: o.$3,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(o.$2, color: Colors.white, size: 24),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              o.$1,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: LoquitoTokens.typewriter(
                                size: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}