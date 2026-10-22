import 'package:flutter/material.dart';
import 'app_transitions.dart';
import 'cork_painter.dart';
import 'design_tokens.dart';
import 'generic_app_screen.dart';
import 'pinned_app_icon.dart';
import 'cat_tube/cat_tube_screen.dart';

// Home del teléfono del loquito
class LoquitoHomeScreen extends StatelessWidget {
  const LoquitoHomeScreen({super.key});

  // Posiciones fijas
  static const List<Offset> _positions = [
    Offset(145, 24), // 0 CatTube
    Offset(29, 108), // 1 Teorías
    Offset(243, 116), // 2 Mapa del Centro
    Offset(65, 214), // 3 Susurros
    Offset(205, 224), // 4 Cámara
    Offset(19, 320), // 5 Buscador
    Offset(253, 334), // 6 Radio Libre
    Offset(135, 390), // 7 Ajustes
  ];

  static const List<AppIconData> _apps = [
    AppIconData(
      label: 'CatTube',
      icon: Icons.pets,
      background: LoquitoTokens.catGreen,
      badge: '99+',
    ),
    AppIconData(
      label: 'Teorías',
      icon: Icons.menu_book_rounded,
      background: Color(0xFF7A5230),
    ),
    AppIconData(
      label: 'Mapa',
      icon: Icons.map_rounded,
      background: Color(0xFF3E6E63),
    ),
    AppIconData(
      label: 'Susurros',
      icon: Icons.chat_bubble_rounded,
      background: Color(0xFF3E5C8A),
      badge: '7',
    ),
    AppIconData(
      label: 'Cámara',
      icon: Icons.photo_camera_rounded,
      background: Color(0xFF444444),
    ),
    AppIconData(
      label: 'Buscador',
      icon: Icons.search_rounded,
      background: Color(0xFF8A6D3E),
    ),
    AppIconData(
      label: 'Radio',
      icon: Icons.podcasts_rounded,
      background: LoquitoTokens.warning,
      iconColor: LoquitoTokens.ink,
    ),
    AppIconData(
      label: 'Ajustes',
      icon: Icons.settings_rounded,
      background: Color(0xFF5A5750),
    ),
  ];

  static const List<(int, int)> _links = [
    (0, 1),
    (0, 2),
    (1, 3),
    (2, 4),
    (3, 5),
    (4, 6),
    (3, 7),
    (5, 7),
  ];

  static const double _boardWidth = 332;
  static const double _boardHeight = 470;
  static const double _iconSize = 60;

  // transición de abrir app
  static void _openApp(BuildContext context, AppIconData data) {
    final Widget screen =
    data.label == 'CatTube' ? const CatTubeScreen() : GenericAppScreen(data: data);
    Navigator.of(context).push(openAppRoute(screen));
  }

  @override
  Widget build(BuildContext context) {
    // centro de cada ícono, para amarrar los hilos con precisión
    final centers = _positions
        .map((p) => p + const Offset(_iconSize / 2, _iconSize / 2))
        .toList();

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // fondo de corcho
              Positioned.fill(
                child: CustomPaint(painter: const CorkTexturePainter()),
              ),
              // encabezado escrito a mano
              const Positioned(
                top: 14,
                left: 20,
                right: 20,
                child: _BoardHeader(),
              ),
              // hilos, chinchetas, íconos
              Positioned(
                top: 78,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: _boardWidth,
                    height: _boardHeight,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: StringBoardPainter(
                              points: centers,
                              links: _links,
                            ),
                          ),
                        ),
                        for (int i = 0; i < _apps.length; i++)
                          Positioned(
                            left: _positions[i].dx,
                            top: _positions[i].dy,
                            child: PinnedAppIcon(
                              data: _apps[i],
                              size: _iconSize,
                              onTap: () => _openApp(context, _apps[i]),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const _Dock(),
      ],
    );
  }
}

class _BoardHeader extends StatelessWidget {
  const _BoardHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'MARCO PMBOK',
          textAlign: TextAlign.center,
          style: LoquitoTokens.marker(
            size: 17,
            color: LoquitoTokens.paper,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'NO TOCAR',
          textAlign: TextAlign.center,
          style: LoquitoTokens.typewriter(
            size: 11,
            color: LoquitoTokens.paper.withOpacity(0.85),
          ),
        ),
      ],
    );
  }
}

// Dock inferior
class _Dock extends StatelessWidget {
  const _Dock();

  static const List<AppIconData> _docked = [
    AppIconData(
      label: 'Teléfono',
      icon: Icons.call_rounded,
      background: Color(0xFF3E5C8A),
    ),
    AppIconData(
      label: 'Susurros',
      icon: Icons.chat_bubble_rounded,
      background: Color(0xFF3E5C8A),
    ),
    AppIconData(
      label: 'CatTube',
      icon: Icons.pets,
      background: LoquitoTokens.catGreen,
    ),
    AppIconData(
      label: 'Cámara',
      icon: Icons.photo_camera_rounded,
      background: Color(0xFF444444),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
      decoration: BoxDecoration(
        color: LoquitoTokens.corkDark,
        border: Border(
          top: BorderSide(color: Colors.black.withOpacity(0.35), width: 1),
        ),
      ),
      child: Builder(
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (int i = 0; i < _docked.length; i++)
                PinnedAppIcon(
                  data: _docked[i],
                  size: 52,
                  onTap: () => LoquitoHomeScreen._openApp(context, _docked[i]),
                ),
            ],
          );
        },
      ),
    );
  }
}