import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/video_post.dart';

// Cliente de la API de Spring Boot.
class VideoApi {
  // true = teléfono real (usa la IP de la PC); false = emulador o Windows.
  static const bool telefonoReal = true;

  // IP de la pc comando ipconfig
  static const String ipDeMiPc = '10.1.124.203';

  static String get baseUrl {
    if (telefonoReal) return 'http://$ipDeMiPc:8080';
    final esAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    return esAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080';
  }

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