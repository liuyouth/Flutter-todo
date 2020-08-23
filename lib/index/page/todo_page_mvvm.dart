
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task/index/page/task/task_list_page.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';




class SelectVM extends BaseViewModel {
  ValueNotifier<bool> isLoadData = ValueNotifier(true);
  ValueNotifier<bool> isConfigState = ValueNotifier(false);
}

class SelectPage extends StatelessWidget with BaseView<SelectVM> {
  @override
  ViewConfig<SelectVM> initConfig(BuildContext context) =>
      ViewConfig(vm: SelectVM());

  @override
  Widget vmBuild(
      BuildContext context, SelectVM vm, Widget child, Widget state) {
    return Scaffold(
      appBar: AppBar(title: Text("选择")),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("是否加载数据,用来测试状态页和重新加载数据"),
            trailing: ValueListenableBuilder(
              valueListenable: vm.isLoadData,
              builder: (_, value, __) => Switch(
                value: value,
                onChanged: (value) => vm.isLoadData.value = value,
              ),
            ),
          ),
          ListTile(
            title: Text("是否单独配置状态页,用来测试状态页和重新加载数据"),
            trailing: ValueListenableBuilder(
              valueListenable: vm.isConfigState,
              builder: (_, value, __) => Switch(
                value: value,
                onChanged: (value) => vm.isConfigState.value = value,
              ),
            ),
          ),
          ListTile(
            title: Text("根布局刷新"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskListPage(
                    true,
                    configState: vm.isConfigState.value,
                    loadData: vm.isLoadData.value,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text("根布局不刷新"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskListPage(
                    false,
                    configState: vm.isConfigState.value,
                    loadData: vm.isLoadData.value,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
