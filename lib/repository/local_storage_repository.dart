import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository {
  final storage = const FlutterSecureStorage();

  Future<String> get(String key) async {
    debugPrint("--- get $key");

    try {
      return await storage.read(key: key) ?? "";
    } catch (err) {
      debugPrint("get failed / err: $err");
      return "";
    }
  }

  Future<void> set(String key, String value) async {
    debugPrint("--- set $key: $value");

    try {
      await storage.write(key: key, value: value);
    } catch (err) {
      debugPrint("set failed / err: $err");
    }
  }

  /// 특정 set(list)에 value 추가
  Future<void> add(String setKey, String value) async {
    debugPrint("--- add $setKey: $value");

    try {
      String setStr = await get(setKey);
      List<dynamic> decoded = (setStr.isEmpty ? [] : jsonDecode(setStr));
      decoded.add(int.parse(value));
      set(setKey, jsonEncode(decoded));
    } catch (err) {
      debugPrint("add failed / err: $err");
    }
  }

  Future<void> remove(String setKey, String value) async {
    debugPrint("--- remove $setKey $value");

    try {
      String setStr = await get(setKey);
      if (setStr.isEmpty) {
        return;
      }

      List<dynamic> decoded = jsonDecode(setStr);
      decoded.remove(int.parse(value));
      set(setKey, jsonEncode(decoded));
    } catch (err) {
      debugPrint("add failed / err: $err");
    }
  }
}
