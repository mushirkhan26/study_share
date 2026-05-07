class AppConstants {
  // App Info
  static const String appName = 'Study Share'; // Updated Name
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String apiBaseUrl = "https://study-share-cvkc.onrender.com/api/";
  static const String socketBaseUrl = "https://study-share-cvkc.onrender.com";

  // Assets (Images & Icons)
  static const String baseImg = "assets/images";
  static const String baseIcon = "assets/icons";
  static const String logo = "$baseImg/logo.jpg";

  static const String deleteIcon = "$baseIcon/delete.png";
  static const String scheduleIcon = "$baseIcon/schedule.png";
  static const String updateIcon = "$baseIcon/updated.png";

  // UI Design Constants
  static const double defaultPadding = 16.0;
  static const double borderRadius = 15.0; // Study App ke liye round corners ache lagte hain
  static const double cardElevation = 4.0;

  // Spacing & Padding Scale
  static const double spaceXS = 4.0;
  static const double spaceS = 8.0;
  static const double spaceM = 16.0;
  static const double spaceL = 24.0;
  static const double spaceXL = 32.0;

  // Logging Configuration (Jo LoggingService use karega)
  static const bool enableLogging = true;
  static const bool enableConsoleLogging = true;
  static const bool enableColoredConsoleOutput = true;
  static const bool showTimestamp = true;
  static const bool showLogLevel = true;

  // Log Levels Strings
  static const String defaultLogLevel = 'debug';

  // Log Categories (Jo ApiHelper call kar raha hai)
  static const String logCategoryApi = 'API';
  static const String logCategoryAuth = 'AUTH';
  static const String logCategoryUI = 'UI';
  static const String logCategoryStorage = 'STORAGE';
  static const String logCategoryNetwork = 'NETWORK';
  static const String logCategoryGeneral = 'GENERAL';

  // Padding Constants
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingLSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLMedium = 15.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Spacing Constants
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border Radius Constants
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;

  // Theme Colors (Optional but helpful)
  static const int primaryColor = 0xFF00BFA5; // Teal
}