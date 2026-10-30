import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../design_tokens.dart';
import '../models/post_interaction.dart';
import '../models/video_post.dart';
import 'comments_sheet.dart';
import 'share_sheet.dart';

// Solo reproduce cuando [isActive] es true
class VideoCard extends StatefulWidget {
  const VideoCard({
    super.key,
    required this.post,
    required this.isActive,
    required this.interaction,
  });

  final VideoPost post;
  final bool isActive;

  // Likes, comentarios y compartidos de este video
  final PostInteraction interaction;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  VideoPlayerController? _controller;
  bool _userPaused = false;

  // estado visual de las animaciones
  bool _likePop = false;
  bool _bigPaw = false;
  String? _toast;

  PostInteraction get _it => widget.interaction;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _startController();
  }

  void _startController() {
    if (_controller != null || widget.post.videoUrl.isEmpty) return;
    final c = VideoPlayerController.networkUrl(Uri.parse(widget.post.videoUrl));
    _controller = c;
    c.initialize().then((_) {
      if (!mounted) return;
      c.setLooping(true);
      if (widget.isActive && !_userPaused) c.play();
      setState(() {});
    }).catchError((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant VideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive == oldWidget.isActive) return;

    if (widget.isActive) {
      _userPaused = false;
      if (_controller == null) {
        _startController();
      } else if (_controller!.value.isInitialized) {
        _controller!.play();
      }
    } else {
      _controller?.pause();
      _controller?.seekTo(Duration.zero);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------ reproducción
  void _togglePlay() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    setState(() {
      _userPaused = c.value.isPlaying;
      _userPaused ? c.pause() : c.play();
    });
  }

  // ------------------------------------------------------------------- like
  void _pop() {
    _likePop = true;
    Future.delayed(const Duration(milliseconds: 160), () {
      if (mounted) setState(() => _likePop = false);
    });
  }

  void _toggleLike() {
    setState(() {
      _it.liked = !_it.liked;
      _pop();
    });
  }

  void _doubleTapLike() {
    setState(() {
      _it.liked = true;
      _bigPaw = true;
      _pop();
    });
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _bigPaw = false);
    });
  }

  // ------------------------------------------------------------ comentarios
  void _openComments() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentsSheet(
        comments: _it.comments,
        totalCount: () => widget.post.comments + _it.addedComments,
        onSend: (text) {
          setState(() {
            _it.comments.insert(
              0,
              PostComment(user: '@tu_usuario', text: text, time: 'ahora'),
            );
            _it.addedComments++;
          });
        },
      ),
    );
  }

  // -------------------------------------------------------------- compartir
  void _openShare() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ShareSheet(onPick: _onSharePick),
    );
  }

  void _onSharePick(String option) {
    if (option == 'Copiar enlace') {
      Clipboard.setData(
        ClipboardData(text: 'https://cattube.app/v/${widget.post.id}'),
      );
      _showToast('Enlace copiado');
    } else {
      _showToast('Compartido en $option');
    }
    setState(() => _it.shares++);
  }

  void _showToast(String message) {
    setState(() => _toast = message);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted && _toast == message) setState(() => _toast = null);
    });
  }

  // ------------------------------------------------------------------ build
  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final c = _controller;
    final ready = c != null && c.value.isInitialized;
    final failed = c != null && c.value.hasError;

    return Stack(
      fit: StackFit.expand,
      children: [
        // --- el video (un toque pausa, doble toque da like) ---
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _togglePlay,
          onDoubleTap: _doubleTapLike,
          child: Container(
            color: Colors.black,
            child: ready
                ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: c.value.size.width,
                  height: c.value.size.height,
                  child: VideoPlayer(c),
                ),
              ),
            )
                : null,
          ),
        ),

        // degradado para que el texto se lea sobre cualquier video
        IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.transparent,
                  Colors.black.withOpacity(0.75),
                ],
                stops: const [0, 0.4, 1],
              ),
            ),
          ),
        ),

        // huella grande del doble toque
        Center(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _bigPaw ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedScale(
                scale: _bigPaw ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: const Icon(
                  Icons.pets,
                  size: 110,
                  color: LoquitoTokens.catGreen,
                ),
              ),
            ),
          ),
        ),

        // estado: cargando / error / pausado
        if (!ready)
          Center(
            child: failed
                ? const _CenterMessage(
              icon: Icons.videocam_off_rounded,
              text: 'NO SE PUDO CARGAR EL VIDEO',
            )
                : const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: LoquitoTokens.catGreen,
              ),
            ),
          )
        else if (_userPaused)
          const Center(
            child: IgnorePointer(
              child: Icon(Icons.play_arrow_rounded,
                  size: 72, color: Colors.white54),
            ),
          ),

        // aviso corto (enlace copiado, compartido…)
        Positioned(
          top: 120,
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

        // contenido inferior: usuario + descripción + audio
        Positioned(
          left: 16,
          right: 86,
          bottom: 108,
          child: IgnorePointer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        post.username,
                        overflow: TextOverflow.ellipsis,
                        style: LoquitoTokens.typewriter(
                          size: 15,
                          color: Colors.white,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: LoquitoTokens.catGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        post.tag,
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  post.caption,
                  style: LoquitoTokens.typewriter(
                    size: 13,
                    color: Colors.white,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  post.hashtags,
                  style: LoquitoTokens.typewriter(
                    size: 13,
                    color: LoquitoTokens.catGreen,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.music_note, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'sonido original — susurros del alcantarillado',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: LoquitoTokens.typewriter(
                          size: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // columna derecha: avatar + like + comentarios + compartir
        Positioned(
          right: 12,
          bottom: 96,
          child: Column(
            children: [
              const _Avatar(),
              const SizedBox(height: 18),
              _SideAction(
                icon: Icons.pets,
                label: formatCount(post.likes + (_it.liked ? 1 : 0)),
                color: _it.liked ? LoquitoTokens.catGreen : Colors.white,
                scale: _likePop ? 1.4 : 1.0,
                onTap: _toggleLike,
              ),
              const SizedBox(height: 16),
              _SideAction(
                icon: Icons.chat_bubble,
                label: formatCount(post.comments + _it.addedComments),
                color: Colors.white,
                onTap: _openComments,
              ),
              const SizedBox(height: 16),
              _SideAction(
                icon: Icons.reply,
                label: formatCount(post.shares + _it.shares),
                color: Colors.white,
                onTap: _openShare,
              ),
              const SizedBox(height: 16),
              const _SoundDisc(),
            ],
          ),
        ),
      ],
    );
  }
}

class _CenterMessage extends StatelessWidget {
  const _CenterMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 42, color: Colors.white),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: LoquitoTokens.catGreen, width: 2),
        color: LoquitoTokens.paperDark,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/loquito_avatar.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _SideAction extends StatelessWidget {
  const _SideAction({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.scale = 1.0,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: LoquitoTokens.typewriter(
              size: 11,
              color: Colors.white,
              weight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoundDisc extends StatelessWidget {
  const _SoundDisc();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: const Icon(Icons.graphic_eq, size: 15, color: Colors.white70),
    );
  }
}