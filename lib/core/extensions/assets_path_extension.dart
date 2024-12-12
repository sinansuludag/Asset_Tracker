extension AssetPaths on String {
  static const _pngPath = "assets/png/";
  static const _svgPath = "assets/svg/";

  String get png => "$_pngPath$this.png";
  String get svg => "$_svgPath$this.svg";
}
