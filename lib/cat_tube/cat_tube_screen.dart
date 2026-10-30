import 'package:flutter/material.dart';
import '../app_transitions.dart';
import '../design_tokens.dart';
import '../phone_back_button.dart';
import 'models/post_interaction.dart';
import 'models/video_post.dart';
import 'profile/profile_screen.dart';
import 'services/video_api.dart';
import 'widgets/cat_tube_bottom_nav.dart';
import 'widgets/video_card.dart';

/// App ficticia "CatTube": feed vertical tipo shorts con los videos que
/// entrega la API (Spring Boot + PostgreSQL). Los likes, comentarios y
/// compartidos viven en el teléfono mientras la app esté abierta.
class CatTubeScreen extends StatefulWidget {
  const CatTubeScreen({super.key});

  @override
  State<CatTubeScreen> createState() => _CatTubeScreenState();
}

class _CatTubeScreenState extends State<CatTubeScreen> {
  final PageController _controller = PageController();
  final VideoApi _api = VideoApi();

  /// Likes, comentarios y compartidos de cada video, guardados por id para
  /// que no se pierdan al deslizar ni al entrar al perfil.
  final Map<int, PostInteraction> _interactions = {};

  List<VideoPost> _posts = [];
  bool _loading = true;
  String? _error;
  int _page = 0;

  /// true mientras otra pantalla (el perfil) está encima del feed.
  bool _covered = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final posts = await _api.fetchVideos();
      if (!mounted) return;
      setState(() {
        _posts = posts;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo conectar con la API.\n$e';
        _loading = false;
      });
    }
  }

  Future<void> _openProfile() async {
    // pausa el video del feed para que no suene debajo del perfil
    setState(() => _covered = true);
    await Navigator.of(context).push(
      openAppRoute(
        ProfileScreen(posts: _posts, interactions: _interactions),
      ),
    );
    if (!mounted) return;
    // al volver, reanuda y refresca los likes que cambiaron en el perfil
    setState(() => _covered = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFeed() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: LoquitoTokens.catGreen),
      );
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, color: Colors.white38, size: 44),
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: LoquitoTokens.typewriter(size: 13, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _load,
                style: OutlinedButton.styleFrom(
                  foregroundColor: LoquitoTokens.catGreen,
                  side: const BorderSide(color: LoquitoTokens.catGreen),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    if (_posts.isEmpty) {
      return Center(
        child: Text(
          'Aún no hay teorías publicadas',
          style: LoquitoTokens.typewriter(size: 13, color: Colors.white54),
        ),
      );
    }
    return PageView.builder(
      controller: _controller,
      scrollDirection: Axis.vertical,
      itemCount: _posts.length,
      onPageChanged: (i) => setState(() => _page = i),
      itemBuilder: (context, i) => VideoCard(
        key: ValueKey(_posts[i].id),
        post: _posts[i],
        isActive: i == _page && !_covered,
        interaction: _interactions.putIfAbsent(
          _posts[i].id,
              () => PostInteraction(_posts[i].id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LoquitoTokens.screenBlack,
      child: Stack(
        children: [
          Positioned.fill(child: _buildFeed()),

          // indicador de página (puntitos a la izquierda)
          if (_posts.length > 1)
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: IgnorePointer(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < _posts.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          width: 4,
                          height: i == _page ? 16 : 4,
                          decoration: BoxDecoration(
                            color: i == _page
                                ? LoquitoTokens.catGreen
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

          // barra superior: volver + logo + pestañas
          const Positioned(
            top: 44,
            left: 0,
            right: 0,
            child: _CatTubeTopBar(),
          ),

          // navegación inferior de la app
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CatTubeBottomNav(onPerfil: _openProfile),
          ),
        ],
      ),
    );
  }
}

class _CatTubeTopBar extends StatelessWidget {
  const _CatTubeTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PhoneBackButton(),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.pets, color: LoquitoTokens.catGreen, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'CatTube',
                      style: LoquitoTokens.marker(size: 20, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _TopTab(label: 'Descubrir', selected: false),
                    SizedBox(width: 22),
                    _TopTab(label: 'Mis teorías', selected: true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 34), // balancea el back button
        ],
      ),
    );
  }
}

class _TopTab extends StatelessWidget {
  const _TopTab({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: LoquitoTokens.typewriter(
            size: 14,
            color: selected ? Colors.white : Colors.white60,
            weight: selected ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        if (selected)
          Container(width: 26, height: 2.4, color: LoquitoTokens.catGreen),
      ],
    );
  }
}