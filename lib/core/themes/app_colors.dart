// colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF005BB2);
  static const Color primaryVariant = Color(0xFF357ABD);
  static const Color secondary = Color(0xFF50E3C2);
  static const Color secondaryVariant = Color(0xFF3CBFA5);

  // Neutral palette
  static const Color background = Color(0xFFD5E3FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.black;
  static const Color onBackground = Colors.black87;
  static const Color onSurface = Colors.black87;

  static const Color navy = Color(0xFF0D1B2A);
  static const Color navyLight = Color(0xFF1A2E45);
  static const Color teal = Color(0xFF00B4A6);
  static const Color tealLight = Color(0xFFE0F7F5);
  static const Color amber = Color(
    0xFFFDA607,
  ); // Updated to requested vibrant orange/yellow
  static const Color canvas = Color(
    0xFFF8F8F8,
  ); // Updated to requested off-white
  static const Color textPrimary = Color(
    0xFF0D1C2E,
  ); // Updated to requested rich dark slate
  static const Color textSecondary = Color(
    0xFF717784,
  ); // Updated to requested neutral gray
  static const Color border = Color(
    0xFFE2E8F0,
  ); // Updated to requested border gray
  static const Color error = Color(
    0xFFFF3636,
  ); // Updated to requested vibrant red
  static const Color errorContainer = Color(0xFFBA1A1A);
  static const Color success = Color(
    0xFF17BDAA,
  ); // Updated to requested mint/teal green

  // Added background & utility colors from your list
  static const Color surfaceDark = Color(0xFF414753);
  static const Color warning = Color(0xFFFDAF22);
  static const Color warningDark = Color(0xFF674100);
  static const Color purpleAccent = Color(0xFFA91CFF);
  static const Color dividerGray = Color(0xFFE5E7EB);
  static const Color badgeOrange = Color(0xFFF8AD56);

  // Translucent / Opacity colors from your list
  static const Color shadowColor = Color(0xC1C6D533); // #C1C6D533
  static const Color clearWhite = Color(0xFFFFFF01); // #FFFFFF01
  static const Color primaryLightTranslucent = Color(0x0173DE1A); // #0173DE1A
  static const Color successTranslucent = Color(0x17BDAA4D); // #17BDAA4D
  static const Color successLightTranslucent = Color(0x17BDAA1A); // #17BDAA1A
  static const Color purpleTranslucent = Color(0xA91CFF4D); // #A91CFF4D
  static const Color purpleLightTranslucent = Color(0xA91CFF1A); // #A91CFF1A
  static const Color grayTranslucent = Color(0xC1C6D54D); // #C1C6D54D
  static const Color warningTranslucent = Color(0xFDA60733); // #FDA60733
  static const Color logOutIconColor = Color(0xFFD88992);
  static const Color onErrorContainer = Color(0xFFFFD2CE);
  static const Color whiteCc = Color(0xFFFFFFCC); // #FFFFFFCC
  static const Color white33 = Color(0xFFFFFF33); // #FFFFFF33

  // --- Cart Palette Additions ---
  static const Color slate = Color(0xFF414753); // Muted body text
  static const Color navyDark = Color(
    0xFF0D1C2E,
  ); // Selected chip background / Cart navy
  static const Color white = Color(0xFFFFFFFF);
  static const Color blueDark = Color(0xFF005BB2); // Pressed/darker blue
  static const Color blueTint = Color(0xFFEFF4FF); // Light blue surfaces
  static const Color ink = Color(0xFF0F172A); // Near-black headings
  static const Color amberAccent = Color(0xFFF8AD56); // Price / addon accent
  static const Color blue = Color(0xFF0173DE); // Primary action / links
  static const Color green = Color(0xFF14B51D); // Discount / success green
  static const Color black = Color(0xFF000000);
  static const Color blueAlpha20 = Color(0x330173DE); // Blue @ ~20% opacity
  static const Color grey = Color(0xFF6B7280); // Secondary labels
  static const Color greySubtle = Color(0xFF717784); // Captions / meta text
  static const Color blueLight = Color(0xFFD5E3FC); // Unselected chip bg
  static const Color cartCanvas = Color(
    0xFFF8F9FF,
  ); // Screen background override
}
