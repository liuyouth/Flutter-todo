
import 'package:flutter/services.dart';

class VersionUtils{
  static const MethodChannel _channel = const MethodChannel('version');

  /// 应用安装
  static void install(String path){
    _channel.invokeMethod("install", {'path': path});
  }

  /// AppStore跳转
  static void jumpAppStore(){
    _channel.invokeMethod("jumpAppStore");
  }
  /// 原生View 跳转由于第三方SDK不支持缘故 采用原生去显示广告页面
  /// 获取金币弹框  签到弹框
  static void jumpNative() {
    _channel.invokeMethod("jumpNative");
  }
}