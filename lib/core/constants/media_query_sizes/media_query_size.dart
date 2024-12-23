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

  /// size-> %1,5
  double get percent1_5Width => screenWidth * 0.015;

  /// size-> %1,5
  double get percent1_5Height => screenHeight * 0.015;

  /// size-> %2
  double get percent2Width => screenWidth * 0.02;

  /// size-> %2
  double get percent2Height => screenHeight * 0.02;

  /// size-> %3
  double get percent3Width => screenWidth * 0.03;

  /// size-> %3
  double get percent3Height => screenHeight * 0.03;

  /// size-> %4
  double get percent4Width => screenWidth * 0.04;

  /// size-> %4
  double get percent4Height => screenHeight * 0.04;

  /// size-> %5
  double get percent5Width => screenWidth * 0.05;

  /// size-> %5
  double get percent5Height => screenHeight * 0.05;

  /// size-> %6
  double get percent6Width => screenWidth * 0.06;

  /// size-> %6
  double get percent6Height => screenHeight * 0.06;

  /// size-> %7
  double get percent7Width => screenWidth * 0.07;

  /// size-> %7
  double get percent7Height => screenHeight * 0.07;

  /// size-> %8
  double get percent8Width => screenWidth * 0.08;

  /// size-> %8
  double get percent8Height => screenHeight * 0.08;

  /// size-> %9
  double get percent9Width => screenWidth * 0.09;

  /// size-> %9
  double get percent9Height => screenHeight * 0.09;

  /// size-> %10
  double get percent10Width => screenWidth * 0.10;

  /// size-> %10
  double get percent10Height => screenHeight * 0.10;

  /// size-> %12
  double get percent12Width => screenWidth * 0.12;

  /// size-> %10
  double get percent12Height => screenHeight * 0.12;

  /// size-> %15
  double get percent15Width => screenWidth * 0.15;

  /// size-> %10
  double get percent15Height => screenHeight * 0.15;

  /// size-> %20
  double get percent20Width => screenWidth * 0.20;

  /// size-> %20
  double get percent20Height => screenHeight * 0.20;

  /// size-> %30
  double get percent30Width => screenWidth * 0.30;

  /// size-> %30
  double get percent30Height => screenHeight * 0.30;

  /// size-> %35
  double get percent35Width => screenWidth * 0.35;

  /// size-> %30
  double get percent35Height => screenHeight * 0.35;

  /// size-> %40
  double get percent40Width => screenWidth * 0.40;

  /// size-> %40
  double get percent40Height => screenHeight * 0.40;

  /// size-> %50
  double get percent50Width => screenWidth * 0.50;

  /// size-> %50
  double get percent50Height => screenHeight * 0.50;

  /// size-> %60
  double get percent60Width => screenWidth * 0.60;

  /// size-> %60
  double get percent60Height => screenHeight * 0.60;

  /// size-> %70
  double get percent70Width => screenWidth * 0.70;

  /// size-> %60
  double get percent70Height => screenHeight * 0.70;

  /// size-> %80
  double get percent80Width => screenWidth * 0.80;

  /// size-> %60
  double get percent80Height => screenHeight * 0.80;
}
