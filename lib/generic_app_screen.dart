import 'package:flutter/material.dart';
import '/design_tokens.dart';
import '/phone_back_button.dart';
import '/pinned_app_icon.dart';

// Pantalla de relleno para cualquier app del teléfono que no sea cattube como una pantalla de verdad.
class GenericAppScreen extends StatelessWidget {
  const GenericAppScreen({super.key, required this.data});

  final AppIconData data;

  @override
  Widget build(BuildContext context) {
    final Color bg = Color.lerp(data.background, Colors.black, 0.78)!;
    final String title = data.label.replaceAll('\n', ' ');

    return Container(
      color: bg,
      child: Column(
        children: [
          const SizedBox(height: 44),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const PhoneBackButton(),
                Expanded(
                  child: Column(
                    children: [
                      Icon(data.icon, color: Colors.white, size: 22),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: LoquitoTokens.marker(size: 17, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 34), // balancea el back button
              ],
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
              child: _bodyFor(title, data.background),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _bodyFor(String title, Color accent) {
  switch (title) {
    case 'Teorías':
      return _TheoriesBody(accent: accent);
    case 'Mapa del Centro':
      return _MapBody(accent: accent);
    case 'Susurros':
      return _ChatBody(accent: accent);
    case 'Cámara':
      return _CameraBody(accent: accent);
    case 'Buscador':
      return _SearchBody(accent: accent);
    case 'Radio Libre':
      return _RadioBody(accent: accent);
    case 'Ajustes':
      return _SettingsBody(accent: accent);
    case 'Teléfono':
      return _DialerBody(accent: accent);
    default:
      return const SizedBox.shrink();
  }
}

// Teorías
class _TheoriesBody extends StatelessWidget {
  const _TheoriesBody({required this.accent});
  final Color accent;

  static const _theories = [
    ('Teoría #12', 'El reloj de la plaza atrasa a propósito.'),
    ('Teoría #31', 'Las luces del puente parpadean en código.'),
    ('Teoría #47', 'Las palomas son drones. Cuenten los cables.'),
    ('Teoría #52', 'El autobús de las 7 nunca llega vacío ni lleno.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final t in _theories)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: LoquitoTokens.paper,
              borderRadius: BorderRadius.circular(LoquitoTokens.cardCorner),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(2, 3)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 4, height: 34, color: accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.$1, style: LoquitoTokens.typewriter(size: 13, weight: FontWeight.w700)),
                      const SizedBox(height: 3),
                      Text(t.$2, style: LoquitoTokens.typewriter(size: 12, color: LoquitoTokens.inkSoft)),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Mapa
class _MapBody extends StatelessWidget {
  const _MapBody({required this.accent});
  final Color accent;

  static const _pins = [
    ('Plaza Mayor', 'avistamiento #1'),
    ('Puente Viejo', 'señal en código'),
    ('Mercado Central', 'anomalía temporal'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 170,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.25),
            borderRadius: BorderRadius.circular(LoquitoTokens.cardCorner),
            border: Border.all(color: Colors.white24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(size: Size.infinite, painter: _GridPainter()),
              Icon(Icons.location_on, color: accent, size: 34),
              const Positioned(left: 40, top: 30, child: Icon(Icons.location_on, color: Colors.white54, size: 18)),
              const Positioned(right: 36, bottom: 26, child: Icon(Icons.location_on, color: Colors.white54, size: 18)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Puntos marcados', style: LoquitoTokens.typewriter(size: 13, color: Colors.white70, weight: FontWeight.w700)),
        const SizedBox(height: 8),
        for (final p in _pins)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Icon(Icons.push_pin, size: 14, color: accent),
                const SizedBox(width: 8),
                Text(p.$1, style: LoquitoTokens.typewriter(size: 13, color: Colors.white, weight: FontWeight.w700)),
                const SizedBox(width: 6),
                Text('— ${p.$2}', style: LoquitoTokens.typewriter(size: 12, color: Colors.white54)),
              ],
            ),
          ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Susurros
class _ChatBody extends StatelessWidget {
  const _ChatBody({required this.accent});
  final Color accent;

  static const _chats = [
    ('Vecino del 5to', '¿viste lo de anoche?', '21:40'),
    ('Testigos del Centro', '14 mensajes nuevos', '20:02'),
    ('Desconocido', 'no digas nada todavía', 'ayer'),
    ('Mamá', 'bájale dos rayitas porfa', 'ayer'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final c in _chats)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                CircleAvatar(radius: 18, backgroundColor: accent, child: const Icon(Icons.face, color: Colors.white, size: 18)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.$1, style: LoquitoTokens.typewriter(size: 13, color: Colors.white, weight: FontWeight.w700)),
                      Text(c.$2, style: LoquitoTokens.typewriter(size: 12, color: Colors.white54)),
                    ],
                  ),
                ),
                Text(c.$3, style: LoquitoTokens.typewriter(size: 10, color: Colors.white38)),
              ],
            ),
          ),
      ],
    );
  }
}

// Cámara
class _CameraBody extends StatelessWidget {
  const _CameraBody({required this.accent});
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(LoquitoTokens.cardCorner),
              border: Border.all(color: Colors.white24),
            ),
            child: const Center(
              child: Icon(Icons.photo_camera_rounded, color: Colors.white24, size: 48),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.flash_off_rounded, color: Colors.white54, size: 22),
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: accent, width: 3),
              ),
            ),
            const Icon(Icons.cameraswitch_rounded, color: Colors.white54, size: 22),
          ],
        ),
      ],
    );
  }
}

