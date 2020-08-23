/// token 刷新拦截器
/// 添加token 拦截器
/// 日志打印 拦截器
import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:task/common/common.dart';
import 'package:task/index/NetManager/NetUtil.dart';
import 'package:task/index/index_router.dart';
import 'package:task/routers/fluro_navigator.dart';
import 'package:task/util/log_utils.dart';


import 'ExceptionHandle.dart';


class AuthInterceptor extends Interceptor{
  @override
  onRequest(RequestOptions options) {
    String accessToken = SpUtil.getString(Constant.accessToken);
    if (accessToken.isNotEmpty){
      options.headers["authorization"] = "$accessToken";
    }

    return super.onRequest(options);
  }
}

class TokenInterceptor extends Interceptor{

  Future<String> getToken() async {
    String refreshToken = "user/login";
    Map<String, String> params = Map();
    params["userName"] = SpUtil.getString(Constant.acc);
    params["passWord"] = SpUtil.getString(Constant.pwd);
    try{
      _tokenDio.options = NetUtil.instance.getDio().options;
      var response = await _tokenDio.post(refreshToken, data: params);
      if (response.statusCode == ExceptionHandle.success){
        return json.decode(response.data.toString())["token"];
      }else {
        // 有登陆权限才进入 主页面
      }
    }catch(e){

      Log.e("刷新Token失败！");
    }
    return null;
  }

  Dio _tokenDio = Dio();

  @override
  onResponse(Response response) async{
    //401代表token过期
    if (response != null && response.statusCode == ExceptionHandle.unauthorized) {
      Log.d("-----------自动刷新Token------------");
      Dio dio = NetUtil.instance.getDio();
      dio.interceptors.requestLock.lock();
      String accessToken = await getToken(); // 获取新的accessToken
      Log.e("-----------NewToken: $accessToken ------------");
      SpUtil.putString(Constant.accessToken, accessToken);
      dio.interceptors.requestLock.unlock();

      if (accessToken != null){{
        // 重新请求失败接口
        var request = response.request;
        request.headers["Authorization"] = "Bearer $accessToken";
        try {
          Log.e("----------- 重新请求接口 ------------");
          /// 避免重复执行拦截器，使用tokenDio
          var response = await _tokenDio.request(request.path,
              data: request.data,
              queryParameters: request.queryParameters,
              cancelToken: request.cancelToken,
              options: request,
              onReceiveProgress: request.onReceiveProgress);
          return response;
        } on DioError catch (e) {
          return e;
        }
      }}
    }
    return super.onResponse(response);
  }
}

class LoggingInterceptor extends Interceptor{

  DateTime startTime;
  DateTime endTime;

  @override
  onRequest(RequestOptions options) {
    startTime = DateTime.now();
    Log.d("----------Start----------");
    if (options.queryParameters.isEmpty){
      Log.i("RequestUrl: " + options.baseUrl + options.path);
    }else{
      Log.i("RequestUrl: " + options.baseUrl + options.path + "?" + Transformer.urlEncodeMap(options.queryParameters));
    }
    Log.d("RequestMethod: " + options.method);
    Log.d("RequestHeaders:" + options.headers.toString());
    Log.d("RequestContentType: ${options.contentType}");
    Log.d("RequestData: ${options.data.toString()}");
    return super.onRequest(options);
  }

  @override
  onResponse(Response response) {
    endTime = DateTime.now();
    int duration = endTime.difference(startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success){
      Log.d("ResponseCode: ${response.statusCode}");
    }else {
      Log.e("ResponseCode: ${response.statusCode}");
    }
    // 输出结果
    Log.json(response.data.toString());
    Log.d("----------End: $duration 毫秒----------");
    return super.onResponse(response);
  }

  @override
  onError(DioError err) {
    Log.d("----------Error-----------");
    return super.onError(err);
  }
}


