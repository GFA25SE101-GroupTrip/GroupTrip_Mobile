import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/api/api_client.dart';
import 'package:group_trip/core/providers/api_client_provider.dart';
import 'package:group_trip/core/providers/app_init_provider.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';
import 'package:group_trip/features/auth/data/user_api.dart';
import 'package:group_trip/features/auth/providers/user_provider.dart';
import 'package:group_trip/router/app_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
// Hàm xử lý notification khi app đang background
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // 🟦 Firebase init (KHÔNG có firebase_options.dart)
  await Firebase.initializeApp();

  // 🟥 Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🟩 Request notification permission (Android 13+ + iOS)
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();
  print("🔔 Permission: ${settings.authorizationStatus}");

  // 🟨 Get FCM token
  final token = await FirebaseMessaging.instance.getToken();
  print("🔥 FCM Token: $token");
  
  // 💾 Save FCM token to secure storage
  if (token != null) {
    await SecureStorageService().saveFcmToken(token);
    print("✅ FCM Token saved to storage");
  }

  // 🟦 Foreground notifications
  FirebaseMessaging.onMessage.listen((message) {
    print("📨 Foreground: ${message.notification?.title}");
  });

  // date formatting
  try {
    await initializeDateFormatting('vi');
    Intl.defaultLocale = 'vi';
  } catch (e) {
    print('⚠️ initializeDateFormatting failed: $e');
  }

  // provider init
  final container = ProviderContainer();
  try {
    await container.read(appInitProvider.future);
  } catch (e) {
    print('⚠️ App init failed: $e');
  }

  // 🔄 Setup FCM token refresh listener from UserProvider
  final fcmDataSource = FcmTokenRemoteDataSource(api: container.read(apiClientProvider));
  container.read(setupFCMProvider(fcmDataSource));
  print("✅ FCM token refresh listener setup from UserProvider");

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
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
