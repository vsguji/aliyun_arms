/*
 * @Author: your name
 * @Date: 2023-07-10 17:32:28
 * @LastEditTime: 2023-07-21 16:57:42
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /aliyun_arms/lib/aliyun_arms.dart
 */
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'aliyun_arms_platform_interface.dart';

class AliyunArms {
  static const MethodChannel _channel = MethodChannel(
    'io.flutter.dev/aliyun_arms',
  );

  /// 初始化
  static Future<String> init(
      {String? appkey,
      String? appVersion,
      String? appSecret,
      String? channel = '',
      String? userNick = '',
      String isAliyunos = '0',
      bool iosCrash = true,
      bool iosAPM = true,
      String isAndroidOpenDebug = '1',
      String isAndroidSupportAPM = '1',
      String isAndroidRsaSecret = ''}) async {
    assert(
      (Platform.isAndroid && appkey != null) ||
          (Platform.isIOS && appkey != null),
    );
    Map<String, Object?> map = {
      "appKey": appkey,
      "appVersion": appVersion,
      "appSecret": appSecret,
      "channel": channel,
      "userNick": userNick,
      "isAliyunos": isAliyunos,
    };
    if (Platform.isIOS) {
      map['iosCrash'] = true;
      map['iosAPM'] = true;
    } else if (Platform.isAndroid) {
      map['isAndroidOpenDebug'] = isAndroidOpenDebug;
      map['isAndroidSupportAPM'] = isAndroidSupportAPM;
      map['isAndroidRsaSecret'] = isAndroidRsaSecret;
    }
    final dynamic result = await _channel.invokeMethod('initAliyunArms', map);
    return result;
  }

  ///
  static void postCatchedException<T>(
    T Function() callback, {
    FlutterExceptionHandler? onException,
    String? filterRegExp,
    bool debugUpload = false,
  }) {
    bool isDebug = false;
    assert(isDebug = true);
    Isolate.current.addErrorListener(RawReceivePort((dynamic pair) {
      var isolateError = pair as List<dynamic>;
      var error = isolateError.first;
      var stackTrace = isolateError.last;
      Zone.current.handleUncaughtError(error, stackTrace);
    }).sendPort);

    FlutterError.onError = (details) {
      if (details.stack != null) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        FlutterError.presentError(details);
      }
    };

    runZonedGuarded<Future<void>>(() async {
      callback();
    }, (error, stackTrace) {
      _filterAndUploadException(
        debugUpload,
        isDebug,
        onException,
        filterRegExp,
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
    });
  }

  ///
  static void _filterAndUploadException(
    debugUpload,
    isDebug,
    handler,
    filterRegExp,
    FlutterErrorDetails details,
  ) {
    if (!_filterException(
      debugUpload,
      isDebug,
      handler,
      filterRegExp,
      details,
    )) {
      uploadExceptionToArms(
          message: details.exception.toString(),
          detail: details.stack.toString());
    }
  }

  ///
  static Future<void> uploadExceptionToArms({
    required String message,
    required String detail,
    Map? data,
  }) async {
    var map = {};
    map.putIfAbsent('key', () => message);
    map.putIfAbsent('value', () => detail);
    if (data != null) map.putIfAbsent('crash_data', () => json.encode(data));
    await _channel.invokeMethod('uploadException', map);
  }

  static bool _filterException(
    bool debugUpload,
    bool isDebug,
    FlutterExceptionHandler? handler,
    String? filterRegExp,
    FlutterErrorDetails details,
  ) {
    if (handler != null) {
      handler(details);
    } else {
      FlutterError.onError?.call(details);
    }

    if (!debugUpload && isDebug) {
      return true;
    }

    if (filterRegExp != null) {
      RegExp reg = RegExp(filterRegExp);
      Iterable<Match> matches = reg.allMatches(details.exception.toString());
      if (matches.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  ///
  Future<String?> getPlatformVersion() {
    return AliyunArmsPlatform.instance.getPlatformVersion();
  }

  ///
  static Future<String?> getInitArms(Map<String, dynamic> parameter) async {
    final isOK = AliyunArmsPlatform.instance.getInitArms(parameter);
    return isOK;
  }

  ///
  static Future<String?> uploadError(String msg) async {
    final isOK = AliyunArmsPlatform.instance.uploadError(msg);
    return isOK;
  }

  ///
  static Future<String?> uploadException(Map<String, dynamic> parameter) async {
    final isOK = AliyunArmsPlatform.instance.uploadException(parameter);
    return isOK;
  }

  ///
  static Future<String?> uploadCustomer(Map<String, dynamic> parameter) async {
    final isOK = AliyunArmsPlatform.instance.uploadCustomer(parameter);
    return isOK;
  }

  ///
  static Future<String?> uploadTest() async {
    final isOK = AliyunArmsPlatform.instance.uploadTest();
    return isOK;
  }
}
