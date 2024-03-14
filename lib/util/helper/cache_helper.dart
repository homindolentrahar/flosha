import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

abstract class CacheConstants {
  static const String appCache = "app_cache";
}

class CacheHelper {
  late Box<Map<String, dynamic>> _cacheManager;

  CacheHelper._() {
    _cacheManager = Hive.box<Map<String, dynamic>>(CacheConstants.appCache);
  }

  factory CacheHelper.create() => CacheHelper._();

  static initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();
    await Hive.openBox<Map<String, dynamic>>(CacheConstants.appCache);
  }

  Future<void> saveCache({
    required String key,
    required Map<String, dynamic>? data,
  }) async {
    await _cacheManager.put(key, data ?? {});
  }

  Map<String, dynamic> getCache(String key) {
    return _cacheManager.get(key) ?? {};
  }

  Future<void> removeCache(String key) {
    return _cacheManager.delete(key);
  }

  Future<void> cleate() {
    return _cacheManager.clear();
  }
}
