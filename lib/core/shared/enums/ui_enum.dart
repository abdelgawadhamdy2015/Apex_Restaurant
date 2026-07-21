// lib/core/shared/enums/ui_enum.dart

/// Controls the app's overall density: spacing between items, card
/// padding, and corner radii (see AppSpacing.build).
enum AppUiScale {
    compact(0.85, 'مضغوط'),
        regular(1.0, 'عادي'),
        relaxed(1.15, 'واسع');

const AppUiScale(this.scale, this.label);
  final double scale;
  final String label;
}

/// Controls icon sizes app-wide (see AppIconSizes.build).
enum AppIconScale {
    small(0.85, 'صغير'),
        medium(1.0, 'متوسط'),
        large(1.2, 'كبير');

const AppIconScale(this.scale, this.label);
  final double scale;
  final String label;
}