import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

import '../../../config/navigation/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _isVideoInitialized = false;
  bool _videoEnded = false;

  @override
  void initState() {
    super.initState();
    _initVideo();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initVideo() async {
    _videoController = VideoPlayerController.asset('assets/videos/splash.mp4');

    try {
      await _videoController.initialize();
      if (!mounted) return;
      setState(() => _isVideoInitialized = true);
      _videoController.play();
      _videoController.setLooping(false);

      _videoController.addListener(() {
        final bool isFinished = _videoController.value.position >= _videoController.value.duration;
        if (isFinished && !_videoEnded) {
          if (!mounted) return;
          setState(() => _videoEnded = true);
          _navigateToNext();
        }
      });
    } catch (e) {
      _navigateToNext();
    }
  }

  Future<void> _navigateToNext() async {
    _pulseController.repeat(reverse: true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Wait for AuthProvider to finish loading from storage if it hasn't yet
    int attempts = 0;
    while (!authProvider.isInitialized && attempts < 20) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }

    if (!mounted) return;

    if (authProvider.user != null) {
      context.go(AppRoutes.homeRoute);
    } else {
      context.go(AppRoutes.loginRoute);
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (!_videoEnded && _isVideoInitialized)
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              ),
            ),

          if (_videoEnded || !_isVideoInitialized)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppConstants.logo, width: 150, errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.school, size: 80, color: AppColors.primary);
                  }),
                  const SizedBox(height: 30),
                  FadeTransition(
                    opacity: _pulseAnimation,
                    child: const Text(
                      "Study Share starting...",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
