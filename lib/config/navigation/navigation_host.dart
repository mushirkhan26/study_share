import 'package:curved_labeled_gradient_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_gradient_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import 'app_routes.dart';

class NavigationHost extends StatefulWidget {
  final Widget child;
  const NavigationHost({super.key, required this.child});

  @override
  State<NavigationHost> createState() => _NavigationHostState();
}

class _NavigationHostState extends State<NavigationHost> {
  int get _index {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.homeRoute)) return 0;
    if (location.startsWith(AppRoutes.searchRoute)) return 1;
    if (location.startsWith(AppRoutes.sellRoute)) return 2;
    if (location.startsWith(AppRoutes.profileRoute)) return 3;
    return 0;
  }

  DateTime? _lastBackPressed;

  // ================== MORE MENU (Frosted Glass) ==================
  Future<void> _openMoreMenuDialog() async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "MoreMenu",
      barrierColor: Colors.black12,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.transparent),
              ),
              Positioned(
                bottom: 100,
                right: 20,
                child: Column(
                  children: [
                    CustomPaint(size: const Size(20, 10), painter: _NotchPainter()),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 25, 
                                      backgroundColor: AppColors.primary, 
                                      child: Icon(Icons.person, color: Colors.white)
                                    ),
                                    SizedBox(height: 5),
                                    Text("User Name", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Student", style: TextStyle(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              const Divider(indent: 20, endIndent: 20),
                              _buildMoreItem(
                                icon: Icons.book_outlined,
                                text: "My Uploads",
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push(AppRoutes.myUploads);
                                },
                              ),
                              _buildMoreItem(
                                icon: Icons.bookmark_border,
                                text: "Saved Materials",
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push(AppRoutes.savedMaterials);
                                },
                              ),
                              _buildMoreItem(
                                icon: Icons.settings_outlined,
                                text: "Settings",
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push(AppRoutes.settings);
                                },
                              ),
                              const Divider(indent: 20, endIndent: 20),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.red.withValues(alpha: 0.1),
                                  child: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                                ),
                                title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.red)),
                                onTap: () {
                                  Navigator.pop(context);
                                  _showLogoutDialog(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMoreItem({required IconData icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final String location = GoRouterState.of(context).uri.path;
          if (location != AppRoutes.homeRoute) {
            context.go(AppRoutes.homeRoute);
          } else {
            final now = DateTime.now();
            if (_lastBackPressed == null || now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
              _lastBackPressed = now;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Back again to exit")));
            } else {
              SystemNavigator.pop();
            }
          }
        }
      },
      child: Scaffold(
        extendBody: true,
        body: widget.child,
        bottomNavigationBar: CurvedNavigationBar(
          index: _index,
          height: 65,
          backgroundColor: Colors.transparent,
          color: const Color(0xFFE1F8F8),
          buttonBackgroundColor: AppColors.primary,
          animationDuration: const Duration(milliseconds: 400),
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.home_filled, color: _index == 0 ? Colors.white : AppColors.primary),
              label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.search, color: _index == 1 ? Colors.white : AppColors.primary),
              label: 'Search',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.add_circle_outline, color: _index == 2 ? Colors.white : AppColors.primary),
              label: 'Sell',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.person_outline, color: _index == 3 ? Colors.white : AppColors.primary),
              label: 'Profile',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.menu, color: _index == 4 ? Colors.white : AppColors.primary),
              label: 'More',
            ),
          ],
          onTap: (index) async {
            if (index == 4) {
              await _openMoreMenuDialog();
              return;
            }
            
            switch (index) {
              case 0: context.go(AppRoutes.homeRoute); break;
              case 1: context.go(AppRoutes.searchRoute); break;
              case 2: context.go(AppRoutes.sellRoute); break;
              case 3: context.go(AppRoutes.profileRoute); break;
            }
          },
        ),
      ),
    );
  }
}

class _NotchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.primary;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.go(AppRoutes.loginRoute);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
