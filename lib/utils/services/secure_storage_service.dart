import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = FlutterSecureStorage();
  Future<void> writeSecureData({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }
  Future<String> readSecureData({required String key}) async {
    String? readData = await _storage.read(key: key);
    return readData ?? "";
  }
  Future<void> deleteSecureData({required String key}) async {
    await _storage.delete(key: key);
  }
}