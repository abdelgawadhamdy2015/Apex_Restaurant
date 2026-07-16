enum AppFontScale {
  small(0.85, 'صغير'),
  medium(1.0, 'متوسط'),
  large(1.15, 'كبير'),
  extraLarge(1.3, 'كبير جداً');

  const AppFontScale(this.scale, this.label);
  final double scale;
  final String label;
}
