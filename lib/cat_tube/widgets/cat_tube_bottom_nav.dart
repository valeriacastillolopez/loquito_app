import 'package:flutter/material.dart';
import '../../design_tokens.dart';

/// Barra inferior de navegación de CatTube. Es una franja de cinta
/// adhesiva sobre el video, con el botón de "Subir" como una chincheta
/// grande que invita a publicar la próxima "prueba".
class CatTubeBottomNav extends StatelessWidget {
  const CatTubeBottomNav({super.key});

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
        children: [
          const _NavItem(icon: Icons.home_rounded, label: 'Inicio', on: true),
          const _NavItem(icon: Icons.explore_rounded, label: 'Descubrir'),
          const _UploadButton(),
          const _NavItem(icon: Icons.markunread_mailbox_rounded, label: 'Buzón'),
          const _NavItem(icon: Icons.face_retouching_natural, label: 'Perfil'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, this.on = false});

  final IconData icon;
  final String label;
  final bool on;

  @override
  Widget build(BuildContext context) {
    final color = on ? LoquitoTokens.catGreen : Colors.white70;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 3),
        Text(
          label,
          style: LoquitoTokens.typewriter(size: 9, color: color),
        ),
      ],
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