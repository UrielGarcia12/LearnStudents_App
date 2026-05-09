// ui/responsive.dart
import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class Responsive {
  static DeviceType getType(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return DeviceType.desktop;
    if (w >= 600)  return DeviceType.tablet;
    return DeviceType.mobile;
  }

  static bool isMobile(BuildContext context) =>
      getType(context) == DeviceType.mobile;
  static bool isTablet(BuildContext context) =>
      getType(context) == DeviceType.tablet;
  static bool isDesktop(BuildContext context) =>
      getType(context) == DeviceType.desktop;

  /// Ancho máximo del contenido del login
  static double contentWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return 440.0;
    if (w >= 600)  return 520.0;
    return w;
  }

  /// Altura del banner header
  static double headerHeight(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return 240.0;
    if (w >= 600)  return 220.0;
    return 200.0;
  }

  /// Tamaño del avatar
  static double avatarSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return 130.0;
    if (w >= 600)  return 120.0;
    return 110.0;
  }

  /// Tamaño del logo en el banner
  static double logoWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return 200.0;
    if (w >= 600)  return 180.0;
    return 155.0;
  }

  /// Tamaño del logo en splash
  static double splashLogoWidth(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return 320.0;
    if (w >= 600)  return 280.0;
    return 240.0;
  }

  /// Padding horizontal del contenido
  static double hPad(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return 40.0;
    if (w >= 600)  return 36.0;
    return 28.0;
  }

  /// Título principal del login
  static double titleSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w >= 1024) return 30.0;
    if (w >= 600)  return 28.0;
    return 24.0;
  }
}