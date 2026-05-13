import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'config/navigation/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/book_provider.dart';
import 'core/providers/chat_provider.dart';
import 'core/providers/material_provider.dart';
import 'core/providers/ui_provider.dart';
import 'core/providers/wishlist_provider.dart';
import 'core/providers/notification_provider.dart';
import 'core/services/logger_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Logging Service
  await LoggingService.instance.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => MaterialProvider()),
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UIProvider>(context);

    return MaterialApp.router(
      title:'Study Share',
      debugShowCheckedModeBanner: false,

      // 🎨 Theme Setup
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: uiProvider.themeMode,

      // 🌍 Localization Setup
      locale: uiProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🛣️ Routing Setup (GoRouter connect ho raha hai)
      routerConfig: appRouter,
    );
  }
}
