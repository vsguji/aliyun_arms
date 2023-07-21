/*
 * @Author: your name
 * @Date: 2023-07-10 17:32:28
 * @LastEditTime: 2023-07-20 15:51:08
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /aliyun_arms/lib/aliyun_arms_platform_interface.dart
 */
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'aliyun_arms_method_channel.dart';

abstract class AliyunArmsPlatform extends PlatformInterface {
  /// Constructs a AliyunArmsPlatform.
  AliyunArmsPlatform() : super(token: _token);

  static final Object _token = Object();

  static AliyunArmsPlatform _instance = MethodChannelAliyunArms();

  /// The default instance of [AliyunArmsPlatform] to use.
  ///
  /// Defaults to [MethodChannelAliyunArms].
  static AliyunArmsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AliyunArmsPlatform] when
  /// they register themselves.
  static set instance(AliyunArmsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// 初始化
  Future<String?> getInitArms(Map<String, dynamic> parameter) {
    throw UnimplementedError('getInitArms() has not been implemented.');
  }

  /// 上报错误
  Future<String?> uploadError(String msg) {
    throw UnimplementedError('getUploadError() has not been implemented.');
  }

  /// 上报异常
  Future<String?> uploadException(Map<String, dynamic> parameter) {
    throw UnimplementedError('getUploadException() has not been implemented.');
  }

  /// 上报自定义异常类型
  Future<String?> uploadCustomer(Map<String, dynamic> parameter) {
    throw UnimplementedError('getInitArms() has not been implemented.');
  }

  /// 测试
  Future<String?> uploadTest() {
    throw UnimplementedError('uploadTest() has not been implemented.');
  }
}
