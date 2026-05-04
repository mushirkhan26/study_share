import 'package:flutter/material.dart';
import 'config/navigation/app_router.dart';
import 'config/theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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