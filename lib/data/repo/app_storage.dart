import 'package:shared_preferences/shared_preferences.dart';

const String _languageKey = 'language';
const String _defaultLanguage = 'en_US';

class AppStorage {
  AppStorage({
    required Storage storage,
  }) : _storage = storage;

  final Storage _storage;

  Future<void> saveLanguage(String language) async {
    try {
      await _storage.write(key: _languageKey, value: language);
    } catch (e) {
      throw 'Something went wrong';
    }
  }

  Future<String> getLanguage() async {
    try {
      final response = await _storage.read(key: _languageKey);

      if (response == null) {
        return _defaultLanguage;
      }
      return response;
    } catch (e) {
      return _defaultLanguage;
    }
  }
}

abstract class Storage {
  Future<String?> read({required String key});

  Future<void> write({required String key, required String value});

  Future<void> delete({required String key});

  Future<void> clear();
}

class PersistentStorage implements Storage {
  const PersistentStorage({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  @override
  Future<void> clear() {
    try {
      return _sharedPreferences.clear();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }

  @override
  Future<void> delete({required String key}) {
    try {
      return _sharedPreferences.remove(key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }

  @override
  Future<String?> read({required String key}) async {
    try {
      return _sharedPreferences.getString(key);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }

  @override
  Future<void> write({required String key, required String value}) {
    try {
      return _sharedPreferences.setString(key, value);
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(StorageException(error), stackTrace);
    }
  }
}

class StorageException implements Exception {
  final Object error;

  const StorageException(this.error);
}
