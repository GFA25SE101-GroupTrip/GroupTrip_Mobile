// lib/routes/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/auth/presentation/screens/login_screen.dart';
import 'package:group_trip/features/auth/presentation/screens/register_screen.dart';
import 'package:group_trip/features/blog/presentation/blog_screen.dart';
import 'package:group_trip/shared/main_layout.dart';


final appRouter = GoRouter(
  routes: [
    // Route có layout chung (Home / Trip / Profile)
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const BlogScreen(),
        ),
        // GoRoute(
        //   path: '/trips',
        //   builder: (context, state) => const TripScreen(),
        // ),
        // GoRoute(
        //   path: '/profile',
        //   builder: (context, state) => const ProfileScreen(),
        // ),
      ],
    ),

    // Route riêng (không dùng layout)
    GoRoute(
      path: '/signin',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);

// Layout Wrapper cho ShellRoute
