import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/app_init_provider.dart';
import 'package:group_trip/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Create a ProviderContainer to run initial async providers before the
  // app's widgets are built. This avoids changing provider state during the
  // first widget build (which can cause rebuild-time errors).
  final container = ProviderContainer();
  // Run app initialization (restore session, etc.) before runApp
  try {
    await container.read(appInitProvider.future);
  } catch (e) {
    // ignore init error here; the app can still start and show an error UI
    print('⚠️ App init failed: $e');
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
    );
  }
}
