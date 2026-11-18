import 'package:flutter/material.dart';
import '../../design_tokens.dart';
import '../models/cat_tube_user.dart';
import '../models/video_post.dart';
import '../services/video_api.dart';

/// Panel para cambiar de usuario, como el selector de cuentas de Instagram.
/// Al elegir uno se cierra y devuelve el [CatTubeUser] elegido.
class UserSwitcherSheet extends StatefulWidget {
  const UserSwitcherSheet({super.key, required this.currentId});

  /// Usuario activo, para marcarlo con el check.
  final int currentId;

  @override
  State<UserSwitcherSheet> createState() => _UserSwitcherSheetState();
}

class _UserSwitcherSheetState extends State<UserSwitcherSheet> {
  late Future<List<CatTubeUser>> _future = VideoApi().fetchUsers();

  void _retry() {
    setState(() => _future = VideoApi().fetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.6;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Color(0xFF1B1A17),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 14),
            Text(
              'CAMBIAR DE USUARIO',
              style: LoquitoTokens.marker(size: 16, color: Colors.white),
            ),
            const SizedBox(height: 2),
            Text(
              'Cambian el perfil, los videos y los likes.',
              style: LoquitoTokens.typewriter(size: 11, color: Colors.white38),
            ),
            const Divider(color: Colors.white12, height: 22),
            Flexible(
              child: FutureBuilder<List<CatTubeUser>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(
                        color: LoquitoTokens.catGreen,
                      ),
                    );
                  }
                  if (snap.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No se pudieron cargar los usuarios.',
                            textAlign: TextAlign.center,
                            style: LoquitoTokens.typewriter(
                              size: 13,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: _retry,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: LoquitoTokens.catGreen,
                              side: const BorderSide(
                                color: LoquitoTokens.catGreen,
                              ),
                            ),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  final users = snap.data ?? [];
                  if (users.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No hay usuarios en la base.',
                        style: LoquitoTokens.typewriter(
                          size: 13,
                          color: Colors.white54,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    itemCount: users.length,
                    itemBuilder: (context, i) => _UserRow(
                      user: users[i],
                      isCurrent: users[i].id == widget.currentId,
                      onTap: () => Navigator.of(context).pop(users[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.user,
    required this.isCurrent,
    required this.onTap,
  });

  final CatTubeUser user;
  final bool isCurrent;
  final VoidCallback onTap;

  static const _colors = [
    LoquitoTokens.catGreen,
    Color(0xFF3E5C8A),
    Color(0xFF8A6D3E),
    Color(0xFF7A5230),
    Color(0xFF3E6E63),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[user.id % _colors.length];
    final name = user.username.replaceAll('@', '').trim();
    final letter = name.isEmpty ? '?' : name[0].toUpperCase();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(
                  color: isCurrent ? Colors.white : Colors.transparent,
                  width: 2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                letter,
                style: LoquitoTokens.marker(size: 20, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: LoquitoTokens.typewriter(
                      size: 14,
                      color: Colors.white,
                      weight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${formatCount(user.seguidores)} seguidores',
                    style: LoquitoTokens.typewriter(
                      size: 11,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isCurrent ? Icons.check_circle : Icons.circle_outlined,
              color: isCurrent ? LoquitoTokens.catGreen : Colors.white24,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}