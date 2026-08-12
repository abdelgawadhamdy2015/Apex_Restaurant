import 'dart:developer';

class SizeHelper {
  static double? _width;
  static double? _height;
  static bool _isMobile = true;
  static double? get width => _width;
  static double? get height => _height;
  static bool get isMobile => _isMobile;
  static void init({double? width, double? height}) {
    if (_width != null || _height != null) return;

    _width = width;
    _height = height;
    if (width! > 600) {
      _isMobile = false;
    }
    log("$width , $height , $isMobile");
  }
}
