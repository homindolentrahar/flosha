import 'package:hive_flutter/adapters.dart';

abstract class CacheConstants {
  static const String appCache = "app_cache";
}

class CacheHelper {
  late Box<dynamic> _cacheManager;

  CacheHelper._() {
    _cacheManager = Hive.box<dynamic>(CacheConstants.appCache);
  }

  factory CacheHelper.create() => CacheHelper._();

  static initialize() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(CacheConstants.appCache);
  }

  Future<void> saveCache({
    required String key,
    required dynamic data,
  }) async {
    await _cacheManager.put(key, data ?? {});
  }

  dynamic getCache(String key) {
    return _cacheManager.get(key);
  }

  Future<void> removeCache(String key) {
    return _cacheManager.delete(key);
  }

  Future<void> cleate() {
    return _cacheManager.clear();
  }
}
