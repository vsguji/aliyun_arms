#import "AliyunArmsPlugin.h"
#import <AlicloudCrash/AlicloudCrashProvider.h>
//
#import <AlicloudHAUtil/AlicloudHAProvider.h>
#import <AlicloudAPM/AlicloudAPMProvider.h>
//
#import <TRemoteDebugger/TRDManagerService.h>
#import <TRemoteDebugger/TLogBiz.h>
#import <TRemoteDebugger/TLogFactory.h>
#import <TRemoteDebugger/TRDManagerService.h>
@implementation AliyunArmsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"io.flutter.dev/aliyun_arms"
            binaryMessenger:[registrar messenger]];
  AliyunArmsPlugin* instance = [[AliyunArmsPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } if ([@"initAliyunArms" isEqualToString:call.method]) {
      NSDictionary *config = (NSDictionary *)call.arguments;
      bool isOk = [[config objectForKey:@"iosCrash"] boolValue];
      if (isOk) {
          isOk = [self  configCrash:call.arguments];
      }
      isOk = [[config objectForKey:@"iosAPM"] boolValue];
      if (isOk) {
          [self configAPM:config];
      }
      NSString *str = isOk ? @"ok" : @"fail";
      result(str);
  } else if ([@"uploadError" isEqualToString:call.method]) {
      NSString *isOk =  [self uploadError:call.arguments];
      result(isOk);
  }else if ([@"uploadException" isEqualToString:call.arguments]) {
      NSString *isOk =  [self uploadException:call.arguments];
      result(isOk);
  } else if ([@"logLevel" isEqualToString:call.method]) {
      NSDictionary *config = (NSDictionary *)call.arguments;
      NSString *content = [config objectForKey:@"logContent"];
      bool isOk = [[config objectForKey:@"levelBug"] boolValue];
      if (isOk) {
          [self logDebug:content];
      }
      isOk = [[config objectForKey:@"levelInfo"] boolValue];
      if (isOk) {
          [self logInfo:content];
      }
      isOk = [[config objectForKey:@"levelWarning"] boolValue];
      if (isOk) {
          [self logWarning:content];
      }
      isOk = [[config objectForKey:@"levelError"] boolValue];
      if (isOk) {
          [self logError:content];
      }
  } else if ([@"uploadTest" isEqualToString:call.method]) {
      [self test];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

//----------------------------------------------------------------------------------------------------------------------\\
///  初始化

- (NSString *)configCrash:(NSDictionary *)config {
   // NSString *appKey = [config objectForKey:@"appKey"];
   // NSString *appSecret = [config objectForKey:@"appSecret"];
    NSString *appVersion = [config objectForKey:@"appVersion"];
    NSString *channel = [config objectForKey:@"channel"];
    NSString *nick = [config objectForKey:@"userNick"];
    [[AlicloudCrashProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
    [AlicloudHAProvider start];
    [TRDManagerService updateLogLevel:TLogLevelDebug];
    return  @"ok";
}

/// 上传报错
- (NSString *)uploadError:(NSString *)str {
    return @"ok";
}

/// 上报异常
- (NSString *)uploadException:(NSDictionary *)dic {
    [AlicloudCrashProvider setCrashCallBack:^NSDictionary * _Nonnull(NSString * _Nonnull type) {
        if ([@"" isEqualToString:type]) {
            
        }
        return dic;
    }];
    return @"ok";
}

/// 上报自定义类型
- (NSString *)uploadCustomer:(NSDictionary *)dic {
    [AlicloudCrashProvider reportCustomError:[NSError errorWithDomain:NSOSStatusErrorDomain code:400 userInfo:@{}]];
    return @"ok";
}

//----------------------------------------------------------------------------------------------------------------------\\
// 性能
- (void)configAPM:(NSDictionary *)config {
    NSString *appVersion = [config objectForKey:@"appVersion"];
    NSString *channel = [config objectForKey:@"channel"];
    NSString *nick = [config objectForKey:@"userNick"];
    [[AlicloudAPMProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
    [AlicloudHAProvider start];
}

//----------------------------------------------------------------------------------------------------------------------\\
// 日志
- (void)logDebug:(NSString *)debug {
    // 获取应用名称
    TLogBiz *log = [TLogFactory createTLogForModuleName:@"AliyunArmsPlugin"];
    [log debug:debug];
}

- (void)logInfo:(NSString *)info {
    // 获取应用名称
    TLogBiz *log = [TLogFactory createTLogForModuleName:@"AliyunArmsPlugin"];
    [log info:info];
}

- (void)logWarning:(NSString *)warning {
    // 获取应用名称
    TLogBiz *log = [TLogFactory createTLogForModuleName:@"AliyunArmsPlugin"];
    [log warn:warning];
}

- (void)logError:(NSString *)error {
    // 获取应用名称
    TLogBiz *log = [TLogFactory createTLogForModuleName:@"AliyunArmsPlugin"];
    [log error:error];
}


- (void)test {
    NSMutableArray *array = @[];
    [array addObject:nil];
}
@end
