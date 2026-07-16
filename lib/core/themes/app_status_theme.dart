import 'package:flutter/material.dart';

@immutable
class AppStatusTheme extends ThemeExtension<AppStatusTheme> {
  final Color registrationOpen;
  final Color groupStage;
  final Color knockoutStage;
  final Color completed;
  final Color fallback;

  const AppStatusTheme({
    required this.registrationOpen,
    required this.groupStage,
    required this.knockoutStage,
    required this.completed,
    required this.fallback,
  });

  @override
  AppStatusTheme copyWith({
    Color? registrationOpen,
    Color? groupStage,
    Color? knockoutStage,
    Color? completed,
    Color? fallback,
  }) {
    return AppStatusTheme(
      registrationOpen: registrationOpen ?? this.registrationOpen,
      groupStage: groupStage ?? this.groupStage,
      knockoutStage: knockoutStage ?? this.knockoutStage,
      completed: completed ?? this.completed,
      fallback: fallback ?? this.fallback,
    );
  }

  @override
  AppStatusTheme lerp(ThemeExtension<AppStatusTheme>? other, double t) {
    if (other is! AppStatusTheme) return this;

    return AppStatusTheme(
      registrationOpen: Color.lerp(
        registrationOpen,
        other.registrationOpen,
        t,
      )!,
      groupStage: Color.lerp(groupStage, other.groupStage, t)!,
      knockoutStage: Color.lerp(knockoutStage, other.knockoutStage, t)!,
      completed: Color.lerp(completed, other.completed, t)!,
      fallback: Color.lerp(fallback, other.fallback, t)!,
    );
  }
}
