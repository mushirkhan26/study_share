import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/navigation/app_router.dart';
import 'config/theme/app_colors.dart';
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
    return MaterialApp.router(
      title:'Study Share',
      debugShowCheckedModeBanner: false,

      // 🎨 Theme Setup
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),

      // 🛣️ Routing Setup (GoRouter connect ho raha hai)
      routerConfig: appRouter,
    );
  }
}
