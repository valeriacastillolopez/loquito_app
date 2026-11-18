class VideoPost {
  const VideoPost({
    required this.id,
    required this.titulo,
    required this.username,
    required this.tag,
    required this.caption,
    required this.hashtags,
    required this.videoUrl,
    required this.likes,
    required this.vistas,
    required this.comments,
    required this.shares,
    required this.liked,
  });

  final int id; // id_video = número de teoría
  final String titulo; // nombre de la teoría
  final String username;
  final String tag;
  final String caption;
  final String hashtags;
  final String videoUrl;
  final int likes; // likes del catálogo + likes automáticos
  final int vistas;
  final int comments; // cantidad, no el texto
  final int shares;

  /// Si el usuario activo ya le había dado like (viene de la base)
  final bool liked;

  factory VideoPost.fromJson(Map<String, dynamic> json) {
    return VideoPost(
      id: (json['id'] as num).toInt(),
      titulo: json['titulo'] as String? ?? '',
      username: json['username'] as String? ?? '@anonimo',
      tag: json['tag'] as String? ?? 'TEORÍA',
      caption: json['caption'] as String? ?? '',
      hashtags: json['hashtags'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      vistas: (json['vistas'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      liked: json['liked'] as bool? ?? false,
    );
  }
}

String formatCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
  return '$n';
}