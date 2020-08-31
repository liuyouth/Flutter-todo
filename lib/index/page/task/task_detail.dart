
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';

class TaskDetailVM extends BaseViewModel {
  ValueNotifier<bool> isLoadData = ValueNotifier(true);
  ValueNotifier<bool> isConfigState = ValueNotifier(false);
}

class TaskDetailPage extends StatelessWidget with BaseView<TaskDetailVM> {
  @override
  ViewConfig<TaskDetailVM> initConfig(BuildContext context) =>
      ViewConfig(vm: TaskDetailVM());

  @override
  Widget vmBuild(BuildContext context, TaskDetailVM vm, Widget child,
      Widget state) {
    return Scaffold(
      appBar: AppBar(title: Text("选择")),
      body: Text("嘟嘟嘟嘟"),
    );
  }
}
