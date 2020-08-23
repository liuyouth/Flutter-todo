import 'package:flutter/cupertino.dart';
import 'package:task/index/NetManager/NetManager.dart';
import 'package:task/index/NetManager/Result.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';
import 'package:task/util/log_utils.dart';

import 'task.dart';

/**
 * ToDoVM
 */
class SearchTaskListVM
    extends BaseListViewModel<SearchTaskListModel, TaskListEntity, Task> {
  SearchTaskListVM(this.isLoadData);

  bool isLoadData = true;
  Task task = Task.empty();

  /// 首次加载
  bool firstLoad = true;
  ValueNotifier<String> vnTime = ValueNotifier("暂无");
  TextEditingController textEditingController = TextEditingController();

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
    return await model.searchArticleList(textEditingController.text);
  }

  @override
  void initResultData() {
    textEditingController.addListener(() {
      print('input ${textEditingController.text}');
//      notifyListeners();
    });
  }

  /// 修改第一个数据的时间
  void modifyFistTime() {
    notifyListeners();
  }
}

/// Todo模块的数据model
class SearchTaskListModel extends BaseModel {
  /// 资讯列表
  Future<DataResponse<TaskListEntity>> searchArticleList(
      String searchStr) async {
    DataResponse<TaskListEntity> dataResponse;
    if (searchStr.isNotEmpty) {
      ResultI<Task> data = await NetManager.instance
          .getTaskList(searchStr: searchStr, isSearch: true);
      dataResponse = DataResponse(entity: TaskListEntity(data.getData()));
    }
    Log.d(
        "[SearchTaskListModel] : searchArticleList " + dataResponse.toString());
    return dataResponse;
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
