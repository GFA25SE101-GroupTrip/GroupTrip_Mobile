import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:group_trip/features/auth/data/user_model.dart';
import 'package:group_trip/features/auth/presentation/screens/login_screen.dart';
import 'package:group_trip/features/auth/presentation/screens/register_screen.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';
import 'package:group_trip/features/blog/presentation/blog_screen.dart';
import 'package:group_trip/features/profile/presentation/profile_detail_screen.dart';
import 'package:group_trip/features/profile/presentation/profile_screen.dart';
import 'package:group_trip/shared/main_layout.dart';

final goRouterProvider = Provider<GoRouter>((ref) {

  final authState = ref.watch(authNotifierProvider);
  String? redirectLogin(GoRouterState state) {
    final loggedIn = authState is AsyncData && authState.value != null;
    final location = state.uri.toString();
  final loggingIn = location == '/' || location == '/signup';
    // debug
    // ignore: avoid_print
    print('router redirect check: loggedIn=$loggedIn, location=$location');

    if (!loggedIn && !loggingIn) {
      // not logged in -> go to login ('/')
      // ignore: avoid_print
      print('redirecting to /');
      return '/';
    }

    if (loggedIn && (location == '/' || location == '/signup')) {
      // already logged in -> go to blog
      // ignore: avoid_print
      print('redirecting to /blog');
      return '/blog';
    }

    return null;
  }
  return GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/blog',
            builder: (context, state) => const BlogScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          
        ],
      ),
      GoRoute(
            path: '/profile/detail',
            builder: (context, state) => const ProfileDetailScreen(),
          ),
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const RegisterScreen(),
      ),
    ],
    redirect:(context, state) => redirectLogin(state),
    refreshListenable: ref.watch(authNotifierProvider.notifier).listenable,
  );
});

