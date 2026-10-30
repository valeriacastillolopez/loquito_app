import 'package:flutter/material.dart';
import '../../design_tokens.dart';
import '../models/post_interaction.dart';
import '../models/video_post.dart';
import '../widgets/cat_tube_bottom_nav.dart';
import '../widgets/video_card.dart';

/// Visor a pantalla completa de los videos del perfil. Abre en el video
/// que tocaste y deja deslizar entre los demás, con likes, comentarios y
/// compartir funcionando igual que en el feed.
class VideoViewerScreen extends StatefulWidget {
  const VideoViewerScreen({
    super.key,
    required this.posts,
    required this.startIndex,
    required this.interactions,
  });

  final List<VideoPost> posts;
  final int startIndex;
  final Map<int, PostInteraction> interactions;

  @override
  State<VideoViewerScreen> createState() => _VideoViewerScreenState();
}

class _VideoViewerScreenState extends State<VideoViewerScreen> {
  late final PageController _controller =
  PageController(initialPage: widget.startIndex);
  late int _page = widget.startIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LoquitoTokens.screenBlack,
      child: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.vertical,
              itemCount: widget.posts.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                final post = widget.posts[i];
                return VideoCard(
                  key: ValueKey(post.id),
                  post: post,
                  isActive: i == _page,
                  interaction: widget.interactions.putIfAbsent(
                    post.id,
                        () => PostInteraction(post.id),
                  ),
                );
              },
            ),
          ),

          // botón para regresar al perfil
          Positioned(
            top: 44,
            left: 16,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.45),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CatTubeBottomNav(
              current: CatTubeTab.perfil,
              // Inicio: cierra el visor y el perfil, y vuelve al feed
              onInicio: () {
                final nav = Navigator.of(context);
                nav.pop();
                nav.pop();
              },
              // Perfil: cierra solo el visor y vuelve al perfil
              onPerfil: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}