/*
 * @Author: your name
 * @Date: 2023-07-10 17:32:28
 * @LastEditTime: 2023-08-14 15:44:01
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /aliyun_arms/example/lib/main.dart
 */
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:aliyun_arms/aliyun_arms.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AliyunArms.init(
      appkey: '333871883',
      appVersion: 'V1.0.1',
      appSecret: '457e37fe28404aaca94500e1b4191dd4',
      isAndroidRsaSecret:
          'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCR4I3JYsfArCw1f025qpuaeTU0cPC6VDwMGPfDeGLyAM432wXZMvFIm2U2w78t3f/WenL8zUYZ6AgTgOapuY3h8vGm5V4HI8/QzDXl+lHhkq+Vhlvi2upkwdVicFborBHVjSdvJK9Z97+JHyl6syJ1xDZ8OkYz5UjKiP29LDjDAQIDAQAB',
      channel: 'huawei',
      userNick: 'mendianHexiao',
      isAliyunos: '0');
  AliyunArms.postCatchedException(() => runApp(const MyApp()),
      debugUpload: true);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _aliyunArmsPlugin = AliyunArms();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _aliyunArmsPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          Center(
            child: Text('Running on: $_platformVersion\n'),
          ),
          TextButton(
              onPressed: () async {
                String isok = await AliyunArms.init(
                    appkey: '333871883',
                    appVersion: 'V1.0.1',
                    appSecret: '457e37fe28404aaca94500e1b4191dd4',
                    isAndroidRsaSecret:
                        'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCR4I3JYsfArCw1f025qpuaeTU0cPC6VDwMGPfDeGLyAM432wXZMvFIm2U2w78t3f/WenL8zUYZ6AgTgOapuY3h8vGm5V4HI8/QzDXl+lHhkq+Vhlvi2upkwdVicFborBHVjSdvJK9Z97+JHyl6syJ1xDZ8OkYz5UjKiP29LDjDAQIDAQAB',
                    channel: 'huawei',
                    userNick: 'mendianHexiao',
                    isAliyunos: '0');
                if (isok == 'ok') {
                  // ignore: use_build_context_synchronously
                }
              },
              child: const Text('initAliyunArms')),
          TextButton(
              onPressed: () {
                AliyunArms.uploadCustomer({'key': 'key01', 'value': 'value01'});
              },
              child: const Text('upload Customer')),
          TextButton(
              onPressed: () {
                // AliyunArms.uploadException(
                //     {'key': 'key02', 'value': 'value02'});
              },
              child: const Text('upload Exception')),
          TextButton(
              onPressed: () {
                Get.bottomSheet(Column(
                  children: [const Text('test').sliverBox],
                ));
                AliyunArms.uploadError('上传失败');
              },
              child: const Text('upload Error')),
          TextButton(
              onPressed: () {
                AliyunArms.uploadTest();
              },
              child: const Text('upload Test'))
        ]),
      ),
    );
  }
}
