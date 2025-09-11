import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @fastDelivery.
  ///
  /// In en, this message translates to:
  /// **'Fast & Reliable Delivery'**
  String get fastDelivery;

  /// No description provided for @fastDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Experience trust in fast and reliable delivery, ensuring your orders reach you promptly and in excellent condition.'**
  String get fastDeliveryDesc;

  /// No description provided for @highQualityProducts.
  ///
  /// In en, this message translates to:
  /// **'High Quality Products'**
  String get highQualityProducts;

  /// No description provided for @highQualityProductsDesc.
  ///
  /// In en, this message translates to:
  /// **'We offer you the best high-quality products that have been carefully selected to meet your needs.'**
  String get highQualityProductsDesc;

  /// No description provided for @easyShoppingExperience.
  ///
  /// In en, this message translates to:
  /// **'Easy Shopping Experience'**
  String get easyShoppingExperience;

  /// No description provided for @easyShoppingExperienceDesc.
  ///
  /// In en, this message translates to:
  /// **'Enjoy a smooth and easy shopping experience through a simple and user-friendly interface.'**
  String get easyShoppingExperienceDesc;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening,'**
  String get goodEvening;

  /// No description provided for @changeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get changeLocation;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorite;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @writePassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get writePassword;

  /// No description provided for @writeUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter username'**
  String get writeUsername;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @rewritePassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get rewritePassword;

  /// No description provided for @ensurePassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get ensurePassword;

  /// No description provided for @writeEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter username or email'**
  String get writeEmail;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or sign in with'**
  String get or;

  /// No description provided for @iAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms, conditions and privacy policy'**
  String get iAgree;

  /// No description provided for @signupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get signupSuccess;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login now'**
  String get loginNow;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @welcomeBackDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ve missed you! Welcome back'**
  String get welcomeBackDesc;

  /// No description provided for @welcomeIn.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Dakakein, create your account now'**
  String get welcomeIn;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for...'**
  String get searchHint;

  /// No description provided for @dataUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Data updated successfully'**
  String get dataUpdatedSuccessfully;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get memberSince;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get notVerified;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @locationInformation.
  ///
  /// In en, this message translates to:
  /// **'Location Information'**
  String get locationInformation;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @securityAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Security and Privacy'**
  String get securityAndPrivacy;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpAndSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @imageChangeFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Image change feature coming soon'**
  String get imageChangeFeatureComingSoon;

  /// No description provided for @editFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit feature coming soon'**
  String get editFeatureComingSoon;

  /// No description provided for @datePickerFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Date picker feature coming soon'**
  String get datePickerFeatureComingSoon;

  /// No description provided for @genderPickerFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Gender picker feature coming soon'**
  String get genderPickerFeatureComingSoon;

  /// No description provided for @editProfileFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Edit profile feature coming soon'**
  String get editProfileFeatureComingSoon;

  /// No description provided for @accountSettingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Account settings coming soon'**
  String get accountSettingsComingSoon;

  /// No description provided for @securitySettingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Security settings coming soon'**
  String get securitySettingsComingSoon;

  /// No description provided for @helpCenterComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Help center coming soon'**
  String get helpCenterComingSoon;

  /// No description provided for @bestSellers.
  ///
  /// In en, this message translates to:
  /// **'Best Sellers'**
  String get bestSellers;

  /// No description provided for @featuredProducts.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get featuredProducts;

  /// No description provided for @latestProducts.
  ///
  /// In en, this message translates to:
  /// **'Latest Products'**
  String get latestProducts;

  /// No description provided for @specialOffers.
  ///
  /// In en, this message translates to:
  /// **'Special Offers'**
  String get specialOffers;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @searchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search for products...'**
  String get searchProducts;

  /// No description provided for @noProductsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No products in this category'**
  String get noProductsInCategory;

  /// No description provided for @selectCategoryToView.
  ///
  /// In en, this message translates to:
  /// **'Select a category to view products'**
  String get selectCategoryToView;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorLoadingBestSellers.
  ///
  /// In en, this message translates to:
  /// **'Error loading best selling products'**
  String get errorLoadingBestSellers;

  /// No description provided for @errorLoadingFeatured.
  ///
  /// In en, this message translates to:
  /// **'Error loading featured products'**
  String get errorLoadingFeatured;

  /// No description provided for @errorLoadingLatest.
  ///
  /// In en, this message translates to:
  /// **'Error loading latest products'**
  String get errorLoadingLatest;

  /// No description provided for @errorLoadingSpecialOffers.
  ///
  /// In en, this message translates to:
  /// **'Error loading special offers'**
  String get errorLoadingSpecialOffers;

  /// No description provided for @noBestSellersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No best selling products available'**
  String get noBestSellersAvailable;

  /// No description provided for @productVideoDescription.
  ///
  /// In en, this message translates to:
  /// **'Watch a product preview video'**
  String get productVideoDescription;

  /// No description provided for @noFeaturedAvailable.
  ///
  /// In en, this message translates to:
  /// **'No featured products available'**
  String get noFeaturedAvailable;

  /// No description provided for @noLatestAvailable.
  ///
  /// In en, this message translates to:
  /// **'No new products available'**
  String get noLatestAvailable;

  /// No description provided for @noSpecialOffersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No special offers available'**
  String get noSpecialOffersAvailable;

  /// No description provided for @productVideo.
  ///
  /// In en, this message translates to:
  /// **'Product Video'**
  String get productVideo;

  /// No description provided for @errorOpeningVideo.
  ///
  /// In en, this message translates to:
  /// **'Error opening video'**
  String get errorOpeningVideo;

  /// No description provided for @videoLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Video link copied to clipboard'**
  String get videoLinkCopied;

  /// No description provided for @openInYouTubeApp.
  ///
  /// In en, this message translates to:
  /// **'Paste in YouTube app or browser to watch'**
  String get openInYouTubeApp;

  /// No description provided for @openYouTube.
  ///
  /// In en, this message translates to:
  /// **'Open YouTube'**
  String get openYouTube;

  /// No description provided for @linkInClipboard.
  ///
  /// In en, this message translates to:
  /// **'Link is now in your clipboard'**
  String get linkInClipboard;

  /// No description provided for @cannotOpenVideo.
  ///
  /// In en, this message translates to:
  /// **'Cannot open video'**
  String get cannotOpenVideo;

  /// No description provided for @watchVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get watchVideo;

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add Review'**
  String get addReview;

  /// No description provided for @rateProduct.
  ///
  /// In en, this message translates to:
  /// **'Rate this product'**
  String get rateProduct;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write your review'**
  String get writeReview;

  /// No description provided for @reviewHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with this product...'**
  String get reviewHint;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// No description provided for @veryPoor.
  ///
  /// In en, this message translates to:
  /// **'Very Poor'**
  String get veryPoor;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @reviewSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Review submitted successfully!'**
  String get reviewSubmitted;

  /// No description provided for @reviewSubmissionError.
  ///
  /// In en, this message translates to:
  /// **'Error submitting review. Please try again.'**
  String get reviewSubmissionError;

  /// No description provided for @addedToCart.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get addedToCart;

  /// No description provided for @toCart.
  ///
  /// In en, this message translates to:
  /// **'to cart'**
  String get toCart;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @salesCount.
  ///
  /// In en, this message translates to:
  /// **'Sales Count'**
  String get salesCount;

  /// No description provided for @viewsCount.
  ///
  /// In en, this message translates to:
  /// **'Views Count'**
  String get viewsCount;

  /// No description provided for @orderLimit.
  ///
  /// In en, this message translates to:
  /// **'Order Limit'**
  String get orderLimit;

  /// No description provided for @piece.
  ///
  /// In en, this message translates to:
  /// **'piece'**
  String get piece;

  /// No description provided for @pieces.
  ///
  /// In en, this message translates to:
  /// **'pieces'**
  String get pieces;

  /// No description provided for @shippingAvailableTo.
  ///
  /// In en, this message translates to:
  /// **'Shipping available to'**
  String get shippingAvailableTo;

  /// No description provided for @goingToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Going to checkout...'**
  String get goingToCheckout;

  /// No description provided for @shoppingCart.
  ///
  /// In en, this message translates to:
  /// **'Shopping Cart'**
  String get shoppingCart;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @completeOrder.
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get completeOrder;

  /// No description provided for @advancedFilter.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filter'**
  String get advancedFilter;

  /// No description provided for @selectDepartment.
  ///
  /// In en, this message translates to:
  /// **'Select Department'**
  String get selectDepartment;

  /// No description provided for @selectMainCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Main Category'**
  String get selectMainCategory;

  /// No description provided for @selectSubCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Sub Category'**
  String get selectSubCategory;

  /// No description provided for @productsCount.
  ///
  /// In en, this message translates to:
  /// **'products'**
  String get productsCount;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @smartPhonePro.
  ///
  /// In en, this message translates to:
  /// **'Smart Phone Pro X'**
  String get smartPhonePro;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @customerReviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get customerReviews;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'review'**
  String get review;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @viewAllReviews.
  ///
  /// In en, this message translates to:
  /// **'View All Reviews'**
  String get viewAllReviews;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @beFirstToReview.
  ///
  /// In en, this message translates to:
  /// **'Be the first to review this product'**
  String get beFirstToReview;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'Views'**
  String get views;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'Available colors'**
  String get colors;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
