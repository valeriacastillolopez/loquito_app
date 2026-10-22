/// Un video del feed de CatTube, tal como lo devuelve la API.
class VideoPost {
  const VideoPost({
    required this.id,
    required this.username,
    required this.tag,
    required this.caption,
    required this.hashtags,
    required this.videoUrl,
    required this.likes,
    required this.comments,
    required this.shares,
  });

  final int id;
  final String username;
  final String tag;
  final String caption;
  final String hashtags;
  final String videoUrl;
  final int likes;
  final int comments;
  final int shares;

  factory VideoPost.fromJson(Map<String, dynamic> json) {
    return VideoPost(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String? ?? '@anonimo',
      tag: json['tag'] as String? ?? 'TEORÍA',
      caption: json['caption'] as String? ?? '',
      hashtags: json['hashtags'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      comments: (json['comments'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
    );
  }
}

/// 3400 -> "3.4K", 1200000 -> "1.2M", 812 -> "812"
String formatCount(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
  return '$n';
}