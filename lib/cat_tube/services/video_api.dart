import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video_post.dart';

/// Cliente de la API de Spring Boot.
class VideoApi {
  /// 10.0.2.2 es como el emulador de Android llama a tu computadora.
  /// En un celular real, cámbialo por la IP de tu PC (ej. 192.168.1.50).
  static const String baseUrl = 'http://10.0.2.2:8080';

  Future<List<VideoPost>> fetchVideos() async {
    final response = await http
        .get(Uri.parse('$baseUrl/api/videos'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('La API respondió ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data
        .map((e) => VideoPost.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}