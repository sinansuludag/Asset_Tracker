import 'package:flutter/material.dart';

class MediaQuerySize {
  late final BuildContext _buildContext;

  MediaQuerySize(BuildContext context) {
    _buildContext = context;
  }

  // Ekran genişliği
  double get screenWidth => MediaQuery.of(_buildContext).size.width;

  // Ekran yüksekliği
  double get screenHeight => MediaQuery.of(_buildContext).size.height;

  /// size-> %1
  double get percent1Width => screenWidth * 0.01;

  /// size-> %1
  double get percent1Height => screenHeight * 0.01;

  /// size-> %2
  double get percent2Width => screenWidth * 0.02;

  /// size-> %2
  double get percent2Height => screenHeight * 0.02;

  /// size-> %4
  double get percent4Width => screenWidth * 0.04;

  /// size-> %4
  double get percent4Height => screenHeight * 0.04;

  /// size-> %5
  double get percent5Width => screenWidth * 0.05;

  /// size-> %5
  double get percent5Height => screenHeight * 0.05;

  /// size-> %10
  double get percent10Width => screenWidth * 0.10;

  /// size-> %10
  double get percent10Height => screenHeight * 0.10;

  /// size-> %20
  double get percent20Width => screenWidth * 0.20;

  /// size-> %20
  double get percent20Height => screenHeight * 0.20;

  /// size-> %30
  double get percent30Width => screenWidth * 0.30;

  /// size-> %30
  double get percent30Height => screenHeight * 0.30;
}
