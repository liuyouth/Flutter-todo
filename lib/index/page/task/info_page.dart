import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seekbar/seekbar/seekbar.dart';
import 'package:task/index/page/task/task.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';
import 'package:task/res/colors.dart';
import 'package:task/res/styles.dart';
import 'package:task/widgets/lb/BottomDragWidget.dart';

import 'info_core.dart';

class InfoPage extends StatelessWidget with BaseView<InfoVM> {
  const InfoPage({
    Key key,
    this.configState = true,
    this.number = 0,
  }) : super(key: key);

  /// 是否全局刷新
  final num number;

//  final bool rootRefresh;
  final bool configState;

  _refresh(InfoVM vm) {
    vm.viewRefresh(rootRefresh: true);
  }

  _save(InfoVM vm) {
    vm.save();
  }



  _select(InfoVM vm, value) {
    vm.task.value.level = value;
//    vm.notifyListeners();
    vm.task.value = vm.task.value;
    print('"eeeee' + value.toString() + "ee" + vm.task.value.level.toString());
  }

  @override
  ViewConfig<InfoVM> initConfig(BuildContext context) {
    print("  ViewConfig<InfoVM> initConfig(BuildContext context) {");
    return false
        ? ViewConfig<InfoVM>(vm: InfoVM(), empty: null)
        : ViewConfig<InfoVM>.noRoot(vm: InfoVM(), empty: null);
  }

  @override
  Widget vmBuild(BuildContext context, InfoVM vm, Widget child, Widget state) {
    print('"vmBuild');
    vm.build(number);
    return Scaffold(
        backgroundColor: Color(0xffF2F5F9),
        appBar: AppBar(
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: IconButton(
                  onPressed: () => _save(vm),
                  tooltip: '保存',
                  icon: Icon(
                    Icons.save,
                    size: 26,
                    color: Colours.button_disabled,
                  ),
                ),
              ),
//              Padding(
//                padding: EdgeInsets.only(right: 16),
//                child: IconButton(
//                  onPressed: () {
////                NavigatorUtils.push(context, LoginRouter.loginPage);
//                  },
//                  tooltip: '应用',
//                  icon: LoadAssetImage(
//                    "support/functions",
//                    width: 26.0,
//                    height: 26.0,
//                    color: ThemeUtils.getIconColor(context),
//                  ),
//                ),
//              )
            ],
            iconTheme: IconThemeData(
              color: Color(0xff28323B), //修改颜色
            ),
            title: ValueListenableBuilder<Task>(
              valueListenable: vm.task,
              builder: (_, value, __) {
                return Row(
                  children: [
                    Text(value.title ?? "",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            color: Color(0xFF333333))),
                    Text((vm.task.value.number ?? 0).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Color(0xFF5A76E5))),
                  ],
                );
              },
            )),
        body: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            new SliverList(
                delegate: new SliverChildListDelegate([
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  ValueListenableBuilder<Task>(
                      valueListenable: vm.task,
                      builder: (_, value, __) {
                        String levelS = "";
                        if (value.level == null) {
                          value.level = 0;
                        }
                        for (int i = 0; i < value.level.toInt(); i++)
                          levelS += "!";
                        return Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: TextField(
                                    style: TextStyles.textBold18,
                                    controller: vm.textEditingController,
                                    decoration: InputDecoration(
                                      labelText: '任务标题',
                                      hintText: '请输入任务标题',
                                      hintStyle: TextStyles.textDarkGray14,
                                    ),
                                  ),
                                ),
                                TextField(
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
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      hintText: '输入任务描述   如：\n查看股票走向...',
                                      hintStyle: TextStyles.textDarkGray14),
                                ),
                                Row(children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 40, left: 8, top: 6, bottom: 10),
                                    child: Icon(
                                      Icons.straighten,
                                      size: 16,
                                      color: Colours.button_disabled,
                                    ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                                      width: 200,
                                      child: SeekBar(
                                        progresseight: 5,
                                        value: double.parse(
                                            (value.progress ?? 0).toString()),
                                        sectionCount: 4,
                                        sectionRadius: 4,
                                        progressColor: Color(0xFF5A76E5),
                                        backgroundColor: Color(0xFFCECECE),
                                        sectionColor: Color(0xFF5A76E5),
                                      )),
                                ]),
                                Row(children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 20,
                                        left: 8,
                                        top: 10,
                                        bottom: 10),
                                    child: Icon(
                                      Icons.assistant_photo,
                                      size: 16,
                                      color: Colours.button_disabled,
                                    ),
                                  ),
                                  Radio(
                                    value: 1,
                                    groupValue: value.level,
                                    onChanged: (v) => _select(vm, v),
                                  ),
                                  Text(
                                    "!",
                                    style: TextStyle(color: Color(0xffff1b1b)),
                                  ),
                                  Radio(
                                    value: 2,
                                    groupValue: value.level,
                                    onChanged: (v) => _select(vm, v),
                                  ),
                                  Text(
                                    "!!",
                                    style: TextStyle(color: Color(0xffff1b1b)),
                                  ),
                                  Radio(
                                    value: 3,
                                    groupValue: value.level,
                                    onChanged: (v) => _select(vm, v),
                                  ),
                                  Text(
                                    "!!!",
                                    style: TextStyle(color: Color(0xffff1b1b)),
                                  )
                                ]),
                                Row(children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 25, left: 8, top: 6, bottom: 10),
                                    child: Icon(
                                      Icons.done,
                                      size: 16,
                                      color: Colours.button_disabled,
                                    ),
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: vm.complete,
                                      builder: (_, v, __) {
                                        return Switch(
                                          value: v,
                                          onChanged: (b) => vm.change(b),
                                        );
                                      })
//                          Container(
//                            width: 300,
//                            height: 60,
//                            child: ListView(
//                              scrollDirection: Axis.horizontal,
//                              children: getTaskCatalog(),
//                            ),
//                          )
                                ]),
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
                                  topRight: Radius.circular(16.0),
                                  topLeft: Radius.circular(16.0),
                                  bottomRight: Radius.circular(16.0),
                                  bottomLeft: Radius.circular(16.0)),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ]))
          ],
        ));
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
}
