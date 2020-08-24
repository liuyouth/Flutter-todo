import 'dart:convert';

import 'package:task/index/NetManager/ListParams.dart';
import 'package:task/index/NetManager/NetUtil.dart';
import 'package:task/index/NetManager/Result.dart';
import 'package:task/index/page/login/user.dart';
import 'package:task/index/page/task/task.dart';
import 'package:rxdart/rxdart.dart';

/// 所有网络请求都通过 NetManager 发起请求
class NetManager {

    static const String HOST = "http://api.todo.moi.pub/";
//  static const String HOST = "http://192.168.5.14:2001/";
//  static const String HOST = "http://172.20.10.3:2001/";
//  static const String HOST = "http://192.168.101.6:2001/";
  static NetManager get instance => NetManager();

  Future<ResultI<User>> login(String acc, String pwd) {
    return NetUtil.instance.request<User>(Method.post, "user/login",
        params: {"userName": acc, "passWord": pwd});
  }

  /// 获取Task 列表
  /// ResultI<Task>   其中 Task 和 requestNetwork 中的Task 类型 一致
  Future<ResultI<Task>> getTaskList(
      {num page=1,String searchStr="", bool isComplete , bool isSearch}) {
    print('ddd '+isSearch.toString());
    return NetUtil.instance.request<Task>(Method.post, "task/list", params:
//    jsonEncode({
//      "isComplete": isComplete,
//      "searchStr": "true",
//      "isS":true,
//      "T":true,
//      "title": searchStr??""
//    })

    jsonEncode(ListParams(page:page,  title: searchStr,complete: isComplete,search: isSearch).toJson())
    );
  }

  Future<ResultI<Task>> addTask(Task task) {
    return NetUtil.instance
        .request<Task>(Method.post, "task/", params: task.getJson());
  }

  Future<ResultI<Task>> getTask(num num) {
    return NetUtil.instance
        .request<Task>(Method.get, "task/" + num.toString(), params: []);
  }

  Future<ResultI<Task>> saveTask(Task task) {
    return NetUtil.instance
        .request<Task>(Method.put, "task/", params: task.getJson());
  }
}

/// 用不到 Observable !!! 不然就是回调了 直接用Futura
//  Observable<ResultI<Task>> getTaskList() {
////    return NetUtil.instance.netRequest<Task>(Method.get,"task/");
////    print(NetUtil.instance.request<Task>(Method.get,"task/", params: []).toString());
//    return Observable.fromFuture(
//        NetUtil.instance.request<Task>(Method.get,"task/", params: [])
//            ).asBroadcastStream();
//  }
/// VM 调用代码 Observable 的
//     NetManager.instance.getTaskList()
//          .listen((result) {
//        DataResponse<TaskListEntity> dataResponse;
//        print('result');
//        print(result.getData());
//        if (result is ListResult<Task>) {
//          ListResult<Task> data = result;
//          print(data.toString());
//          dataResponse = DataResponse(entity: TaskListEntity(data.getData()));
//        }
//        return dataResponse;
//      });
