package com.jufubao.mendianhexiao;

import android.Manifest;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

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
        handlePermission();
        super.configureFlutterEngine(flutterEngine);
    }

    /**
     * 检查app是否拥有存储权限，如果没有的话，提醒用户开启权限
     */
    public void handlePermission() {
        // 检查是否开启 Manifest.permission.xxx
        // (xxx 为权限，根据自己需求添加）
        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.INTERNET) == PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(this, "Permission has been allowed", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "ask for permission",Toast.LENGTH_SHORT).show();
            // 请求权限
            ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.INTERNET}, 1);
            Log.d(TAG, "handlePermission: has aksed");
        }
        //
        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(this, "Permission has been allowed", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "ask for permission",Toast.LENGTH_SHORT).show();
            // 请求权限
            ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.READ_EXTERNAL_STORAGE}, 1);
            Log.d(TAG, "handlePermission: has aksed");
        }
        //
        if (ActivityCompat.checkSelfPermission(this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
            Toast.makeText(this, "Permission has been allowed", Toast.LENGTH_SHORT).show();
        } else {
            Toast.makeText(this, "ask for permission",Toast.LENGTH_SHORT).show();
            // 请求权限
            ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
            Log.d(TAG, "handlePermission: has aksed");
        }
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
