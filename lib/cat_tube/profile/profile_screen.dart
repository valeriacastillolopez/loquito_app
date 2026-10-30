import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../app_transitions.dart';
import '../../cork_painter.dart';
import '../../design_tokens.dart';
import '../../phone_back_button.dart';
import '../models/post_interaction.dart';
import '../models/video_post.dart';
import '../widgets/cat_tube_bottom_nav.dart';
import '../widgets/share_sheet.dart';
import 'profile_video_tile.dart';
import 'video_viewer_screen.dart';

/// Perfil del loquito: su "expediente". Una ficha de papel pegada a un
/// corcho, con sus estadísticas como sellos y sus videos como recortes.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.posts,
    required this.interactions,
  });

  final List<VideoPost> posts;
  final Map<int, PostInteraction> interactions;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _tab = 0; // 0 = pruebas, 1 = mis reacciones
  bool _joined = false;
  String? _toast;

  bool _isLiked(VideoPost p) => widget.interactions[p.id]?.liked ?? false;

  List<VideoPost> get _visible =>
      _tab == 0 ? widget.posts : widget.posts.where(_isLiked).toList();

  int get _totalReactions => widget.posts.fold<int>(
    0,
        (sum, p) => sum + p.likes + (_isLiked(p) ? 1 : 0),
  );

  // ---------------------------------------------------------------- acciones
  Future<void> _openViewer(List<VideoPost> list, int index) async {
    await Navigator.of(context).push(
      openAppRoute(
        VideoViewerScreen(
          posts: list,
          startIndex: index,
          interactions: widget.interactions,
        ),
      ),
    );
    // al volver, los likes pudieron cambiar: refresca contadores y pestañas
    if (mounted) setState(() {});
  }

  void _showToast(String message) {
    setState(() => _toast = message);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted && _toast == message) setState(() => _toast = null);
    });
  }

  void _toggleJoin() {
    setState(() => _joined = !_joined);
    _showToast(_joined
        ? 'Ahora eres testigo del movimiento'
        : 'Dejaste de ser testigo');
  }

  void _openShare() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ShareSheet(
        onPick: (option) {
          if (option == 'Copiar enlace') {
            Clipboard.setData(
              const ClipboardData(text: 'https://cattube.app/@el_loquito_real'),
            );
            _showToast('Enlace de la ficha copiado');
          } else {
            _showToast('Ficha compartida en $option');
          }
        },
      ),
    );
  }

  void _showPortrait() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (ctx) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(ctx).pop(),
        child: Center(
          child: Transform.rotate(
            angle: -0.02,
            child: Container(
              margin: const EdgeInsets.all(26),
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
              decoration: BoxDecoration(
                color: LoquitoTokens.paper,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(color: Colors.black54, blurRadius: 18),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/images/loquito_perfil.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'SUJETO: EL LOQUITO\nVisto por última vez en la plaza.',
                    textAlign: TextAlign.center,
                    style: LoquitoTokens.typewriter(
                      size: 11,
                      color: LoquitoTokens.ink,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------- build
  @override
  Widget build(BuildContext context) {
    final visible = _visible;

    return Container(
      color: LoquitoTokens.cork,
      child: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: CorkTexturePainter()),
          ),

          // contenido que se desliza
          Positioned.fill(
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
                SliverToBoxAdapter(
                  child: _ProfileCard(
                    teorias: widget.posts.length,
                    reacciones: formatCount(_totalReactions),
                    joined: _joined,
                    onAvatarTap: _showPortrait,
                    onJoinTap: _toggleJoin,
                    onShareTap: _openShare,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FolderTabs(
                    selected: _tab,
                    onSelect: (i) => setState(() => _tab = i),
                  ),
                ),
                if (visible.isEmpty)
                  SliverToBoxAdapter(
                    child: _EmptyNote(
                      text: _tab == 1
                          ? 'Aún no reaccionas a ninguna teoría.\n'
                          'Dale a la huella en el feed.'
                          : 'No hay pruebas todavía.',
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, i) => ProfileVideoTile(
                          post: visible[i],
                          index: i,
                          liked: _isLiked(visible[i]),
                          onTap: () => _openViewer(visible, i),
                        ),
                        childCount: visible.length,
                      ),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 22,
                        crossAxisSpacing: 14,
                        mainAxisExtent: 272,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),

          // degradado suave bajo la barra superior (no bloquea toques)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // barra superior: volver al inicio del teléfono + título
          Positioned(
            top: 44,
            left: 16,
            right: 16,
            child: Row(
              children: [
                const PhoneBackButton(),
                Expanded(
                  child: Center(
                    child: Text(
                      'EXPEDIENTE',
                      style: LoquitoTokens.marker(
                        size: 20,
                        color: LoquitoTokens.paper,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 34),
              ],
            ),
          ),

          // aviso corto
          Positioned(
            top: 104,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: AnimatedOpacity(
                  opacity: _toast == null ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: LoquitoTokens.catGreen),
                    ),
                    child: Text(
                      _toast ?? '',
                      style: LoquitoTokens.typewriter(
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // navegación inferior: Perfil seleccionado, Inicio regresa al feed
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CatTubeBottomNav(
              current: CatTubeTab.perfil,
              onInicio: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================ ficha de perfil
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.teorias,
    required this.reacciones,
    required this.joined,
    required this.onAvatarTap,
    required this.onJoinTap,
    required this.onShareTap,
  });

  final int teorias;
  final String reacciones;
  final bool joined;
  final VoidCallback onAvatarTap;
  final VoidCallback onJoinTap;
  final VoidCallback onShareTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
      child: Transform.rotate(
        angle: -0.012,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 24, 14, 14),
              decoration: BoxDecoration(
                color: LoquitoTokens.paper,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 12,
                    offset: Offset(2, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _AvatarPolaroid(onTap: onAvatarTap),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'El Loquito',
                              style: LoquitoTokens.marker(
                                size: 24,
                                color: LoquitoTokens.ink,
                              ),
                            ),
                            Text(
                              '@el_loquito_real',
                              style: LoquitoTokens.typewriter(
                                size: 12,
                                color: LoquitoTokens.inkSoft,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: LoquitoTokens.string,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                'VERIFICADO POR NADIE',
                                style: LoquitoTokens.typewriter(
                                  size: 8.5,
                                  color: LoquitoTokens.string,
                                  weight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Vigilante oficial del Centro desde siempre. '
                          'Las palomas me miran, el semáforo me habla. '
                          'Yo solo sigo la evidencia.',
                      style: LoquitoTokens.typewriter(
                        size: 12,
                        color: LoquitoTokens.ink,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stamp(
                        value: '$teorias',
                        label: 'TEORÍAS',
                        color: LoquitoTokens.string,
                        angle: -0.06,
                      ),
                      const _Stamp(
                        value: '48.2K',
                        label: 'TESTIGOS',
                        color: LoquitoTokens.catGreenDark,
                        angle: 0.04,
                      ),
                      _Stamp(
                        value: reacciones,
                        label: 'REACCIONES',
                        color: LoquitoTokens.ink,
                        angle: -0.03,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onJoinTap,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 42,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: joined
                                  ? Colors.transparent
                                  : LoquitoTokens.catGreen,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: joined
                                    ? LoquitoTokens.catGreenDark
                                    : LoquitoTokens.ink,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              joined ? 'ERES TESTIGO ✓' : 'UNIRSE AL MOVIMIENTO',
                              style: LoquitoTokens.marker(
                                size: 13,
                                color: joined
                                    ? LoquitoTokens.catGreenDark
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: onShareTap,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: LoquitoTokens.ink,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.reply,
                            color: LoquitoTokens.ink,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // cintas adhesivas en las esquinas
            const Positioned(top: -8, left: 18, child: _Tape(angle: -0.25)),
            const Positioned(top: -8, right: 18, child: _Tape(angle: 0.25)),
          ],
        ),
      ),
    );
  }
}

class _Tape extends StatelessWidget {
  const _Tape({required this.angle});

  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 58,
        height: 17,
        color: LoquitoTokens.warning.withOpacity(0.6),
      ),
    );
  }
}

class _AvatarPolaroid extends StatelessWidget {
  const _AvatarPolaroid({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: -0.05,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 6,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/loquito_avatar.png',
                fit: BoxFit.cover,
              ),
            ),
            // pista de que se puede tocar para ver la foto completa
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.zoom_in, size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Estadística con forma de sello de goma, ligeramente girado.
class _Stamp extends StatelessWidget {
  const _Stamp({
    required this.value,
    required this.label,
    required this.color,
    required this.angle,
  });

  final String value;
  final String label;
  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: LoquitoTokens.marker(size: 17, color: color)),
            Text(
              label,
              style: LoquitoTokens.typewriter(
                size: 8.5,
                color: color,
                weight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================= pestañas de carpeta
class _FolderTabs extends StatelessWidget {
  const _FolderTabs({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Row(
        children: [
          _FolderTab(
            label: 'PRUEBAS',
            on: selected == 0,
            onTap: () => onSelect(0),
          ),
          const SizedBox(width: 6),
          _FolderTab(
            label: 'MIS REACCIONES',
            on: selected == 1,
            onTap: () => onSelect(1),
          ),
        ],
      ),
    );
  }
}

class _FolderTab extends StatelessWidget {
  const _FolderTab({
    required this.label,
    required this.on,
    required this.onTap,
  });

  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: on
              ? LoquitoTokens.paper
              : LoquitoTokens.paperDark.withOpacity(0.55),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        ),
        child: Text(
          label,
          style: LoquitoTokens.marker(
            size: 12,
            color: on ? LoquitoTokens.ink : LoquitoTokens.inkSoft,
          ),
        ),
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Transform.rotate(
        angle: 0.015,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: LoquitoTokens.paper,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 8,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: LoquitoTokens.typewriter(
              size: 12.5,
              color: LoquitoTokens.ink,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}