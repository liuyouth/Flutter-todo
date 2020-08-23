import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:task/common/common.dart';
import 'package:task/index/NetManager/NetManager.dart';
import 'package:task/index/NetManager/Result.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';

import 'user.dart';

/**
 * ToDoVM
 */
class LoginVM extends BaseViewModel<LoginModel, LoginEntity> {
  LoginVM();

  ValueNotifier<bool> remember = ValueNotifier(false);

  User task = User.empty();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController infoEditingController = TextEditingController();

  @override
  void initResultData() {

    infoEditingController.addListener(() {
      print('info ' + infoEditingController.text);
    });
    textEditingController.addListener(() {
      print('eeeee ' + textEditingController.text);
      if (textEditingController.text.isEmpty) {}
    });
  }

  Future<bool> login() async {
    var d = await model.login(
        textEditingController.text, infoEditingController.text);

    if (d != null) {
      if (remember.value) {
        SpUtil.putString(Constant.acc, textEditingController.text);
        SpUtil.putString(Constant.pwd, infoEditingController.text);
      } else {
        SpUtil.putString(Constant.acc, "");
        SpUtil.putString(Constant.pwd, "");
      }
      SpUtil.putObject("user", d);
      SpUtil.putBool(Constant.remember, remember.value);
      SpUtil.putString(Constant.accessToken, d.token);
    }
    return d != null;
  }

  void fastAddTask({String text}) async {
    print('fastAddTask ');
    print('fastAddTask e  ' +
        textEditingController.text +
        textEditingController.text.isNotEmpty.toString());
    if (textEditingController.text.isNotEmpty &&
        textEditingController.text.replaceAll(" ", "").isNotEmpty) {
      print('fastAddTask dddddd');
//       await model.getArticleList();
    }
  }

  /// 修改第一个数据的时间
  void modifyFistTime() {
//    list[0].time = DateTime.now().toString();
//    vnTime.value = list[0].time;
    notifyListeners();
  }

  void build() {
    var b = SpUtil.getBool(Constant.remember);
    print('b'+SpUtil.getString(Constant.acc));
    if (b) {
      remember.value = b;
      textEditingController.value =
          TextEditingValue(text: SpUtil.getString(Constant.acc));
      infoEditingController.value =
          TextEditingValue(text: SpUtil.getString(Constant.pwd));
    }
  }
}

/// Todo模块的数据model
class LoginModel extends BaseModel {
  /// 登录
  Future<User> login(String account, String pwd) async {
    ResultI<User> data = await NetManager.instance.login(account, pwd);
    print('ddd' + data.toString());
    return data.data;
//    if(data.code == 200){
//      return true;
//    }else {
//      return false;
//    }
  }

  /// 添加待办
//  Future<DataResponse<TaskListEntity>> addTask(Task task) async {
//    DataResponse<TaskListEntity> dataResponse;
//    ResultI<Task> data = await  NetManager.instance.addTask(task);
//    dataResponse = DataResponse(entity: TaskListEntity(data.getData()));
//    Log.d(" data "+dataResponse.toString());
//    return  dataResponse;
//  }
}

class LoginEntity extends BaseEntity {
  User user;

  @override
  String toString() {
    return 'TaskListEntity{list: $user}';
  }

  LoginEntity(this.user);
}
