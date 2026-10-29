// Un comentario del feed
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

// Comentarios de ejemplo, cada video arranca rotados distinto según su id para que no todos muestren la misma lista
List<PostComment> sampleComments(int seed) {
  const base = [
    PostComment(
      user: '@vecina_del_4to',
      text: 'Yo también vi a la paloma mirándome. No estás loco.',
      time: 'hace 2 h',
    ),
    PostComment(
      user: '@don_chuy_mercado',
      text: 'Mi cuñado dice que eso es propaganda, pero yo ya no sé.',
      time: 'hace 3 h',
    ),
    PostComment(
      user: '@esceptico_01',
      text: 'Eso es un dron de juguete, ya déjenlo en paz.',
      time: 'hace 5 h',
    ),
    PostComment(
      user: '@testigo_nocturno',
      text: 'El semáforo parpadea distinto a las 3 am. Lo grabé.',
      time: 'hace 1 d',
    ),
    PostComment(
      user: '@la_comadre_tv',
      text: 'Compartido en el grupo del barrio.',
      time: 'hace 1 d',
    ),
    PostComment(
      user: '@sin_senal',
      text: 'Cuenten los cables, tiene razón.',
      time: 'hace 2 d',
    ),
  ];

  final shift = seed % base.length;
  return [...base.sublist(shift), ...base.sublist(0, shift)].take(5).toList();
}

// Lo que el usuario ha hecho con un video se guarda aparte de la tarjeta para que no se pierda al deslizar
class PostInteraction {
  PostInteraction(int seed) : comments = sampleComments(seed);

  bool liked = false;
  int shares = 0;
  int addedComments = 0;
  final List<PostComment> comments;
}