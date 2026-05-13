// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Study Share';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get loginToAccess => 'Login to access your study notes';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get loginSuccessful => 'Login Successful!';

  @override
  String get loginFailed => 'Login failed';

  @override
  String discoverBooks(String name) {
    return 'Discover Books, $name';
  }

  @override
  String helloSeller(String name) {
    return 'Hello Seller, $name';
  }

  @override
  String get findSecondHandBooks => 'Find second-hand books from seniors';

  @override
  String get searchBooksHint => 'Search for books, authors, or subjects...';

  @override
  String get categories => 'Categories';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String get viewAll => 'View All';

  @override
  String get noBooksFound => 'No books found';

  @override
  String get needStudyNotes => 'Need Study Notes?';

  @override
  String get getPDFsAndNotes => 'Get PDFs and handwritten notes from toppers.';

  @override
  String get browse => 'Browse';

  @override
  String get home => 'Home';

  @override
  String get search => 'Search';

  @override
  String get sell => 'Sell';

  @override
  String get chat => 'Chat';

  @override
  String get profile => 'Profile';

  @override
  String get more => 'More';

  @override
  String get myUploads => 'My Uploads';

  @override
  String get savedMaterials => 'Saved Materials';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get buyerProfile => 'Buyer Profile';

  @override
  String get sellerProfile => 'Seller Profile';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinCommunity => 'Join the Study Share community';

  @override
  String get fullName => 'Full Name';

  @override
  String get enterName => 'Enter your name';

  @override
  String get college => 'College/University';

  @override
  String get enterCollege => 'Enter college name';

  @override
  String get iWantTo => 'I want to';

  @override
  String get buyBooks => 'Buy Books';

  @override
  String get sellBooks => 'Sell Books';

  @override
  String get createPassword => 'Create password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get accountCreated => 'Account Created Successfully!';

  @override
  String get signupFailed => 'Signup failed';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get searchBooks => 'Search Books';

  @override
  String get searchHint => 'Search by title or author...';

  @override
  String get courseCategory => 'Course / Category';

  @override
  String get searching => 'Searching...';

  @override
  String resultsFound(int count) {
    return 'Results ($count found)';
  }

  @override
  String get noBooksMatching => 'No books found matching your search.';

  @override
  String get all => 'All';

  @override
  String get bca => 'BCA';

  @override
  String get btech => 'B.Tech';

  @override
  String get bsc => 'B.Sc';

  @override
  String get ba => 'BA';

  @override
  String get bcom => 'B.Com';

  @override
  String get novels => 'Novels';

  @override
  String get other => 'Other';

  @override
  String get postBook => 'Post a Book';

  @override
  String get sellerProfileRequired => 'Seller Profile Required';

  @override
  String get buyerProfileNotice =>
      'You are currently using a Buyer profile. Switch to a Seller profile to post ads and sell your books.';

  @override
  String get switchToSeller => 'Switch to Seller Profile';

  @override
  String get switchToSellerConfirm => 'Switch to Seller Profile?';

  @override
  String get switchToSellerNotice =>
      'By switching to a seller profile, you will be able to post book ads and sell your materials to other students.';

  @override
  String get switchText => 'Switch';

  @override
  String get accountUpgraded => 'Account upgraded to Seller!';

  @override
  String get failedToUpgrade => 'Failed to upgrade';

  @override
  String get bookPhoto => 'Book Photos (Max 3) *';

  @override
  String get tapToAddPhoto => 'Tap to add photos';

  @override
  String get selectSource => 'Select Source';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get frontPhoto => 'Front Photo';

  @override
  String get selectFrontPhoto => 'Select Front Photo';

  @override
  String get addMorePhotos => 'Add More Photos';

  @override
  String get limitReached => 'Limit reached (Max 3 photos)';

  @override
  String get bookDetails => 'Book Details';

  @override
  String get bookTitle => 'Book Title';

  @override
  String get titleHint => 'e.g. Let Us C';

  @override
  String get authorName => 'Author Name';

  @override
  String get authorHint => 'e.g. Yashavant Kanetkar';

  @override
  String get sellingPrice => 'Selling Price (₹)';

  @override
  String get priceHint => 'e.g. 150';

  @override
  String get originalPrice => 'Original Price (₹)';

  @override
  String get originalPriceHint => 'e.g. 400';

  @override
  String get condition => 'Condition';

  @override
  String get courseTag => 'Course/Tag';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint =>
      'Tell us more about the book (e.g. Include details about marks, highlights, or why you\'re selling.)';

  @override
  String get postAd => 'Post Ad';

  @override
  String get pleaseUploadPhoto => 'Please upload a picture of the book!';

  @override
  String get adPostedSuccess => 'Book Ad Posted Successfully!';

  @override
  String get failedToPostAd => 'Failed to post ad';

  @override
  String get required => 'Required';

  @override
  String get likeNew => 'Like New';

  @override
  String get good => 'Good';

  @override
  String get old => 'Old';

  @override
  String get wornOut => 'Worn Out';

  @override
  String get myAccount => 'My Account';

  @override
  String get activeAds => 'Active Ads';

  @override
  String get booksSold => 'Books Sold';

  @override
  String get earnings => 'Earnings';

  @override
  String get myAdsManage => 'My Ads (Manage Books)';

  @override
  String get myAdsSubtitle => 'Edit, delete, or mark as sold';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get wishlistSubtitle => 'Books you have saved';

  @override
  String get myChats => 'My Chats';

  @override
  String get myChatsSubtitle => 'Conversations with buyers/sellers';

  @override
  String get settingsSubtitle => 'Notifications, privacy, and more';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacySecurity => 'Privacy & Security';

  @override
  String get preferences => 'Preferences';

  @override
  String get appearance => 'Appearance (Theme Mode)';

  @override
  String get appLanguage => 'App Language';

  @override
  String get supportAbout => 'Support & About';

  @override
  String get helpCenter => 'Help Center / FAQ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get aboutApp => 'About App';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChangeNotice =>
      'Changing the language will update the app\'s user interface text.';

  @override
  String get unknownAuthor => 'Unknown Author';

  @override
  String get sellerDetails => 'Seller Details';

  @override
  String get privateSeller => 'Private Seller';

  @override
  String get identityHidden => 'Identity hidden by seller';

  @override
  String get studentSeller => 'Student Seller';

  @override
  String get privateProfileRestricted =>
      'This seller has a private profile. Contact is restricted.';

  @override
  String get chatWithSeller => 'Chat with Seller';

  @override
  String get studyMaterials => 'Study Materials';

  @override
  String get noMaterialsShared => 'No materials shared yet.';

  @override
  String get uploadStudyMaterial => 'Upload Study Material';

  @override
  String get subject => 'Subject';

  @override
  String get subjectHint => 'e.g. Computer Science';

  @override
  String get type => 'Type';

  @override
  String get pdf => 'PDF';

  @override
  String get image => 'Image';

  @override
  String fileSelected(String fileName) {
    return 'File Selected: $fileName';
  }

  @override
  String get tapToSelectFile => 'Tap to select file (Image/PDF)';

  @override
  String get uploadNow => 'Upload Now';

  @override
  String get materialUploaded => 'Material Uploaded!';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String get allFieldsRequired => 'All fields are required';

  @override
  String get noAppToOpenFile => 'No app found to open this file';

  @override
  String get noConversations => 'No active conversations found.';

  @override
  String regarding(String title) {
    return 'Regarding: $title';
  }

  @override
  String get bookNotAvailable => 'This book is no longer available.';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemDefault => 'System Default';

  @override
  String get darkModeNotice =>
      'Dark mode helps reduce eye strain and saves battery on OLED screens.';

  @override
  String get ourMission => 'Our Mission';

  @override
  String get missionDescription =>
      'Study Share is designed to help students save money and reduce waste by creating a marketplace for second-hand study materials. We believe every student should have easy access to affordable education resources.';

  @override
  String get ourTeam => 'Our Team';

  @override
  String get madeWithLove => 'Made with ❤️ for Students';

  @override
  String get howCanWeHelp => 'How can we help you?';

  @override
  String get searchHelpArticles => 'Search help articles...';

  @override
  String get stillHaveQuestions => 'Still have questions?';

  @override
  String get contactSupportNotice =>
      'If you can\'t find an answer in our FAQ, you can reach out to our support team.';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get security => 'Security';

  @override
  String get privacy => 'Privacy';

  @override
  String get accountAction => 'Account Action';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changePasswordSubtitle => 'Update your account password regularly';

  @override
  String get twoFactorAuth => 'Two-Factor Authentication';

  @override
  String get twoFactorSubtitle => 'Add an extra layer of security';

  @override
  String get activeSessions => 'Active Sessions';

  @override
  String get activeSessionsSubtitle => 'Manage devices where you are logged in';

  @override
  String get privateProfile => 'Private Profile';

  @override
  String get privateProfileSubtitle => 'Only show your ads to registered users';

  @override
  String get showPhoneNumber => 'Show Phone Number';

  @override
  String get showPhoneNumberSubtitle => 'Allow buyers to see your number';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountSubtitle =>
      'Permanently remove your account and data';

  @override
  String get deleteAccountConfirmTitle => 'Delete Account?';

  @override
  String get deleteAccountConfirmContent =>
      'Are you sure you want to permanently delete your account? This action cannot be undone.';

  @override
  String get delete => 'Delete';

  @override
  String get general => 'General';

  @override
  String get buying => 'Buying';

  @override
  String get selling => 'Selling';

  @override
  String get otpSent => 'OTP sent to your email!';

  @override
  String get verifyOTP => 'Verify OTP';

  @override
  String enter6DigitCode(String email) {
    return 'Enter the 6-digit code sent to $email';
  }

  @override
  String get enterEmailToReset =>
      'Enter your email address and we\'ll send you an OTP to reset your password.';

  @override
  String get enterOTP => 'Enter OTP';

  @override
  String get otpHint => '6-digit OTP';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordHint => 'Enter new password';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get sendOTP => 'Send OTP';

  @override
  String get changeEmail => 'Change Email';

  @override
  String get passwordResetSuccess => 'Password reset successful! Please login.';

  @override
  String get enter6DigitOTP => 'Please enter 6-digit OTP';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get online => 'Online';

  @override
  String get initializingChat => 'Initializing chat, please wait...';

  @override
  String get typeAMessage => 'Type a message...';

  @override
  String get available => 'Available';

  @override
  String get markSold => 'Mark Sold';

  @override
  String get statusUpdated => 'Status updated!';

  @override
  String get deleteAdConfirmTitle => 'Delete Ad?';

  @override
  String get deleteAdConfirmContent =>
      'Are you sure you want to remove this book listing?';

  @override
  String get adDeletedSuccess => 'Ad deleted successfully';

  @override
  String get noAdsPosted => 'You haven\'t posted any ads yet.';

  @override
  String get savedBooks => 'Saved Books';

  @override
  String get noSavedBooks => 'No saved books yet.';

  @override
  String get exploreBooks => 'Explore Books';

  @override
  String get profileUpdated => 'Profile Updated Successfully!';

  @override
  String get updateFailed => 'Update failed';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get noActiveSessions => 'No active sessions found';

  @override
  String get current => 'Current';

  @override
  String ip(String ipAddress) {
    return 'IP: $ipAddress';
  }

  @override
  String lastActive(String date) {
    return 'Last active: $date';
  }

  @override
  String get sessionRevoked => 'Session revoked';

  @override
  String get privacyPolicyTitle => 'Privacy Policy for Study Share';

  @override
  String get lastUpdated => 'Last Updated: May 2026';

  @override
  String get policyIntroTitle => '1. Introduction';

  @override
  String get policyIntroContent =>
      'Welcome to Study Share. We respect your privacy and want to protect your personal data. This Privacy Policy explains how we collect, use, and share your information when you use our mobile application.';

  @override
  String get policyDataTitle => '2. Data We Collect';

  @override
  String get policyDataContent =>
      'We collect information that you provide directly to us, such as when you create an account, post a book advertisement, or communicate with other users. This may include:\n\n• Name and email address\n• Phone number (optional)\n• College or University name\n• Photos of the books you post';

  @override
  String get policyUsageTitle => '3. How We Use Your Data';

  @override
  String get policyUsageContent =>
      'We use the information we collect to:\n\n• Provide and maintain our services\n• Facilitate connections between buyers and sellers\n• Send you technical notices and support messages\n• Monitor and analyze usage and trends';

  @override
  String get policySharingTitle => '4. Data Sharing';

  @override
  String get policySharingContent =>
      'We do not sell your personal data. We only share information with other users as necessary to facilitate transactions (e.g., showing your name on an ad). Your phone number is only shared if you explicitly choose to enable that setting.';

  @override
  String get policyRightsTitle => '5. Your Rights';

  @override
  String get policyRightsContent =>
      'You have the right to access, update, or delete your personal information at any time through the app\'s settings. If you choose to delete your account, all your data will be permanently removed from our servers.';

  @override
  String get policyContactTitle => '6. Contact Us';

  @override
  String get policyContactContent =>
      'If you have any questions about this Privacy Policy, please contact us at support@studyshare.com.';

  @override
  String get thankYouTrusting => 'Thank you for trusting Study Share.';
}
