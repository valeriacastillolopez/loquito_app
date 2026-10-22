import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sistema de diseño de la maqueta.
///
/// Todo el look & feel (colores, tipografías, radios) vive aquí para que
/// las pantallas solo compongan widgets sin repetir valores mágicos.
class LoquitoTokens {
  LoquitoTokens._();

  // ---------------------------------------------------------------- color
  static const Color paper = Color(0xFFECE5D3); // papel envejecido
  static const Color paperDark = Color(0xFFDCD2B6);
  static const Color ink = Color(0xFF201C16); // tinta / texto principal
  static const Color inkSoft = Color(0xFF4A443A);
  static const Color cork = Color(0xFF8B6F47); // corcho del fondo
  static const Color corkDark = Color(0xFF6B5335);
  static const Color string = Color(0xFFB23A2E); // hilo rojo de teorías
  static const Color catGreen = Color(0xFF6E8B3E); // verde tóxico CatTube
  static const Color catGreenDark = Color(0xFF44581F);
  static const Color warning = Color(0xFFD9A441); // amarillo advertencia
  static const Color screenBlack = Color(0xFF111014);

  // ------------------------------------------------------------- tipos
  static TextStyle typewriter({
    double size = 14,
    Color color = ink,
    FontWeight weight = FontWeight.w400,
    double? height,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.specialElite(
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle marker({
    double size = 20,
    Color color = ink,
    double? height,
  }) {
    return GoogleFonts.permanentMarker(
      fontSize: size,
      color: color,
      height: height,
    );
  }

  // ------------------------------------------------------------- forma
  static const double phoneCorner = 46;
  static const double cardCorner = 14;
}