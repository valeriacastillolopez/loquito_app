import 'package:flutter/material.dart';
import '../../design_tokens.dart';
import '../models/video_post.dart';

class ProfileVideoTile extends StatelessWidget {
  const ProfileVideoTile({
    super.key,
    required this.post,
    required this.index,
    required this.liked,
    required this.onTap,
  });

  final VideoPost post;
  final int index;
  final bool liked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // cada recorte se inclina al lado contrario del anterior
    final angle = (index.isEven ? -1 : 1) * 0.022;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Transform.rotate(
        angle: angle,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
                decoration: BoxDecoration(
                  color: LoquitoTokens.paper,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      offset: Offset(2, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _Thumb(post: post, liked: liked)),
                    const SizedBox(height: 8),
                    Text(
                      post.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: LoquitoTokens.typewriter(
                        size: 10.5,
                        color: LoquitoTokens.ink,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.pets,
                          size: 12,
                          color: LoquitoTokens.catGreenDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatCount(post.likes + (liked ? 1 : 0)),
                          style: LoquitoTokens.typewriter(
                            size: 10.5,
                            color: LoquitoTokens.ink,
                            weight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.chat_bubble,
                          size: 11,
                          color: LoquitoTokens.inkSoft,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatCount(post.comments),
                          style: LoquitoTokens.typewriter(
                            size: 10.5,
                            color: LoquitoTokens.inkSoft,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // chincheta
            Positioned(
              top: -5,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: LoquitoTokens.string,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black26, width: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Miniatura: aún no hay imágenes de los videos, así que es un "negativo"
/// oscuro con el número de teoría y un botón de reproducir.
class _Thumb extends StatelessWidget {
  const _Thumb({required this.post, required this.liked});

  final VideoPost post;
  final bool liked;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2B2C26), Color(0xFF0E0D0B)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: Center(
                child: Icon(Icons.pets, size: 74, color: Color(0x14FFFFFF)),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            // número de teoría
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: LoquitoTokens.catGreen,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  post.tag,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            // si le diste like, aparece una huella verde
            if (liked)
              const Positioned(
                top: 5,
                right: 6,
                child: Icon(
                  Icons.pets,
                  size: 16,
                  color: LoquitoTokens.catGreen,
                ),
              ),
          ],
        ),
      ),
    );
  }
}