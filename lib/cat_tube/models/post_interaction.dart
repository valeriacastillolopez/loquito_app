class PostComment {
  const PostComment({
    required this.user,
    required this.text,
    required this.time,
  });

  final String user;
  final String text;
  final String time;
}

class PostInteraction {
  PostInteraction({this.liked = false});

  /// Arranca con el valor que trae la base
  bool liked;
  int shares = 0;
  int addedComments = 0;

  /// true cuando ya se descargaron los comentarios de este video
  bool commentsLoaded = false;
  final List<PostComment> comments = [];
}