// Buscador
class _SearchBody extends StatelessWidget {
  const _SearchBody({required this.accent});
  final Color accent;

  static const _recent = ['drones', 'ruido subterráneo', 'código en semáforos'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: Colors.white54, size: 18),
              const SizedBox(width: 8),
              Text('Buscar en el centro…', style: LoquitoTokens.typewriter(size: 13, color: Colors.white54)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text('Búsquedas recientes', style: LoquitoTokens.typewriter(size: 12, color: Colors.white54, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final r in _recent)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent),
                ),
                child: Text(r, style: LoquitoTokens.typewriter(size: 12, color: Colors.white)),
              ),
          ],
        ),
      ],
    );
  }
}

// Radio
class _RadioBody extends StatelessWidget {
  const _RadioBody({required this.accent});
  final Color accent;

  static const _schedule = [
    ('20:00', 'Frecuencia Olvidada'),
    ('21:00', 'Susurros del Alcantarillado'),
    ('22:00', 'Llamadas Nocturnas'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
            border: Border.all(color: accent, width: 3),
          ),
          child: Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white24)),
              child: const Icon(Icons.podcasts_rounded, color: Colors.white70, size: 30),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('AL AIRE AHORA', style: LoquitoTokens.typewriter(size: 11, color: accent, weight: FontWeight.w700, letterSpacing: 1.2)),
        const SizedBox(height: 18),
        for (final s in _schedule)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Text(s.$1, style: LoquitoTokens.typewriter(size: 12, color: Colors.white54)),
                const SizedBox(width: 12),
                Text(s.$2, style: LoquitoTokens.typewriter(size: 13, color: Colors.white)),
              ],
            ),
          ),
      ],
    );
  }
}

// Ajustes
class _SettingsBody extends StatelessWidget {
  const _SettingsBody({required this.accent});
  final Color accent;

  static const _rows = [
    ('Modo encubierto', true),
    ('Notificaciones de pruebas', true),
    ('Compartir ubicación con el movimiento', false),
    ('Privacidad del tablero', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final r in _rows)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(r.$1, style: LoquitoTokens.typewriter(size: 13, color: Colors.white)),
                ),
                Container(
                  width: 38,
                  height: 20,
                  padding: const EdgeInsets.all(2),
                  alignment: r.$2 ? Alignment.centerRight : Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: r.$2 ? accent : Colors.white24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Teléfono
class _DialerBody extends StatelessWidget {
  const _DialerBody({required this.accent});
  final Color accent;

  static const _keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', '#'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('— sin número marcado —', style: LoquitoTokens.typewriter(size: 13, color: Colors.white38)),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            for (final k in _keys)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                  border: Border.all(color: Colors.white24),
                ),
                alignment: Alignment.center,
                child: Text(k, style: LoquitoTokens.typewriter(size: 18, color: Colors.white)),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
          child: const Icon(Icons.call_rounded, color: Colors.white, size: 24),
        ),
      ],
    );
  }
}