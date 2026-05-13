import 'package:curved_labeled_gradient_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_gradient_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../core/providers/auth_provider.dart';
import '../theme/app_colors.dart';
import 'app_routes.dart';

class NavigationHost extends StatelessWidget {
  final Widget child;
  const NavigationHost({super.key, required this.child});

  int _getIndex(BuildContext context, AuthProvider authProvider) {
    final user = authProvider.user;
    if (user == null) return 0;
    
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.homeRoute)) return 0;
    if (location.startsWith(AppRoutes.searchRoute)) return 1;
    
    if (user.isSeller) {
      if (location.startsWith(AppRoutes.sellRoute)) return 2;
      if (location.startsWith(AppRoutes.profileRoute)) return 3;
    } else {
      if (location.startsWith(AppRoutes.profileRoute)) return 2;
    }
    return 0;
  }

  // ================== MORE MENU (Frosted Glass) ==================
  Future<void> _openMoreMenuDialog(BuildContext context, AuthProvider authProvider) async {
    final user = authProvider.user;
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
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 25, 
                                      backgroundColor: AppColors.primary, 
                                      child: Icon(Icons.person, color: Colors.white)
                                    ),
                                    const SizedBox(height: 5),
                                    Text(user?.username ?? "User", style: const TextStyle(fontWeight: FontWeight.bold)),
                                    Text(
                                      (user?.isSeller ?? false) ? "Seller Profile" : "Buyer Profile",
                                      style: TextStyle(
                                        fontSize: 12, 
                                        color: (user?.isSeller ?? false) ? AppColors.primary : Colors.grey,
                                        fontWeight: (user?.isSeller ?? false) ? FontWeight.bold : FontWeight.normal,
                                      )
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(indent: 20, endIndent: 20),
                              if (user?.isSeller ?? false)
                                _buildMoreItem(
                                  context: context,
                                  icon: Icons.book_outlined,
                                  text: "My Uploads",
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    context.push(AppRoutes.myUploads);
                                  },
                                ),
                              _buildMoreItem(
                                context: context,
                                icon: Icons.bookmark_border,
                                text: "Saved Materials",
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  context.push(AppRoutes.savedMaterials);
                                },
                              ),
                              _buildMoreItem(
                                context: context,
                                icon: Icons.settings_outlined,
                                text: "Settings",
                                onTap: () {
                                  Navigator.of(context, rootNavigator: true).pop();
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
                                  Navigator.of(context, rootNavigator: true).pop();
                                  _showLogoutDialog(context, authProvider);
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

  Widget _buildMoreItem({required BuildContext context, required IconData icon, required String text, required VoidCallback onTap}) {
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
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    final index = _getIndex(context, authProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          final String location = GoRouterState.of(context).uri.path;
          if (location != AppRoutes.homeRoute) {
            context.go(AppRoutes.homeRoute);
          } else {
             // SystemNavigator.pop() is fine, but double-tap to exit logic 
             // might need a StatefulWidget if we want to store _lastBackPressed
             // Or we can use a local variable in build if it's fine, but build is called often.
             // For now, let's keep it simple.
             SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        extendBody: true,
        body: child,
        bottomNavigationBar: CurvedNavigationBar(
          index: index,
          height: 65,
          backgroundColor: Colors.transparent,
          color: const Color(0xFFE1F8F8),
          buttonBackgroundColor: AppColors.primary,
          animationDuration: const Duration(milliseconds: 400),
          items: [
            CurvedNavigationBarItem(
              child: Icon(Icons.home_filled, color: index == 0 ? Colors.white : AppColors.primary),
              label: 'Home',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.search, color: index == 1 ? Colors.white : AppColors.primary),
              label: 'Search',
            ),
            if (user?.isSeller ?? false)
              CurvedNavigationBarItem(
                child: Icon(Icons.add_circle_outline, color: index == 2 ? Colors.white : AppColors.primary),
                label: 'Sell',
              ),
            CurvedNavigationBarItem(
              child: Icon(Icons.person_outline, color: ((user?.isSeller ?? false) ? index == 3 : index == 2) ? Colors.white : AppColors.primary),
              label: 'Profile',
            ),
            CurvedNavigationBarItem(
              child: Icon(Icons.menu, color: ((user?.isSeller ?? false) ? index == 4 : index == 3) ? Colors.white : AppColors.primary),
              label: 'More',
            ),
          ],
          onTap: (clickedIndex) async {
            if (user?.isSeller ?? false) {
              if (clickedIndex == 4) {
                await _openMoreMenuDialog(context, authProvider);
                return;
              }
            } else {
              if (clickedIndex == 3) {
                await _openMoreMenuDialog(context, authProvider);
                return;
              }
            }
            
            switch (clickedIndex) {
              case 0: context.go(AppRoutes.homeRoute); break;
              case 1: context.go(AppRoutes.searchRoute); break;
              case 2: 
                if (user?.isSeller ?? false) {
                  context.go(AppRoutes.sellRoute);
                } else {
                  context.go(AppRoutes.profileRoute);
                }
                break;
              case 3: 
                if (user?.isSeller ?? false) {
                  context.go(AppRoutes.profileRoute);
                }
                break;
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

void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(onPressed: () => Navigator.of(context, rootNavigator: true).pop(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            authProvider.logout();
            context.go(AppRoutes.loginRoute);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Logout", style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
