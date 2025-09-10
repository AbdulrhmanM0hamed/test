import 'package:flutter/material.dart';
import 'package:test/l10n/app_localizations.dart';

/// Extension method to easily access the localizations through the BuildContext
///
/// Example:
/// ```dart
/// Text(context.l10n.someText)
/// ```
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
