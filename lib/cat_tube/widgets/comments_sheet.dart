import 'package:flutter/material.dart';
import '../../design_tokens.dart';
import '../models/post_interaction.dart';
import '../models/video_post.dart';

/// Panel inferior con los comentarios de un video y un campo para escribir.
class CommentsSheet extends StatefulWidget {
  const CommentsSheet({
    super.key,
    required this.comments,
    required this.totalCount,
    required this.onSend,
  });

  final List<PostComment> comments;

  // Devuelve el total actual de comentarios del video + los que se agreguen
  final int Function() totalCount;

  //Se llama con el texto cuando el usuario envía un comentario
  final ValueChanged<String> onSend;

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _input.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Padding(
      // sube el panel cuando aparece el teclado
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        height: media.size.height * 0.62,
        decoration: const BoxDecoration(
          color: Color(0xFF1B1A17),
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${formatCount(widget.totalCount())} comentarios',
              style: LoquitoTokens.marker(size: 16, color: Colors.white),
            ),
            const Divider(color: Colors.white12, height: 20),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                itemCount: widget.comments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) => _CommentTile(comment: widget.comments[i]),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        style: LoquitoTokens.typewriter(
                          size: 13,
                          color: Colors.white,
                        ),
                        cursorColor: LoquitoTokens.catGreen,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: 'Agrega un comentario…',
                          hintStyle: LoquitoTokens.typewriter(
                            size: 13,
                            color: Colors.white38,
                          ),
                          filled: true,
                          fillColor: Colors.white10,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _send,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: LoquitoTokens.catGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final PostComment comment;

  static const _colors = [
    LoquitoTokens.catGreen,
    Color(0xFF3E5C8A),
    Color(0xFF8A6D3E),
    Color(0xFF7A5230),
    Color(0xFF3E6E63),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[comment.user.length % _colors.length];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color,
          child: const Icon(Icons.face, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment.user,
                    style: LoquitoTokens.typewriter(
                      size: 12,
                      color: Colors.white70,
                      weight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    comment.time,
                    style: LoquitoTokens.typewriter(
                      size: 10,
                      color: Colors.white30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                comment.text,
                style: LoquitoTokens.typewriter(
                  size: 13,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}