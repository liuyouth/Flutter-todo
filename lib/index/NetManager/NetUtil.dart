import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:task/common/common.dart';
import 'package:task/index/NetManager/ExceptionHandle.dart';
import 'package:task/index/NetManager/NetCore.dart';
import 'package:task/index/NetManager/NetManager.dart';
import 'package:task/index/NetManager/Result.dart';
import 'package:task/index/page/task/task.dart';
import 'package:task/util/log_utils.dart';
import 'package:rxdart/rxdart.dart';

/// 网络请求实际发起工具类
class NetUtil {
  static final NetUtil _singleton = NetUtil._internal();
  static NetUtil get instance => NetUtil();
  factory NetUtil() {
    return _singleton;
  }
  static Dio _dio;
  Dio getDio() {
    return _dio;
  }

  NetUtil._internal() {
    var options = BaseOptions(
        connectTimeout: 15000,
        receiveTimeout: 15000,
        responseType: ResponseType.plain,
        validateStatus: (status) {
          // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
          return true;
        },
        baseUrl: NetManager.HOST,
        contentType: "application/json;charset=UTF-8"
//      contentType: ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8'),
        );
    _dio = Dio(options);

    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());

    /// 刷新Token
    _dio.interceptors.add(TokenInterceptor());

    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }
  //    return Observable.fromFuture(
  //        NetUtil.instance.requestNetwork<T>(method, url, params: params)
  //    ).asBroadcastStream();
  /// 请求准备 转换 Method 为 字符串
  /// 该方法的Observable 返回的类型不对
//  Observable netRequest<T>(Method method, String url, {dynamic params}) {
//    return Observable.fromFuture(NetUtil.instance._netRequest<T>(
//            NetUtil.instance.getRequestMethod(method), url,
//            data: params,
//            queryParameters: null,
//            options: null,
//            cancelToken: null))
//        .asBroadcastStream();
//  }
  /// 请求准备 转换 Method 为 字符串
  Future<ResultI<T>> request<T>(Method method, String url, {dynamic params}) {
    return NetUtil.instance._netRequest<T>(
        NetUtil.instance.getRequestMethod(method), url,
        data: params, queryParameters: null, options: null, cancelToken: null);
  }

  /// 请求网络
  // ignore: missing_return
  Future<ResultI<T>> _netRequest<T>(String method, String url,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    try {
      /// 集成测试无法使用 isolate
      Map<String, dynamic> _map = Constant.isTest
          ? parseData(response.data.toString())
          : await compute(parseData, response.data.toString());
      if (_map.containsKey(Constant.data)) {
        if (_map[Constant.data] is List) {
          return ListResult<T>.fromJson(_map);
        } else {
          return Result<T>.fromJson(_map);
        }
      }
    } catch (e) {
      print("dio - error:" + e.toString());
      return Result(ExceptionHandle.parse_error, "数据解析错误", null);
    }
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {
      Log.i("取消请求接口： $url");
    }
  }

  _onError(int code, String msg, Function(int code, String mag) onError) {
    if (code == null) {
      code = ExceptionHandle.unknown_error;
      msg = "未知异常";
    }
    Log.e("接口请求异常： code: $code, mag: $msg");
    if (onError != null) {
      onError(code, msg);
    }
  }

  String getRequestMethod(Method method) {
    String m;
    switch (method) {
      case Method.get:
        m = "GET";
        break;
      case Method.post:
        m = "POST";
        break;
      case Method.put:
        m = "PUT";
        break;
      case Method.patch:
        m = "PATCH";
        break;
      case Method.delete:
        m = "DELETE";
        break;
      case Method.head:
        m = "HEAD";
        break;
    }
    return m;
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

enum Method { get, post, put, patch, delete, head }

/// Fiddler抓包代理配置 https://www.jianshu.com/p/d831b1f7c45b
//    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//        (HttpClient client) {
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return "PROXY 10.41.0.132:8888";
//      };
//      client.badCertificateCallback =
//          (X509Certificate cert, String host, int port) => true;
//    };
