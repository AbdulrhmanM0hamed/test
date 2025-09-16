import 'package:flutter/material.dart';
import 'package:test/l10n/app_localizations.dart';

class FormValidators {
  // Private constructor to prevent instantiation
  FormValidators._();

  /// Validates email address format and requirements
  static String? validateEmail(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.enterValidEmail;
    }

    final cleanValue = value.trim();

    // Check email format with comprehensive regex
    if (!_isValidEmailFormat(cleanValue)) {
      return l10n.enterValidEmail;
    }

    // Check reasonable length
    if (cleanValue.length > _ValidationConstants.maxEmailLength) {
      return l10n.enterValidEmail;
    }

    return null;
  }

  /// Validates password strength and requirements
  static String? validatePassword(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseEnterPassword;
    }

    final cleanValue = value.trim();

    if (cleanValue.length < _ValidationConstants.minPasswordLength) {
      return l10n.passwordTooShortMin8;
    }

    if (cleanValue.length > _ValidationConstants.maxPasswordLength) {
      return l10n.passwordTooLongMax50;
    }

    // Check password requirements (backend requires all 4 components)
    if (!cleanValue.contains(RegExp(r'[A-Z]'))) {
      return l10n.passwordMustContainUppercase;
    }

    if (!cleanValue.contains(RegExp(r'[a-z]'))) {
      return l10n.passwordMustContainLowercase;
    }

    if (!cleanValue.contains(RegExp(r'[0-9]'))) {
      return l10n.passwordMustContainNumber;
    }

    return null;
  }

  /// Validates password confirmation
  static String? validatePasswordConfirmation(
    String? value,
    String? originalPassword,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseConfirmPassword;
    }

    if (value.trim() != originalPassword?.trim()) {
      return l10n.passwordsDoNotMatch;
    }

    return null;
  }

  /// Validates full name
  static String? validateFullName(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseEnterFullName;
    }

    final cleanValue = value.trim();

    if (cleanValue.length < _ValidationConstants.minNameLength) {
      return l10n.nameTooShort;
    }

    if (cleanValue.length > _ValidationConstants.maxNameLength) {
      return l10n.nameTooLong;
    }

    // Check if name contains only valid characters
    if (!_isValidNameFormat(cleanValue)) {
      return l10n.invalidNameFormat;
    }

    return null;
  }

  /// Validates phone number
  static String? validatePhoneNumber(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.pleaseEnterPhoneNumber;
    }

    final cleanValue = value.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (!_isValidPhoneFormat(cleanValue)) {
      return l10n.invalidPhoneNumber;
    }

    return null;
  }

  // Private helper methods
  static bool _isValidEmailFormat(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      caseSensitive: false,
    ).hasMatch(email);
  }

  static bool _isValidNameFormat(String name) {
    return RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(name);
  }

  static bool _isValidPhoneFormat(String phone) {
    return RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(phone);
  }

  // static int _calculatePasswordStrength(String password) {
  //   int strength = 0;

  //   if (password.contains(RegExp(r'[A-Z]'))) strength++;
  //   if (password.contains(RegExp(r'[a-z]'))) strength++;
  //   if (password.contains(RegExp(r'[0-9]'))) strength++;
  //   if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

  //   return strength;
  // }
}

/// Constants for validation rules
class _ValidationConstants {
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const int maxEmailLength = 125;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
}
