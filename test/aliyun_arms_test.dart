/*
 * @Author: your name
 * @Date: 2023-07-10 17:32:28
 * @LastEditTime: 2023-07-17 09:29:11
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /aliyun_arms/test/aliyun_arms_test.dart
 */
import 'package:flutter_test/flutter_test.dart';
import 'package:aliyun_arms/aliyun_arms.dart';
import 'package:aliyun_arms/aliyun_arms_platform_interface.dart';
import 'package:aliyun_arms/aliyun_arms_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAliyunArmsPlatform
    with MockPlatformInterfaceMixin
    implements AliyunArmsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getInitArms(Map<String, dynamic> parameter) {
    // TODO: implement getInitArms
    throw UnimplementedError();
  }

  @override
  Future<String?> uploadCustomer(Map<String, dynamic> parameter) {
    // TODO: implement uploadCustomer
    throw UnimplementedError();
  }

  @override
  Future<String?> uploadError(String msg) {
    // TODO: implement uploadError
    throw UnimplementedError();
  }

  @override
  Future<String?> uploadException(Map<String, dynamic> parameter) {
    // TODO: implement uploadException
    throw UnimplementedError();
  }
  
  @override
  Future<String?> uploadTest() {
    // TODO: implement uploadTest
    throw UnimplementedError();
  }
}

void main() {
  final AliyunArmsPlatform initialPlatform = AliyunArmsPlatform.instance;

  test('$MethodChannelAliyunArms is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAliyunArms>());
  });

  test('getPlatformVersion', () async {
    AliyunArms aliyunArmsPlugin = AliyunArms();
    MockAliyunArmsPlatform fakePlatform = MockAliyunArmsPlatform();
    AliyunArmsPlatform.instance = fakePlatform;

    expect(await aliyunArmsPlugin.getPlatformVersion(), '42');
  });
}
