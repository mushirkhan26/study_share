import 'package:go_router/go_router.dart';

// Aapki saari screens import karein
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/home/screens/book_detail_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/sell/screens/sell_book_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/chat/screens/inbox_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/settings/screens/privacy_security_screen.dart';
import '../../features/settings/screens/active_sessions_screen.dart';
import '../../features/settings/screens/appearance_screen.dart';
import '../../features/settings/screens/language_screen.dart';
import '../../features/settings/screens/help_center_screen.dart';
import '../../features/settings/screens/privacy_policy_screen.dart';
import '../../features/settings/screens/about_app_screen.dart';
import '../../features/profile/screens/my_uploads_screen.dart';
import '../../features/profile/screens/saved_materials_screen.dart';
import '../../features/home/screens/study_materials_screen.dart';
import '../../features/settings/screens/settings_screen.dart';

// Import NavigationHost
import 'app_routes.dart';
import 'navigation_host.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // Start with Splash
  routes: [
    // ================= AUTH SCREENS (No Bottom Bar) =================
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.loginRoute,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signupRoute,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => ForgotPasswordScreen(),
    ),

    // ================= MAIN TABS (With Persistent Bottom Navigation Bar) =================
    ShellRoute(
      builder: (context, state, child) => NavigationHost(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.homeRoute,
          pageBuilder: (context, state) => NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.searchRoute,
          pageBuilder: (context, state) =>  NoTransitionPage(
            child: SearchScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.sellRoute,
          pageBuilder: (context, state) =>  NoTransitionPage(
            child: SellBookScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profileRoute,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
    ),

    // ================= INNER SCREENS (Without Bottom Bar) =================
    GoRoute(
      path: AppRoutes.bookDetailRoute,
      builder: (context, state) {
        final book = state.extra as Map<String, dynamic>?;
        return BookDetailScreen(bookData: book);
      },
    ),
    GoRoute(
      path: AppRoutes.studyMaterialsRoute,
      builder: (context, state) => const StudyMaterialsScreen(),
    ),
    GoRoute(
      path: AppRoutes.chatRoute,
      builder: (context, state) {
        final bookData = state.extra as Map<String, dynamic>?;
        return ChatScreen(bookData: bookData);
      },
    ),
    GoRoute(
      path: AppRoutes.inboxRoute,
      builder: (context, state) => const InboxScreen(),
    ),
    GoRoute(
      path: AppRoutes.myUploads,
      builder: (context, state) => const MyUploadsScreen(),
    ),
    GoRoute(
      path: AppRoutes.savedMaterials,
      builder: (context, state) => const SavedMaterialsScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacySecurity,
      builder: (context, state) => const PrivacySecurityScreen(),
    ),
    GoRoute(
      path: AppRoutes.activeSessions,
      builder: (context, state) => const ActiveSessionsScreen(),
    ),
    GoRoute(
      path: AppRoutes.appearance,
      builder: (context, state) => const AppearanceScreen(),
    ),
    GoRoute(
      path: AppRoutes.language,
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: AppRoutes.helpCenter,
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: AppRoutes.aboutApp,
      builder: (context, state) => const AboutAppScreen(),
    ),
  ],
);
