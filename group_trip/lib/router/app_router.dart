import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/auth/presentation/screens/login_screen.dart';
import 'package:group_trip/features/auth/presentation/screens/register_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/signin', builder: (context, state) => const LoginScreen()),

    // /detail/:id -> example
    // GoRoute(
    //   path: '/detail/:id',
    //   builder: (context, state) {
    //     final id = state.params['id']!;
    //     return DetailScreen(id: id); // tạo file này nếu cần
    //   },
    // ),
  ],
);
