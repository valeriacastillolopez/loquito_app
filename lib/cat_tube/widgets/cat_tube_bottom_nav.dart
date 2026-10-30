import 'package:flutter/material.dart';
import '../../design_tokens.dart';

/// Pestañas de CatTube que ya tienen pantalla propia.
enum CatTubeTab { inicio, perfil }

/// Barra inferior de navegación de CatTube.
class CatTubeBottomNav extends StatelessWidget {
  const CatTubeBottomNav({
    super.key,
    this.current = CatTubeTab.inicio,
    this.onInicio,
    this.onPerfil,
  });

  final CatTubeTab current;
  final VoidCallback? onInicio;
  final VoidCallback? onPerfil;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Inicio',
            on: current == CatTubeTab.inicio,
            onTap: onInicio,
          ),
          const _NavItem(icon: Icons.explore_rounded, label: 'Descubrir'),
          const _UploadButton(),
          const _NavItem(
            icon: Icons.markunread_mailbox_rounded,
            label: 'Buzón',
          ),
          _ProfileNavItem(
            on: current == CatTubeTab.perfil,
            onTap: onPerfil,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.on = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool on;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = on ? LoquitoTokens.catGreen : Colors.white70;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: LoquitoTokens.typewriter(size: 9, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// El botón de Perfil muestra la foto del loquito en un círculo.
class _ProfileNavItem extends StatelessWidget {
  const _ProfileNavItem({required this.on, this.onTap});

  final bool on;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = on ? LoquitoTokens.catGreen : Colors.white70;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: on ? 2 : 1),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/loquito_avatar.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Perfil',
              style: LoquitoTokens.typewriter(size: 9, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 30,
      decoration: BoxDecoration(
        color: LoquitoTokens.catGreen,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black, width: 1.4),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.add, color: Colors.black, size: 22),
    );
  }
}