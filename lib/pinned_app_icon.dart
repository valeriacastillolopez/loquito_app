import 'package:flutter/material.dart';
import 'design_tokens.dart';

// Descripción visual de una app en el home (sin ninguna lógica real).
class AppIconData {
  const AppIconData({
    required this.label,
    required this.icon,
    required this.background,
    this.iconColor = Colors.white,
    this.badge,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color iconColor;

  // Texto para una marca de notificación
  final String? badge;
}

// Un ícono recortado como si estuviera pegado al corcho.
class PinnedAppIcon extends StatelessWidget {
  const PinnedAppIcon({
    super.key,
    required this.data,
    this.size = 60,
    this.onTap,
  });

  final AppIconData data;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: size + 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // el "papel" recortado, ligeramente girado
                Transform.rotate(
                  angle: -0.035,
                  child: Container(
                    width: size,
                    height: size,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      color: LoquitoTokens.paper,
                      borderRadius:
                      BorderRadius.circular(LoquitoTokens.cardCorner),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 6,
                          offset: Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: data.background,
                        borderRadius: BorderRadius.circular(
                          LoquitoTokens.cardCorner - 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        data.icon,
                        color: data.iconColor,
                        size: size * 0.5,
                      ),
                    ),
                  ),
                ),
                // chincheta
                Positioned(
                  top: -7,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: LoquitoTokens.string,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black26, width: 0.6),
                    ),
                  ),
                ),
                if (data.badge != null)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: LoquitoTokens.warning,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Text(
                        data.badge!,
                        style: LoquitoTokens.typewriter(
                          size: 10,
                          color: LoquitoTokens.ink,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              data.label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: LoquitoTokens.typewriter(
                size: 11,
                color: LoquitoTokens.paper,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}