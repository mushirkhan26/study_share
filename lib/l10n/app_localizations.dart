import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Study Share'**
  String get appName;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get welcomeBack;

  /// No description provided for @loginToAccess.
  ///
  /// In en, this message translates to:
  /// **'Login to access your study notes'**
  String get loginToAccess;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @loginSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful!'**
  String get loginSuccessful;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @discoverBooks.
  ///
  /// In en, this message translates to:
  /// **'Discover Books, {name}'**
  String discoverBooks(String name);

  /// No description provided for @helloSeller.
  ///
  /// In en, this message translates to:
  /// **'Hello Seller, {name}'**
  String helloSeller(String name);

  /// No description provided for @findSecondHandBooks.
  ///
  /// In en, this message translates to:
  /// **'Find second-hand books from seniors'**
  String get findSecondHandBooks;

  /// No description provided for @searchBooksHint.
  ///
  /// In en, this message translates to:
  /// **'Search for books, authors, or subjects...'**
  String get searchBooksHint;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get recentlyAdded;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noBooksFound.
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get noBooksFound;

  /// No description provided for @needStudyNotes.
  ///
  /// In en, this message translates to:
  /// **'Need Study Notes?'**
  String get needStudyNotes;

  /// No description provided for @getPDFsAndNotes.
  ///
  /// In en, this message translates to:
  /// **'Get PDFs and handwritten notes from toppers.'**
  String get getPDFsAndNotes;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'Browse'**
  String get browse;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @myUploads.
  ///
  /// In en, this message translates to:
  /// **'My Uploads'**
  String get myUploads;

  /// No description provided for @savedMaterials.
  ///
  /// In en, this message translates to:
  /// **'Saved Materials'**
  String get savedMaterials;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @buyerProfile.
  ///
  /// In en, this message translates to:
  /// **'Buyer Profile'**
  String get buyerProfile;

  /// No description provided for @sellerProfile.
  ///
  /// In en, this message translates to:
  /// **'Seller Profile'**
  String get sellerProfile;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join the Study Share community'**
  String get joinCommunity;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterName;

  /// No description provided for @college.
  ///
  /// In en, this message translates to:
  /// **'College/University'**
  String get college;

  /// No description provided for @enterCollege.
  ///
  /// In en, this message translates to:
  /// **'Enter college name'**
  String get enterCollege;

  /// No description provided for @iWantTo.
  ///
  /// In en, this message translates to:
  /// **'I want to'**
  String get iWantTo;

  /// No description provided for @buyBooks.
  ///
  /// In en, this message translates to:
  /// **'Buy Books'**
  String get buyBooks;

  /// No description provided for @sellBooks.
  ///
  /// In en, this message translates to:
  /// **'Sell Books'**
  String get sellBooks;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Create password'**
  String get createPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account Created Successfully!'**
  String get accountCreated;

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Signup failed'**
  String get signupFailed;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @searchBooks.
  ///
  /// In en, this message translates to:
  /// **'Search Books'**
  String get searchBooks;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by title or author...'**
  String get searchHint;

  /// No description provided for @courseCategory.
  ///
  /// In en, this message translates to:
  /// **'Course / Category'**
  String get courseCategory;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// No description provided for @resultsFound.
  ///
  /// In en, this message translates to:
  /// **'Results ({count} found)'**
  String resultsFound(int count);

  /// No description provided for @noBooksMatching.
  ///
  /// In en, this message translates to:
  /// **'No books found matching your search.'**
  String get noBooksMatching;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @bca.
  ///
  /// In en, this message translates to:
  /// **'BCA'**
  String get bca;

  /// No description provided for @btech.
  ///
  /// In en, this message translates to:
  /// **'B.Tech'**
  String get btech;

  /// No description provided for @bsc.
  ///
  /// In en, this message translates to:
  /// **'B.Sc'**
  String get bsc;

  /// No description provided for @ba.
  ///
  /// In en, this message translates to:
  /// **'BA'**
  String get ba;

  /// No description provided for @bcom.
  ///
  /// In en, this message translates to:
  /// **'B.Com'**
  String get bcom;

  /// No description provided for @novels.
  ///
  /// In en, this message translates to:
  /// **'Novels'**
  String get novels;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @postBook.
  ///
  /// In en, this message translates to:
  /// **'Post a Book'**
  String get postBook;

  /// No description provided for @sellerProfileRequired.
  ///
  /// In en, this message translates to:
  /// **'Seller Profile Required'**
  String get sellerProfileRequired;

  /// No description provided for @buyerProfileNotice.
  ///
  /// In en, this message translates to:
  /// **'You are currently using a Buyer profile. Switch to a Seller profile to post ads and sell your books.'**
  String get buyerProfileNotice;

  /// No description provided for @switchToSeller.
  ///
  /// In en, this message translates to:
  /// **'Switch to Seller Profile'**
  String get switchToSeller;

  /// No description provided for @switchToSellerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Switch to Seller Profile?'**
  String get switchToSellerConfirm;

  /// No description provided for @switchToSellerNotice.
  ///
  /// In en, this message translates to:
  /// **'By switching to a seller profile, you will be able to post book ads and sell your materials to other students.'**
  String get switchToSellerNotice;

  /// No description provided for @switchText.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchText;

  /// No description provided for @accountUpgraded.
  ///
  /// In en, this message translates to:
  /// **'Account upgraded to Seller!'**
  String get accountUpgraded;

  /// No description provided for @failedToUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Failed to upgrade'**
  String get failedToUpgrade;

  /// No description provided for @bookPhoto.
  ///
  /// In en, this message translates to:
  /// **'Book Photos (Max 3) *'**
  String get bookPhoto;

  /// No description provided for @tapToAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add photos'**
  String get tapToAddPhoto;

  /// No description provided for @selectSource.
  ///
  /// In en, this message translates to:
  /// **'Select Source'**
  String get selectSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @frontPhoto.
  ///
  /// In en, this message translates to:
  /// **'Front Photo'**
  String get frontPhoto;

  /// No description provided for @selectFrontPhoto.
  ///
  /// In en, this message translates to:
  /// **'Select Front Photo'**
  String get selectFrontPhoto;

  /// No description provided for @addMorePhotos.
  ///
  /// In en, this message translates to:
  /// **'Add More Photos'**
  String get addMorePhotos;

  /// No description provided for @limitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit reached (Max 3 photos)'**
  String get limitReached;

  /// No description provided for @bookDetails.
  ///
  /// In en, this message translates to:
  /// **'Book Details'**
  String get bookDetails;

  /// No description provided for @bookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Title'**
  String get bookTitle;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Let Us C'**
  String get titleHint;

  /// No description provided for @authorName.
  ///
  /// In en, this message translates to:
  /// **'Author Name'**
  String get authorName;

  /// No description provided for @authorHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Yashavant Kanetkar'**
  String get authorHint;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price (₹)'**
  String get sellingPrice;

  /// No description provided for @priceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 150'**
  String get priceHint;

  /// No description provided for @originalPrice.
  ///
  /// In en, this message translates to:
  /// **'Original Price (₹)'**
  String get originalPrice;

  /// No description provided for @originalPriceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 400'**
  String get originalPriceHint;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @courseTag.
  ///
  /// In en, this message translates to:
  /// **'Course/Tag'**
  String get courseTag;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us more about the book (e.g. Include details about marks, highlights, or why you\'re selling.)'**
  String get descriptionHint;

  /// No description provided for @postAd.
  ///
  /// In en, this message translates to:
  /// **'Post Ad'**
  String get postAd;

  /// No description provided for @pleaseUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Please upload a picture of the book!'**
  String get pleaseUploadPhoto;

  /// No description provided for @adPostedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Book Ad Posted Successfully!'**
  String get adPostedSuccess;

  /// No description provided for @failedToPostAd.
  ///
  /// In en, this message translates to:
  /// **'Failed to post ad'**
  String get failedToPostAd;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @likeNew.
  ///
  /// In en, this message translates to:
  /// **'Like New'**
  String get likeNew;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @old.
  ///
  /// In en, this message translates to:
  /// **'Old'**
  String get old;

  /// No description provided for @wornOut.
  ///
  /// In en, this message translates to:
  /// **'Worn Out'**
  String get wornOut;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @activeAds.
  ///
  /// In en, this message translates to:
  /// **'Active Ads'**
  String get activeAds;

  /// No description provided for @booksSold.
  ///
  /// In en, this message translates to:
  /// **'Books Sold'**
  String get booksSold;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @myAdsManage.
  ///
  /// In en, this message translates to:
  /// **'My Ads (Manage Books)'**
  String get myAdsManage;

  /// No description provided for @myAdsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Edit, delete, or mark as sold'**
  String get myAdsSubtitle;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @wishlistSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Books you have saved'**
  String get wishlistSubtitle;

  /// No description provided for @myChats.
  ///
  /// In en, this message translates to:
  /// **'My Chats'**
  String get myChats;

  /// No description provided for @myChatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Conversations with buyers/sellers'**
  String get myChatsSubtitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications, privacy, and more'**
  String get settingsSubtitle;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacySecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacySecurity;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance (Theme Mode)'**
  String get appearance;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @supportAbout.
  ///
  /// In en, this message translates to:
  /// **'Support & About'**
  String get supportAbout;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center / FAQ'**
  String get helpCenter;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChangeNotice.
  ///
  /// In en, this message translates to:
  /// **'Changing the language will update the app\'s user interface text.'**
  String get languageChangeNotice;

  /// No description provided for @unknownAuthor.
  ///
  /// In en, this message translates to:
  /// **'Unknown Author'**
  String get unknownAuthor;

  /// No description provided for @sellerDetails.
  ///
  /// In en, this message translates to:
  /// **'Seller Details'**
  String get sellerDetails;

  /// No description provided for @privateSeller.
  ///
  /// In en, this message translates to:
  /// **'Private Seller'**
  String get privateSeller;

  /// No description provided for @identityHidden.
  ///
  /// In en, this message translates to:
  /// **'Identity hidden by seller'**
  String get identityHidden;

  /// No description provided for @studentSeller.
  ///
  /// In en, this message translates to:
  /// **'Student Seller'**
  String get studentSeller;

  /// No description provided for @privateProfileRestricted.
  ///
  /// In en, this message translates to:
  /// **'This seller has a private profile. Contact is restricted.'**
  String get privateProfileRestricted;

  /// No description provided for @chatWithSeller.
  ///
  /// In en, this message translates to:
  /// **'Chat with Seller'**
  String get chatWithSeller;

  /// No description provided for @studyMaterials.
  ///
  /// In en, this message translates to:
  /// **'Study Materials'**
  String get studyMaterials;

  /// No description provided for @noMaterialsShared.
  ///
  /// In en, this message translates to:
  /// **'No materials shared yet.'**
  String get noMaterialsShared;

  /// No description provided for @uploadStudyMaterial.
  ///
  /// In en, this message translates to:
  /// **'Upload Study Material'**
  String get uploadStudyMaterial;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @subjectHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Computer Science'**
  String get subjectHint;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @pdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @fileSelected.
  ///
  /// In en, this message translates to:
  /// **'File Selected: {fileName}'**
  String fileSelected(String fileName);

  /// No description provided for @tapToSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to select file (Image/PDF)'**
  String get tapToSelectFile;

  /// No description provided for @uploadNow.
  ///
  /// In en, this message translates to:
  /// **'Upload Now'**
  String get uploadNow;

  /// No description provided for @materialUploaded.
  ///
  /// In en, this message translates to:
  /// **'Material Uploaded!'**
  String get materialUploaded;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// No description provided for @allFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'All fields are required'**
  String get allFieldsRequired;

  /// No description provided for @noAppToOpenFile.
  ///
  /// In en, this message translates to:
  /// **'No app found to open this file'**
  String get noAppToOpenFile;

  /// No description provided for @noConversations.
  ///
  /// In en, this message translates to:
  /// **'No active conversations found.'**
  String get noConversations;

  /// No description provided for @regarding.
  ///
  /// In en, this message translates to:
  /// **'Regarding: {title}'**
  String regarding(String title);

  /// No description provided for @bookNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This book is no longer available.'**
  String get bookNotAvailable;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @darkModeNotice.
  ///
  /// In en, this message translates to:
  /// **'Dark mode helps reduce eye strain and saves battery on OLED screens.'**
  String get darkModeNotice;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// No description provided for @missionDescription.
  ///
  /// In en, this message translates to:
  /// **'Study Share is designed to help students save money and reduce waste by creating a marketplace for second-hand study materials. We believe every student should have easy access to affordable education resources.'**
  String get missionDescription;

  /// No description provided for @ourTeam.
  ///
  /// In en, this message translates to:
  /// **'Our Team'**
  String get ourTeam;

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ for Students'**
  String get madeWithLove;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelp;

  /// No description provided for @searchHelpArticles.
  ///
  /// In en, this message translates to:
  /// **'Search help articles...'**
  String get searchHelpArticles;

  /// No description provided for @stillHaveQuestions.
  ///
  /// In en, this message translates to:
  /// **'Still have questions?'**
  String get stillHaveQuestions;

  /// No description provided for @contactSupportNotice.
  ///
  /// In en, this message translates to:
  /// **'If you can\'t find an answer in our FAQ, you can reach out to our support team.'**
  String get contactSupportNotice;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @accountAction.
  ///
  /// In en, this message translates to:
  /// **'Account Action'**
  String get accountAction;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account password regularly'**
  String get changePasswordSubtitle;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get twoFactorAuth;

  /// No description provided for @twoFactorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security'**
  String get twoFactorSubtitle;

  /// No description provided for @activeSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get activeSessions;

  /// No description provided for @activeSessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage devices where you are logged in'**
  String get activeSessionsSubtitle;

  /// No description provided for @privateProfile.
  ///
  /// In en, this message translates to:
  /// **'Private Profile'**
  String get privateProfile;

  /// No description provided for @privateProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only show your ads to registered users'**
  String get privateProfileSubtitle;

  /// No description provided for @showPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Show Phone Number'**
  String get showPhoneNumber;

  /// No description provided for @showPhoneNumberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow buyers to see your number'**
  String get showPhoneNumberSubtitle;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove your account and data'**
  String get deleteAccountSubtitle;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action cannot be undone.'**
  String get deleteAccountConfirmContent;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @buying.
  ///
  /// In en, this message translates to:
  /// **'Buying'**
  String get buying;

  /// No description provided for @selling.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get selling;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to your email!'**
  String get otpSent;

  /// No description provided for @verifyOTP.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOTP;

  /// No description provided for @enter6DigitCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {email}'**
  String enter6DigitCode(String email);

  /// No description provided for @enterEmailToReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you an OTP to reset your password.'**
  String get enterEmailToReset;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOTP;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'6-digit OTP'**
  String get otpHint;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get newPasswordHint;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @sendOTP.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOTP;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successful! Please login.'**
  String get passwordResetSuccess;

  /// No description provided for @enter6DigitOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter 6-digit OTP'**
  String get enter6DigitOTP;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @initializingChat.
  ///
  /// In en, this message translates to:
  /// **'Initializing chat, please wait...'**
  String get initializingChat;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @markSold.
  ///
  /// In en, this message translates to:
  /// **'Mark Sold'**
  String get markSold;

  /// No description provided for @statusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Status updated!'**
  String get statusUpdated;

  /// No description provided for @deleteAdConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Ad?'**
  String get deleteAdConfirmTitle;

  /// No description provided for @deleteAdConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this book listing?'**
  String get deleteAdConfirmContent;

  /// No description provided for @adDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Ad deleted successfully'**
  String get adDeletedSuccess;

  /// No description provided for @noAdsPosted.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t posted any ads yet.'**
  String get noAdsPosted;

  /// No description provided for @savedBooks.
  ///
  /// In en, this message translates to:
  /// **'Saved Books'**
  String get savedBooks;

  /// No description provided for @noSavedBooks.
  ///
  /// In en, this message translates to:
  /// **'No saved books yet.'**
  String get noSavedBooks;

  /// No description provided for @exploreBooks.
  ///
  /// In en, this message translates to:
  /// **'Explore Books'**
  String get exploreBooks;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated Successfully!'**
  String get profileUpdated;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get updateFailed;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @noActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'No active sessions found'**
  String get noActiveSessions;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @ip.
  ///
  /// In en, this message translates to:
  /// **'IP: {ipAddress}'**
  String ip(String ipAddress);

  /// No description provided for @lastActive.
  ///
  /// In en, this message translates to:
  /// **'Last active: {date}'**
  String lastActive(String date);

  /// No description provided for @sessionRevoked.
  ///
  /// In en, this message translates to:
  /// **'Session revoked'**
  String get sessionRevoked;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy for Study Share'**
  String get privacyPolicyTitle;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: May 2026'**
  String get lastUpdated;

  /// No description provided for @policyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get policyIntroTitle;

  /// No description provided for @policyIntroContent.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Study Share. We respect your privacy and want to protect your personal data. This Privacy Policy explains how we collect, use, and share your information when you use our mobile application.'**
  String get policyIntroContent;

  /// No description provided for @policyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Data We Collect'**
  String get policyDataTitle;

  /// No description provided for @policyDataContent.
  ///
  /// In en, this message translates to:
  /// **'We collect information that you provide directly to us, such as when you create an account, post a book advertisement, or communicate with other users. This may include:\n\n• Name and email address\n• Phone number (optional)\n• College or University name\n• Photos of the books you post'**
  String get policyDataContent;

  /// No description provided for @policyUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'3. How We Use Your Data'**
  String get policyUsageTitle;

  /// No description provided for @policyUsageContent.
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to:\n\n• Provide and maintain our services\n• Facilitate connections between buyers and sellers\n• Send you technical notices and support messages\n• Monitor and analyze usage and trends'**
  String get policyUsageContent;

  /// No description provided for @policySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Data Sharing'**
  String get policySharingTitle;

  /// No description provided for @policySharingContent.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal data. We only share information with other users as necessary to facilitate transactions (e.g., showing your name on an ad). Your phone number is only shared if you explicitly choose to enable that setting.'**
  String get policySharingContent;

  /// No description provided for @policyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Your Rights'**
  String get policyRightsTitle;

  /// No description provided for @policyRightsContent.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, update, or delete your personal information at any time through the app\'s settings. If you choose to delete your account, all your data will be permanently removed from our servers.'**
  String get policyRightsContent;

  /// No description provided for @policyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Contact Us'**
  String get policyContactTitle;

  /// No description provided for @policyContactContent.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us at support@studyshare.com.'**
  String get policyContactContent;

  /// No description provided for @thankYouTrusting.
  ///
  /// In en, this message translates to:
  /// **'Thank you for trusting Study Share.'**
  String get thankYouTrusting;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
