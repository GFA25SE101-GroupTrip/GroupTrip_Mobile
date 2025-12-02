import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:group_trip/core/config/secure_storage_service.dart';

/// Provider that exposes a single SecureStorageService instance.
final secureStorageProvider = Provider((ref) => SecureStorageService());
