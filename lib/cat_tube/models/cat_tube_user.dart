/// Usuario de cattube como lo devuelve la API
class CatTubeUser {
  const CatTubeUser({
    required this.id,
    required this.username,
    required this.seguidores,
  });

  final int id;
  final String username;
  final int seguidores;

  factory CatTubeUser.fromJson(Map<String, dynamic> json) {
    return CatTubeUser(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String? ?? 'usuario',
      seguidores: (json['seguidores'] as num?)?.toInt() ?? 0,
    );
  }

  /// @ en los nombres
  String get handle {
    final u = username.trim();
    if (u.startsWith('@')) return u;
    return '@${u.toLowerCase().replaceAll(RegExp(r'\s+'), '_')}';
  }
}