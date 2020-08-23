import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:task/common/common.dart';
import 'package:task/index/NetManager/NetManager.dart';
import 'package:task/index/NetManager/Result.dart';
import 'package:task/index/page/task/task.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';



/**
 * ToDoVM
 */
class InfoVM extends BaseViewModel<InfoModel, InfoEntity> {
  InfoVM();

  ValueNotifier<bool> complete = ValueNotifier(false);
  ValueNotifier<Task> task = ValueNotifier(Task.empty());
  num number;

  TextEditingController textEditingController = TextEditingController();
  TextEditingController infoEditingController = TextEditingController();
  void build(num number) async {
    textEditingController.addListener(() {
      print('"eeeee'+textEditingController.text);
      task.value.title =textEditingController.text;
    });
    infoEditingController.addListener(() {
      task.value.info =infoEditingController.text;
    });
    this.number = number;
    print('num'+number.toString());
    if(number==0){

    }else {
      var  detail =  await model.getDetail(number);
      task.value = detail;
      complete.value = task.value.complete;
      textEditingController.value = TextEditingValue(text:task.value.title.toString());
      infoEditingController.value = TextEditingValue(text:task.value.info.toString());
      print('task'+task.value.number.toString());
    }

  }
  @override
  void initResultData() {

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

  void save() async{
    model.saveTask(task.value);
  }

  change(bool b) {
    complete.value = !complete.value;
    task.value.complete = !task.value.complete;
  }


}

/// Todo模块的数据model
class InfoModel extends BaseModel {
  Future<Task> getDetail(num num) async{
    ResultI<Task> data = await  NetManager.instance.getTask(num);
    if(data.code==200) {
      return data.getData();
    }else{
      return Task.empty();
    }
  }

  Future<Task> saveTask(Task value) async{
    ResultI<Task> resultI =  await NetManager.instance.saveTask(value);
    if(resultI.code==200) {
      return resultI.getData();
    }else{
      return Task.empty();
    }
  }
}

class InfoEntity extends BaseEntity {
  Task task;

  @override
  String toString() {
    return 'TaskListEntity{list: $task}';
  }

  InfoEntity(this.task);
}
