import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const Color primary = Color(0xFFDCA278);    // Marrón cálido - Color principal/acento
  static const Color background = Color(0xFFFFF9E2);  // Beige muy claro - Fondo principal
  static const Color surface = Color(0xFFFEECD0);     // Beige claro - Fondo de tarjetas
  static const Color border = Color(0xFFCDD4B1);      // Verde suave - Bordes y elementos secundarios
  static const Color secondary = Color(0xFFEBECCC);   // Verde muy claro - Elementos interactivos

  // Variaciones de transparencia para efectos
  static Color primaryLight = primary.withOpacity(0.7);
  static Color surfaceLight = surface.withOpacity(0.7);
  static Color borderLight = border.withOpacity(0.5);

  // Estados
  static const Color success = Color(0xFF9BAA6E);     // Verde oscuro para éxito
  static const Color error = Color(0xFFD98D6B);       // Rojo suave para errores
  
  // Texto
  static const Color textDark = Color(0xFF4A4A4A);    // Texto principal
  static const Color textLight = Color(0xFFFFF9E2);   // Texto sobre fondos oscuros
  
  // Gradientes
  static const List<Color> primaryGradient = [
    Color(0xFFDCA278),
    Color(0xFFEBECCC),
  ];
  
  static const List<Color> backgroundGradient = [
    Color(0xFFFFF9E2),
    Color(0xFFFEECD0),
  ];
}