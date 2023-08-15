package com.pengsheng.aliyun_arms;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.alibaba.ha.adapter.AliHaAdapter;
import com.alibaba.ha.adapter.AliHaConfig;
import com.alibaba.ha.adapter.Plugin;
import com.alibaba.ha.adapter.service.tlog.TLogService;
import com.alibaba.ha.protocol.crash.ErrorCallback;
import com.alibaba.ha.protocol.crash.ErrorInfo;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AliyunArmsPlugin */
public class AliyunArmsPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  //
  private String  TAG = "AliyunArmsPlugin";
  private static MethodChannel channel;
  //
  @SuppressLint("StaticFieldLeak")
  private static Activity activity;
  //
  private FlutterPluginBinding flutterPluginBinding;
  //
  private static String channelName = "io.flutter.dev/aliyun_arms";
  //
  AliHaConfig config = null;
  /**
   * 注册
   */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(),channelName);
    AliyunArmsPlugin plugin = new AliyunArmsPlugin();
    channel.setMethodCallHandler(plugin);
    activity = registrar.activity();
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), channelName);
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("initAliyunArms")) {
      new Thread(new Runnable() {
        @Override
        public void run() {
          Map<String, Object> parameter = (Map<String, Object>) call.arguments;
          boolean isOk =  configCrash(parameter);
          if (isOk) {
            result.success("ok");
          }
          else {
            result.error("404", "初始化失败", "初始化失败");
          }
        }
      }).start();
    } else if (call.method.equals("uploadError")) {
      uploadError((String) call.arguments);
      result.success("ok");
    } else if (call.method.equals("uploadException")) {
      Map<String,Object> parameter = (Map<String, Object>) call.arguments;
      String key = (String) parameter.get("key");
      String value = (String) parameter.get("value");
      uploadExcetion(key,value);
      result.success("ok");
    } else if (call.method.equals("uploadCustomer")) {
      Map<String,Object> parameter = (Map<String, Object>) call.arguments;
      String key = (String) parameter.get("key");
      String value = (String) parameter.get("value");
      uploadCustomer(key,value);
      result.success("ok");
    } else if (call.method.equals("uploadTest")) {
      uploadTest();
      result.success("ok");
    } else if (call.method.equals("uploadLevel")) {
      Map<String,Object> parameter = (Map<String, Object>) call.arguments;
      String module = parameter.get("module").toString();
      String tag = parameter.get("tag").toString();
      String message = parameter.get("message").toString();
      int level = Integer.valueOf( parameter.get("level").toString());
      switch (level) {
        case 1:
          logLevelV(module,tag,message);
          break;
        case 2:
          logLevelD(module,tag,message);
          break;
        case 3:
          logLevelI(module,tag,message);
          break;
        case 4:
          logLevelW(module,tag,message);
          break;
        case 5:
          logLevelE(module,tag,message);
          break;
      }
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    this.flutterPluginBinding = null;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
     activity = binding.getActivity();
     channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(),channelName);
     channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  private AliHaConfig getInstance() {
    if (config == null) {
      config = new AliHaConfig();
    }
    return  config;
  }

  //---------------------------------------------------------------------------------\\
  // 崩溃、性能

  /**
   * 配置崩溃、性能分析服务
   */
  public boolean configCrash(Map<String,Object> parameter){
    AliHaConfig config = getInstance();
    try {
      config.appKey = parameter.get("appKey").toString();
      config.appVersion = parameter.get("appVersion").toString();
      config.appSecret = parameter.get("appSecret").toString();
      config.channel = parameter.get("channel").toString();
      config.userNick = parameter.get("userNick").toString();
      config.application = activity.getApplication();
      config.context = activity.getApplicationContext();
      config.isAliyunos = parameter.get("isAliyunos").equals("1");
      Boolean isSupportAPM = parameter.get("isAndroidSupportAPM").equals("1");
      if (isSupportAPM) {
        config.rsaPublicKey = parameter.get("isAndroidRsaSecret").toString();
        AliHaAdapter.getInstance().addPlugin(Plugin.apm);
      }
      boolean isOpenDebug = parameter.get("isAndroidOpenDebug").equals("1");
      if (isOpenDebug) {
        AliHaAdapter.getInstance().addPlugin(Plugin.tlog);
        AliHaAdapter.getInstance().openDebug(isOpenDebug);
      }
      AliHaAdapter.getInstance().addPlugin(Plugin.crashreporter);
    }catch (Exception e) {
      TLogService.loge("initConfig",TAG,e.getMessage());
    }
    AliHaAdapter.getInstance().openHttp(true);
    AliHaAdapter.getInstance().openDebug(true);
    return AliHaAdapter.getInstance().start(config);
  }

  /**
   * 上报自定义信息
   */
  public void uploadCustomer(String key, String value) {
    AliHaAdapter.getInstance().addCustomInfo(key,value);
  }

  /**
   * 按异常类型上报自定义信息
   */
  public void uploadExcetion(String key, String value) {
    AliHaAdapter.getInstance().setErrorCallback(new ErrorCallback() {
      @Override
      public Map<String, String> onError(ErrorInfo errorInfo) {
        Map<String,String> infos = new HashMap<>();
        infos.put(key,value);
        return infos;
      }
    });
  }

  /**
   * 上报自定义错误
   */
  public void uploadError(String customError) {
    AliHaAdapter.getInstance().reportCustomError(new RuntimeException(customError));
  }

  //---------------------------------------------------------------------------------\\
  // 远程日志
  /**
   * 打开调试模式
   */
  public void openDebug(boolean status) {
    AliHaConfig config = getInstance();
    AliHaAdapter.getInstance().openDebug(status);
  }

  /**
   * 调试详情
   */
  public void logLevelV(String model,String tag,String message) {
    TLogService.logv(model,tag,message);
  }

  /**
   * 调试
   */
  public void logLevelD(String model,String tag,String message) {
    TLogService.logd(model,tag,message);
  }

  /**
   * 一般信息
   */
  public void logLevelI(String model,String tag,String message) {
    TLogService.logd(model,tag,message);
  }

  /**
   * 警告
   */
  public void logLevelW(String model,String tag,String message) {
    TLogService.logw(model,tag,message);
  }

  /**
   * 错误
   */
  public void logLevelE(String model,String tag,String message) {
    TLogService.loge(model,tag,message);
  }

  //---------------------------------------------------------------------------------\\
  // 测试

  /**
   * 测试崩溃
   */
  public void uploadTest() {
    throw new NullPointerException();
  }
}
