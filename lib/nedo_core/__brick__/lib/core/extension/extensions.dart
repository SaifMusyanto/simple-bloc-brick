import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

extension MediaQueryContextExtension on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
}

extension LocalizationExtension on BuildContext {
  AppLocalizations? get appLocalizations => AppLocalizations.of(this);
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
}
