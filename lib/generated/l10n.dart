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

  /// `Best Sellers`
  String get bestSellers {
    return Intl.message(
      'Best Sellers',
      name: 'bestSellers',
      desc: '',
      args: [],
    );
  }

  /// `Featured Products`
  String get featuredProducts {
    return Intl.message(
      'Featured Products',
      name: 'featuredProducts',
      desc: '',
      args: [],
    );
  }

  /// `Latest Products`
  String get latestProducts {
    return Intl.message(
      'Latest Products',
      name: 'latestProducts',
      desc: '',
      args: [],
    );
  }

  /// `Special Offers`
  String get specialOffers {
    return Intl.message(
      'Special Offers',
      name: 'specialOffers',
      desc: '',
      args: [],
    );
  }

  /// `Show More`
  String get showMore {
    return Intl.message('Show More', name: 'showMore', desc: '', args: []);
  }

  /// `Products`
  String get products {
    return Intl.message('Products', name: 'products', desc: '', args: []);
  }

  /// `Search for products...`
  String get searchProducts {
    return Intl.message(
      'Search for products...',
      name: 'searchProducts',
      desc: '',
      args: [],
    );
  }

  /// `No products in this category`
  String get noProductsInCategory {
    return Intl.message(
      'No products in this category',
      name: 'noProductsInCategory',
      desc: '',
      args: [],
    );
  }

  /// `Select a category to view products`
  String get selectCategoryToView {
    return Intl.message(
      'Select a category to view products',
      name: 'selectCategoryToView',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Error loading best selling products`
  String get errorLoadingBestSellers {
    return Intl.message(
      'Error loading best selling products',
      name: 'errorLoadingBestSellers',
      desc: '',
      args: [],
    );
  }

  /// `Error loading featured products`
  String get errorLoadingFeatured {
    return Intl.message(
      'Error loading featured products',
      name: 'errorLoadingFeatured',
      desc: '',
      args: [],
    );
  }

  /// `Error loading latest products`
  String get errorLoadingLatest {
    return Intl.message(
      'Error loading latest products',
      name: 'errorLoadingLatest',
      desc: '',
      args: [],
    );
  }

  /// `Error loading special offers`
  String get errorLoadingSpecialOffers {
    return Intl.message(
      'Error loading special offers',
      name: 'errorLoadingSpecialOffers',
      desc: '',
      args: [],
    );
  }

  /// `No best selling products available`
  String get noBestSellersAvailable {
    return Intl.message(
      'No best selling products available',
      name: 'noBestSellersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No featured products available`
  String get noFeaturedAvailable {
    return Intl.message(
      'No featured products available',
      name: 'noFeaturedAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No new products available`
  String get noLatestAvailable {
    return Intl.message(
      'No new products available',
      name: 'noLatestAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No special offers available`
  String get noSpecialOffersAvailable {
    return Intl.message(
      'No special offers available',
      name: 'noSpecialOffersAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Data updated successfully`
  String get dataUpdatedSuccessfully {
    return Intl.message(
      'Data updated successfully',
      name: 'dataUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Member since`
  String get memberSince {
    return Intl.message(
      'Member since',
      name: 'memberSince',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `Inactive`
  String get inactive {
    return Intl.message('Inactive', name: 'inactive', desc: '', args: []);
  }

  /// `Verification`
  String get verification {
    return Intl.message(
      'Verification',
      name: 'verification',
      desc: '',
      args: [],
    );
  }

  /// `Verified`
  String get verified {
    return Intl.message('Verified', name: 'verified', desc: '', args: []);
  }

  /// `Not verified`
  String get notVerified {
    return Intl.message(
      'Not verified',
      name: 'notVerified',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get birthDate {
    return Intl.message('Birth Date', name: 'birthDate', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Location Information`
  String get locationInformation {
    return Intl.message(
      'Location Information',
      name: 'locationInformation',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Region`
  String get region {
    return Intl.message('Region', name: 'region', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get accountSettings {
    return Intl.message(
      'Account Settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `Security and Privacy`
  String get securityAndPrivacy {
    return Intl.message(
      'Security and Privacy',
      name: 'securityAndPrivacy',
      desc: '',
      args: [],
    );
  }

  /// `Help and Support`
  String get helpAndSupport {
    return Intl.message(
      'Help and Support',
      name: 'helpAndSupport',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Error loading data`
  String get errorLoadingData {
    return Intl.message(
      'Error loading data',
      name: 'errorLoadingData',
      desc: '',
      args: [],
    );
  }

  /// `Not specified`
  String get notSpecified {
    return Intl.message(
      'Not specified',
      name: 'notSpecified',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Image change feature coming soon`
  String get imageChangeFeatureComingSoon {
    return Intl.message(
      'Image change feature coming soon',
      name: 'imageChangeFeatureComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Edit feature coming soon`
  String get editFeatureComingSoon {
    return Intl.message(
      'Edit feature coming soon',
      name: 'editFeatureComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Date picker feature coming soon`
  String get datePickerFeatureComingSoon {
    return Intl.message(
      'Date picker feature coming soon',
      name: 'datePickerFeatureComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Gender picker feature coming soon`
  String get genderPickerFeatureComingSoon {
    return Intl.message(
      'Gender picker feature coming soon',
      name: 'genderPickerFeatureComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile feature coming soon`
  String get editProfileFeatureComingSoon {
    return Intl.message(
      'Edit profile feature coming soon',
      name: 'editProfileFeatureComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Account settings coming soon`
  String get accountSettingsComingSoon {
    return Intl.message(
      'Account settings coming soon',
      name: 'accountSettingsComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Security settings coming soon`
  String get securitySettingsComingSoon {
    return Intl.message(
      'Security settings coming soon',
      name: 'securitySettingsComingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Help center coming soon`
  String get helpCenterComingSoon {
    return Intl.message(
      'Help center coming soon',
      name: 'helpCenterComingSoon',
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
