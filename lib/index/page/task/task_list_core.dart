import 'package:task/index/NetManager/NetManager.dart';
import 'package:task/index/NetManager/Result.dart';
import 'package:task/index/page/login/user.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';
import 'package:flutter/cupertino.dart';
import 'package:task/util/log_utils.dart';
import 'package:task/widgets/support/test_select_entity.dart';

import 'task.dart';

/**
 * ToDoVM
 */
class TaskListVM
    extends BaseListViewModel<TaskListModel, TaskListEntity, Task> {
  TaskListVM(this.isLoadData);
  List<TestSelectEntity> selectNormalList = new List();

  List<TestSelectEntity> allLNormaList = new List();
  bool isLoadData = true;
  Task task = Task.empty();
  ValueNotifier<User> user = ValueNotifier(User.empty());

  /// 首次加载
  bool firstLoad = true;
  ValueNotifier<bool> isDone = ValueNotifier(false);
  ValueNotifier<String> vnTime = ValueNotifier("暂无");
  TextEditingController textEditingController = TextEditingController();
  TextEditingController infoEditingController = TextEditingController();
  @override
  void jointList(TaskListEntity newEntity) =>
      entity.list.addAll(newEntity.list);

  @override
  List<Task> get list => entity.list;

  @override
  Future<DataResponse<TaskListEntity>> requestHttp(
      {bool isLoad, int page, params}) async {
    /// 判断是否加载数据， 测试状态页用
    if (!isLoadData && firstLoad) {
      firstLoad = false;
      return null;
    }
//    var d = await model.getArticleList();
    return await model.getArticleList(isComplete: isDone.value,page:page);
  }

  @override
  void initResultData() {

    infoEditingController.addListener(() {});
    textEditingController.addListener(() {
      if (textEditingController.text.isEmpty) {}
    });
  }

  void fastAddTask() async {
    if (textEditingController.text.isNotEmpty &&
        textEditingController.text.replaceAll(" ", "").isNotEmpty) {
      var task = Task.empty();
      task.title = textEditingController.text;
      task.info = infoEditingController.text;
      var result = await model.addTask(task);
      if (result) {
        textEditingController.value = TextEditingValue();
        infoEditingController.value = TextEditingValue();
        pageRefresh(busy: true);
      }
//      print(result.toString());
    } else {}
  }

  /// 修改第一个数据的时间
  void modifyFistTime() {
//    list[0].time = DateTime.now().toString();
//    vnTime.value = list[0].time;

//    notifyListeners();
  }

  change(bool b) {
    isDone.value = !isDone.value;
    pageRefresh(busy: true);
  }
}

/// Todo模块的数据model
class TaskListModel extends BaseModel {
  /// todo列表
  Future<DataResponse<TaskListEntity>> getArticleList(
      {bool isComplete, bool isSearch,num page}) async {
    print('iscom'+isComplete.toString());
    DataResponse<TaskListEntity> dataResponse;
    ResultI<Task> data =
        await NetManager.instance.getTaskList(isComplete: isComplete,page:page);
    dataResponse = DataResponse(entity: TaskListEntity(data.getData()));
    return dataResponse;
  }

  /// 添加待办
  Future<bool> addTask(Task task) async {
    DataResponse<TaskListEntity> dataResponse;
    ResultI<Task> data = await NetManager.instance.addTask(task);
    print('eee' + data.code.toString());
    return data.code == 200;
//    dataResponse = DataResponse(entity: TaskListEntity(data.getData()));
//    return  dataResponse;
  }
}

class TaskListEntity extends BaseEntity {
  List<Task> list;

  @override
  String toString() {
    return 'TaskListEntity{list: $list}';
  }

  TaskListEntity(this.list);
}
