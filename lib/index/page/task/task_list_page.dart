import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:task/index/index_router.dart';
import 'package:task/index/page/login/user.dart';
import 'package:task/index/page/task/task.dart';
import 'package:task/index/page/task/task_list_core.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';
import 'package:task/res/colors.dart';
import 'package:task/res/styles.dart';
import 'package:task/routers/fluro_navigator.dart';
import 'package:task/util/theme_utils.dart';
import 'package:task/widgets/Image/imageShadow.dart';
import 'package:task/widgets/lb/BottomDragWidget.dart';
import 'package:task/widgets/load_image.dart';
import 'package:task/widgets/my_card.dart';

class TaskListPage extends StatelessWidget with BaseView<TaskListVM> {
  const TaskListPage(
    this.rootRefresh, {
    Key key,
    this.configState = true,
    this.loadData = true,
  }) : super(key: key);

  /// 是否全局刷新
  final bool rootRefresh;
  final bool configState;
  final bool loadData;

  _refresh(TaskListVM vm) {
    vm.viewRefresh(rootRefresh: true);
  }

  void _into(TaskListVM vm) {}

  @override
  ViewConfig<TaskListVM> initConfig(BuildContext context) {
    var _empty = configState
        ? (vm) => Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("没有搜索到匹配的数据", style: TextStyles.textDarkGray14),
                Text("", style: TextStyles.textDarkGray14),
                InkWell(
                  onTap: () => _refresh(vm),
                  child: Text(
                    "刷新一下",
                    style: TextStyles.btnText,
                  ),
                ),
              ],
            ))
        : null;

    return rootRefresh
        ? ViewConfig<TaskListVM>(vm: TaskListVM(loadData), empty: _empty)
        : ViewConfig<TaskListVM>.noRoot(
            vm: TaskListVM(loadData), empty: _empty);
  }

  @override
  Widget vmBuild(
      BuildContext context, TaskListVM vm, Widget child, Widget state) {
    return Scaffold(
      backgroundColor: Color(0xffF2F5F9),
      appBar: getAppBar(context, vm),
      body: Stack(
        children: [
          BottomDragWidget(
              body: state ??
                  Padding(
                      padding: EdgeInsets.only(bottom: 61),
                      child: Stack(
                        children: [
//                        Divider(height: 1.0, color: Colors.black12,),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: Container(
                                child: EasyRefresh(
                                  controller: vm.refreshController,
                                  onLoad: vm.loadMore,
                                  onRefresh: vm.pullRefresh,
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(10),
                                    itemCount: vm.list.length,
                                    itemBuilder: (ctx, index) {
                                      return Selector<TaskListVM, Task>(
                                        selector: (_, aVM) => vm.list[index],
                                        shouldRebuild: (pre, next) =>
                                            pre == next,
                                        builder: (_, Task value, __) =>
                                            _item(vm, value),
                                      );
                                    },
                                  ),
                                ),
//                                decoration:
//                                    BoxDecoration(color: Colors.purpleAccent),
                              )),

                          /// 顶部 层级指示跳
                          Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10, left: 8),
                                child: Icon(
                                  Icons.reorder,
                                  size: 16,
                                  color: Colours.button_disabled,
                                ),
                              ),
                              Container(
                                width: 300,
                                height: 30,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: getTaskCatalog(),
                                ),
                              )
                            ]),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x80ccd7e9),
                                    offset: Offset(1.0, 2.0),
                                    blurRadius: 8.0,
                                    spreadRadius: .2),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0)),
                            ),
                          ),
                        ],
                      )),
              dragContainer: DragContainer(
                drawer: getListView(vm),
                defaultShowHeight: 60.0,
                height: 230.0,
              )),

          /// 页面全局右下角添加按钮
          Positioned(
              right: 0,
              bottom: 4,
              child: IconButton(
                  icon: Icon(Icons.arrow_forward, color: Colors.black38),
                  onPressed: vm.fastAddTask))
        ],
      ),
    );
  }

  /// 列表item
  Widget _item(TaskListVM vm, Task item) {
    var timeColor = Color(0xFFa8a8b3);
    if (item.endTime != null) {
      var cha = item.endTime - DateTime.now().millisecondsSinceEpoch;
      var re = cha ~/ (24 * 60 * 60 * 1000);
      if (re <= 0) {
        timeColor = Color(0xffff1b1b);
      } else if (re > 0) {
        timeColor = Color(0xff86A8E7);
      } else {
        timeColor = Color(0xFFa8a8b3);
      }
    }
    List<Widget> progress = [];
    if (item.progress == null) item.progress = 0;
    int count = (item.progress ~/ 20) - 1;
    for (int i = 0; i < 5; i++) {
      progress.add(Padding(
        padding: EdgeInsets.all(2),
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: count <= i ? Color(0xffDFE0E5) : Colours.task_pro6d,
                  offset: Offset(0.0, .5),
                  blurRadius: 2,
                  spreadRadius: .5),
            ],
            color: count <= i ? Color(0xffDFE0E5) : Colours.task_pro6,
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ));
    }
    String levelS = "";
    if (item.level == null) {
      item.level = 0;
    }
    for (int i = 0; i < item.level.toInt(); i++) levelS += "!";

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: MyCard(
        child: SizedBox.fromSize(
          size: Size(300, 120),
          child: Stack(
            children: [
              Positioned(
                top: 5.0,
                right: 10.0,
                child: Row(
                  children: progress,
                ),
              ),
              Positioned(
                  bottom: 5.0,
                  right: 10.0,
                  child: Row(children: [
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(
                              (item.endTime ?? 10000).toInt())
                          .toString()
                          .substring(
                              0,
                              DateTime.fromMillisecondsSinceEpoch(
                                          (item.endTime ?? 10000).toInt())
                                      .toString()
                                      .length -
                                  4),
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: timeColor,
                          fontSize: 12),
                    ),
                  ])),
              Positioned(
                top: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () => NavigatorUtils.push(
                            vm.context,
                            IndexRouter.infoPage +
                                "?number=" +
                                item.number.toString()),
                        child: Row(
                          children: [
                            Text(
                              levelS,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffff1b1b),
                                  fontSize: 18),
                            ),
                            Text(
                              item.title ?? "",
                              style: TextStyles.textDarkGray14,
                            ),
                          ],
                        )),
                    Text(
                      item.info ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Color(0xFF9b9aa7),
                          fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getListView(TaskListVM vm) {
    return Container(
      child: Column(
        children: <Widget>[
          getTouchBar(),
          Container(
            width: 360,
            height: 49,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 0),
                    child: TextField(
                      style: TextStyles.textBold18,
                      controller: vm.textEditingController,
                      decoration: InputDecoration.collapsed(
                          hintText: '输入任务标题  如：百词斩背单词...',
                          hintStyle: TextStyles.textDarkGray14),
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            height: 1.0,
            color: Colors.black12,
          ),
//          Expanded(child: newListView(),)
          Expanded(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: 10,
                ),
                child: TextField(
                  maxLength: 100,
                  //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
                  minLines: 3,
                  maxLines: 4,
                  style: TextStyles.textDarkGray14,
                  controller: vm.infoEditingController,
                  decoration: InputDecoration(
                      labelText: "任务描述",
                      contentPadding: EdgeInsets.all(15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: '输入任务描述   如：\n 查看股票走向...',
                      hintStyle: TextStyles.textDarkGray14),
                ),
              ),
            ],
          ))
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color(0x80ccd7e9),
              offset: Offset(1.0, 2.0),
              blurRadius: 8.0,
              spreadRadius: .2),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16.0), topLeft: Radius.circular(16.0)),
      ),
    );
  }

  Widget newListView() {
    return OverscrollNotificationWidget(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Text('data=$index');
        },
        itemCount: 100,

        ///这个属性是用来断定滚动的部件的物理特性，例如：
        ///scrollStart
        ///ScrollUpdate
        ///Overscroll
        ///ScrollEnd
        ///在Android和ios等平台，其默认值是不同的。我们可以在scroll_configuration.dart中看到如下配置
        ///下面代码是我在翻源码找到的解决方案
        /// The scroll physics to use for the platform given by [getPlatform].
        ///
        /// Defaults to [BouncingScrollPhysics] on iOS and [ClampingScrollPhysics] on
        /// Android.
//  ScrollPhysics getScrollPhysics(BuildContext context) {
//    switch (getPlatform(context)) {
//    case TargetPlatform.iOS:/*/
//         return const BouncingScrollPhysics();
//    case TargetPlatform.android:
//    case TargetPlatform.fuchsia:
//        return const ClampingScrollPhysics();
//    }
//    return null;
//  }
        ///在ios中，默认返回BouncingScrollPhysics，对于[BouncingScrollPhysics]而言，
        ///由于   double applyBoundaryConditions(ScrollMetrics position, double value) => 0.0;
        ///会导致：当listview的第一条目显示时，继续下拉时，不会调用上面提到的Overscroll监听。
        ///故这里，设定为[ClampingScrollPhysics]
        physics: const ClampingScrollPhysics(),
      ),
    );
  }

  Widget getTouchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 0),
      child: Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Color(0xff86A8E7),
                offset: Offset(0.0, 1.0),
                blurRadius: 2.0,
                spreadRadius: .2),
          ],
          color: Color(0xff86A8E7),
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }

  getCenterText(String s) {
    return Center(
      child: Text(
        s,
        textAlign: TextAlign.end,
        style: TextStyles.textDarkGray12,
      ),
    );
  }

  List<Widget> getTaskCatalog() {
    return [
      getCenterText("Task"),
      Icon(
        Icons.navigate_next,
        size: 10,
        color: Colours.dark_text,
      ),
      getCenterText("add")
    ];
  }

  getAppBar(BuildContext context, TaskListVM vm) {
    return AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                NavigatorUtils.push(context, IndexRouter.searchTaskPage);
              },
              tooltip: '搜索',
              icon: LoadAssetImage(
                "currency/search_ic",
                width: 26.0,
                height: 26.0,
                color: ThemeUtils.getIconColor(context),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: 16),
              child: ValueListenableBuilder(
                  valueListenable: vm.isDone,
                  builder: (_, v, __) {
                    return Switch(
                      value: v,
                      onChanged: (b) => vm.change(b),
                    );
                  }))
        ],
        iconTheme: IconThemeData(
          color: Color(0xff28323B), //修改颜色
        ),
        title: Row(
          children: [

            Padding(
              padding: EdgeInsets.only(right: 16),
//              child: ValueListenableBuilder<User>(
//                  valueListenable: vm.user,
//                  builder: (_, v, __) {
//                    return Image.network(
//                      v.avatar,
//                      width: 40,
//                      height: 40,
//                    );
//                  }),
              child: IconButton(
                iconSize: 48,
                onPressed: () {
                NavigatorUtils.push(context, IndexRouter.todoPage);
                },
                tooltip: '我的',
                icon: ValueListenableBuilder<User>(
                    valueListenable: vm.user,
                    builder: (_, v, __) {
//                      return ImageShadow(url: v.avatar);
                      return Image.network(
                        v.avatar,
                        width: 40,
                        height: 40,
                      );
                    }
              )),
            ),
//            LoadAssetImage(
//              "support/functions",
//              width: 26.0,
//              height: 26.0,
//              color: ThemeUtils.getIconColor(context),
//            ),
            Text("",
                style: TextStyle(
                    background: Paint()..color = Colors.white,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF5A76E5))),
            Text(
                DateTime.fromMillisecondsSinceEpoch(
                        DateTime.now().millisecondsSinceEpoch)
                    .toString()
                    .substring(0, 11),
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 14,
                    color: Color(0xFF333333)))
          ],
        ));
  }
}
