/*
 * @Author: your name
 * @Date: 2023-07-10 17:32:28
 * @LastEditTime: 2023-07-17 09:28:58
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /aliyun_arms/lib/aliyun_arms_method_channel.dart
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'aliyun_arms_platform_interface.dart';

/// An implementation of [AliyunArmsPlatform] that uses method channels.
class MethodChannelAliyunArms extends AliyunArmsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('io.flutter.dev/aliyun_arms');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getInitArms(Map<String, dynamic> parameter) async {
    final isOK = await methodChannel.invokeMethod('initAliyunArms', parameter);
    return isOK;
  }

  @override
  Future<String?> uploadError(String msg) async {
    final isOK = await methodChannel.invokeMethod('uploadError', msg);
    return isOK;
  }

  @override
  Future<String?> uploadException(Map<String, dynamic> parameter) async {
    final isOK = await methodChannel.invokeMethod('uploadException', parameter);
    return isOK;
  }

  @override
  Future<String?> uploadCustomer(Map<String, dynamic> parameter) async {
    final isOK = await methodChannel.invokeMethod('uploadCustomer', parameter);
    return isOK;
  }

  @override
  Future<String?> uploadTest() async {
    final isOK = await methodChannel.invokeMethod('uploadTest');
    return isOK;
  }
}
