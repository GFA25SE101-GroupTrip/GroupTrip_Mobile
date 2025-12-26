import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/core/providers/app_init_provider.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';
import 'package:group_trip/features/auth/data/user_api.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';
import 'package:group_trip/router/app_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// =====================
/// FCM Background Handler
/// =====================
/// ⚠️ CHỈ xử lý data, KHÔNG show notification
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('📩 Background message data: ${message.data}');
}

/// =====================
/// Main
/// =====================
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  /// Firebase init
  await Firebase.initializeApp();

  /// Register background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// Request notification permission
  final settings = await FirebaseMessaging.instance.requestPermission();
  debugPrint('🔔 Permission: ${settings.authorizationStatus}');

  /// Get FCM token
  final token = await FirebaseMessaging.instance.getToken();
  debugPrint('🔥 FCM Token: $token');

  if (token != null) {
    await SecureStorageService().saveFcmToken(token);
    debugPrint('✅ FCM Token saved');
  }

  /// Foreground messages
  /// ❌ Android không auto show notification khi foreground
  FirebaseMessaging.onMessage.listen((message) {
    debugPrint('📨 Foreground message');
    debugPrint('📦 Notification: ${message.notification}');
    debugPrint('📦 Data: ${message.data}');
    // 👉 nếu muốn: show in-app banner / badge
  });

  /// Click notification (background / kill)
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    debugPrint('👉 Notification clicked');
    debugPrint('📦 Data: ${message.data}');
    // TODO: navigate bằng go_router dựa vào message.data
  });

  /// Date formatting
  try {
    await initializeDateFormatting('vi');
    Intl.defaultLocale = 'vi';
  } catch (e) {
    debugPrint('⚠️ Date formatting failed: $e');
  }

  /// Provider init
  final container = ProviderContainer();
  try {
    await container.read(appInitProvider.future);
  } catch (e) {
    debugPrint('⚠️ App init failed: $e');
  }

  /// FCM token refresh listener
  final fcmDataSource =
      FcmTokenRemoteDataSource(api: container.read(apiClientProvider));
  container.read(setupFCMProvider(fcmDataSource));
  debugPrint('✅ FCM token refresh listener setup');

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

/// =====================
/// App
/// =====================
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
