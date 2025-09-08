// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Fast & Reliable Delivery`
  String get fastDelivery {
    return Intl.message(
      'Fast & Reliable Delivery',
      name: 'fastDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Experience trust in fast and reliable delivery, ensuring your orders reach you promptly and in excellent condition.`
  String get fastDeliveryDesc {
    return Intl.message(
      'Experience trust in fast and reliable delivery, ensuring your orders reach you promptly and in excellent condition.',
      name: 'fastDeliveryDesc',
      desc: '',
      args: [],
    );
  }

  /// `High Quality Products`
  String get highQualityProducts {
    return Intl.message(
      'High Quality Products',
      name: 'highQualityProducts',
      desc: '',
      args: [],
    );
  }

  /// `We offer you the best high-quality products that have been carefully selected to meet your needs.`
  String get highQualityProductsDesc {
    return Intl.message(
      'We offer you the best high-quality products that have been carefully selected to meet your needs.',
      name: 'highQualityProductsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Easy Shopping Experience`
  String get easyShoppingExperience {
    return Intl.message(
      'Easy Shopping Experience',
      name: 'easyShoppingExperience',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy a smooth and easy shopping experience through a simple and user-friendly interface.`
  String get easyShoppingExperienceDesc {
    return Intl.message(
      'Enjoy a smooth and easy shopping experience through a simple and user-friendly interface.',
      name: 'easyShoppingExperienceDesc',
      desc: '',
      args: [],
    );
  }

  /// `Good Morning,`
  String get goodMorning {
    return Intl.message(
      'Good Morning,',
      name: 'goodMorning',
      desc: '',
      args: [],
    );
  }

  /// `Good Afternoon,`
  String get goodAfternoon {
    return Intl.message(
      'Good Afternoon,',
      name: 'goodAfternoon',
      desc: '',
      args: [],
    );
  }

  /// `Good Evening,`
  String get goodEvening {
    return Intl.message(
      'Good Evening,',
      name: 'goodEvening',
      desc: '',
      args: [],
    );
  }

  /// `Change Location`
  String get changeLocation {
    return Intl.message(
      'Change Location',
      name: 'changeLocation',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorite {
    return Intl.message(
      'Favorites',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Username or Email`
  String get email {
    return Intl.message(
      'Username or Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get writePassword {
    return Intl.message(
      'Enter password',
      name: 'writePassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter username`
  String get writeUsername {
    return Intl.message(
      'Enter username',
      name: 'writeUsername',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Re-enter password`
  String get rewritePassword {
    return Intl.message(
      'Re-enter password',
      name: 'rewritePassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get ensurePassword {
    return Intl.message(
      'Confirm password',
      name: 'ensurePassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter username or email`
  String get writeEmail {
    return Intl.message(
      'Enter username or email',
      name: 'writeEmail',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Or sign in with`
  String get or {
    return Intl.message(
      'Or sign in with',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `I agree to the terms, conditions and privacy policy`
  String get Iagree {
    return Intl.message(
      'I agree to the terms, conditions and privacy policy',
      name: 'Iagree',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully`
  String get signupSuccess {
    return Intl.message(
      'Account created successfully',
      name: 'signupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get haveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Login now`
  String get loginNow {
    return Intl.message(
      'Login now',
      name: 'loginNow',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcomeBack {
    return Intl.message(
      'Welcome back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `We've missed you! Welcome back`
  String get welcomeBackDesc {
    return Intl.message(
      'We\'ve missed you! Welcome back',
      name: 'welcomeBackDesc',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Dakakein, create your account now`
  String get welcomeIn {
    return Intl.message(
      'Welcome to Dakakein, create your account now',
      name: 'welcomeIn',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAll {
    return Intl.message(
      'See All',
      name: 'seeAll',
      desc: '',
      args: [],
    );
  }

  /// `Search for...`
  String get searchHint {
    return Intl.message(
      'Search for...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
