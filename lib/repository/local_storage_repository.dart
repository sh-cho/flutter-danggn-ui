import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository {
  final storage = const FlutterSecureStorage();

  Future<String> get(String key) async {
    try {
      return await storage.read(key: key) ?? "";
    } catch (err) {
      debugPrint("get failed / err: $err");
      return "";
    }
  }

  Future<void> set(String key, String value) async {
    try {
      return await storage.write(key: key, value: value);
    } catch (err) {
      debugPrint("set failed / err: $err");
      return;
    }
  }
}
