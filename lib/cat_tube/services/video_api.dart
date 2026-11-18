import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/cat_tube_user.dart';
import '../models/post_interaction.dart';
import '../models/video_post.dart';

class VideoApi {
  // true = teléfono real false = emulador
  static const bool telefonoReal = false;

  // ver IP con ipconfig
  static const String ipDeMiPc = '10.1.124.203';

  static String get baseUrl {
    if (telefonoReal) return 'http://$ipDeMiPc:8080';
    final esAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    return esAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080';
  }

  static const Duration _timeout = Duration(seconds: 10);

  Future<dynamic> _get(String path) async {
    final response = await http.get(Uri.parse('$baseUrl$path')).timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('La API respondió ${response.statusCode} en $path');
    }
    return jsonDecode(utf8.decode(response.bodyBytes));
  }

  // ---------------------------------------------------------------- lectura
  Future<CatTubeUser> fetchUser(int idUsuario) async {
    final data = await _get('/api/usuarios/$idUsuario');
    return CatTubeUser.fromJson(data as Map<String, dynamic>);
  }

  Future<List<CatTubeUser>> fetchUsers() async {
    final data = await _get('/api/usuarios') as List<dynamic>;
    return data
        .map((e) => CatTubeUser.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<VideoPost>> fetchVideos(int idUsuario) async {
    final data = await _get('/api/usuarios/$idUsuario/videos') as List<dynamic>;
    return data
        .map((e) => VideoPost.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PostComment>> fetchComments(int idVideo) async {
    final data = await _get('/api/videos/$idVideo/comentarios') as List<dynamic>;
    return data
        .map((e) => _commentFromJson(e as Map<String, dynamic>))
        .toList();
  }

  // -------------------------------------------------------------- escritura
  Future<void> saveLike(int idUsuario, int idVideo, bool liked) async {
    final response = await http
        .put(Uri.parse(
        '$baseUrl/api/usuarios/$idUsuario/videos/$idVideo/like?liked=$liked'))
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('La API respondió ${response.statusCode} al guardar el like');
    }
  }

  Future<PostComment> postComment(int idUsuario, int idVideo, String texto) async {
    final response = await http
        .post(
      Uri.parse('$baseUrl/api/videos/$idVideo/comentarios'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
      body: jsonEncode({'idUsuario': idUsuario, 'texto': texto}),
    )
        .timeout(_timeout);
    if (response.statusCode != 200) {
      throw Exception('La API respondió ${response.statusCode} al comentar');
    }
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return _commentFromJson(data);
  }

  PostComment _commentFromJson(Map<String, dynamic> j) => PostComment(
    user: j['username'] as String? ?? 'anónimo',
    text: j['texto'] as String? ?? '',
    time: '',
  );
}