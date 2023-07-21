package com.jufubao.mendianhexiao;

import android.content.res.Configuration;
import android.util.Log;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class MainActivity extends FlutterActivity {
    //
    private  String TAG = "MainActivity";
    //
    private String kAliyunArms = "io.flutter.dev/aliyunArms";
    //
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    //
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
    }
    /**
     * 测试
     */
    int time = 0;
    public void uploadTest() {
        assert(time > 0);
        throw new NullPointerException();
    }
}
