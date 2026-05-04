class AppRoutes {
  // Auth Routes
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String forgotPassword = '/forgot-password';

  // Main Tabs (Bottom Nav)
  static const String homeRoute = '/home';
  static const String searchRoute = '/search';
  static const String sellRoute = '/sell-book';
  static const String profileRoute = '/profile';

  // BookHub Specific Routes
  static const String bookDetailRoute = '/book-detail';
  static const String chatRoute = '/chat';

  // Profile Sub-Routes (More Menu)
  static const String myUploads = '/my-uploads'; // My Ads
  static const String savedMaterials = '/saved'; // Saved Books
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String notifications = '/notifications';
  static const String privacySecurity = '/privacy-security';
  static const String appearance = '/appearance';
  static const String language = '/language';
}
