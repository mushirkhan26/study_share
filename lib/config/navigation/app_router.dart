import 'package:flutter/material.dart';
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
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/my_uploads_screen.dart';
import '../../features/profile/screens/saved_materials_screen.dart';
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
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signupRoute,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // ================= MAIN TABS (With Persistent Bottom Navigation Bar) =================
    ShellRoute(
      builder: (context, state, child) => NavigationHost(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.homeRoute,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.searchRoute,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.sellRoute,
          pageBuilder: (context, state) => const NoTransitionPage(
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
      builder: (context, state) => const BookDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.chatRoute,
      builder: (context, state) => const ChatScreen(),
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
  ],
);
