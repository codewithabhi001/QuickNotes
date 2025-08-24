import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return FlexThemeData.light(
      scheme: FlexScheme.indigo,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 20,
      appBarStyle: FlexAppBarStyle.primary,
      subThemesData: const FlexSubThemesData(
        useMaterial3Typography: true,
        useM2StyleDividerInM3: true,
        defaultRadius: 12.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        inputDecoratorRadius: 12.0,
        inputDecoratorFocusedBorderWidth: 1.0,
        inputDecoratorUnfocusedHasBorder: true,
        cardRadius: 12.0,
      ),
      keyColors: const FlexKeyColors(useSecondary: true, useTertiary: true),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
    );
  }

  static ThemeData get darkTheme {
    return FlexThemeData.dark(
      scheme: FlexScheme.indigoM3,
      surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      blendLevel: 1,
      appBarStyle: FlexAppBarStyle.background,
      subThemesData: const FlexSubThemesData(
        useMaterial3Typography: true,
        useM2StyleDividerInM3: true,
        defaultRadius: 12.0,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        inputDecoratorRadius: 12.0,
        inputDecoratorFocusedBorderWidth: 1.0,
        inputDecoratorUnfocusedHasBorder: true,
        cardRadius: 12.0,
      ),
      keyColors: const FlexKeyColors(useSecondary: true, useTertiary: true),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
    );
  }
}
