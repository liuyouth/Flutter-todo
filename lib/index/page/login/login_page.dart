import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task/index/page/task/task.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';
import 'package:task/res/colors.dart';
import 'package:task/res/dimens.dart';
import 'package:task/res/styles.dart';
import 'package:task/routers/fluro_navigator.dart';
import 'package:task/widgets/lb/BottomDragWidget.dart';
import 'package:task/widgets/my_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../index_router.dart';
import 'login_core.dart';

class LoginPage extends StatelessWidget with BaseView<LoginVM> {
  const LoginPage({
    Key key,
    this.configState = true,
  }) : super(key: key);

  /// 是否全局刷新
//  final bool rootRefresh;
  final bool configState;

  _refresh(LoginVM vm) {
    vm.viewRefresh(rootRefresh: true);
  }
  void _check(LoginVM vm ) {
      vm.remember.value = !vm.remember.value;
      vm.notifyListeners();
  }
  _rigister() async {
    const url = 'http://acc.moi.pub/#/register';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _login(LoginVM vm) async{
    var d = await vm.login();
    if(d){
      NavigatorUtils.push(vm.context, IndexRouter.taskPage,replace: true);
    }
  }

  @override
  ViewConfig<LoginVM> initConfig(BuildContext context) {
    return false
        ? ViewConfig<LoginVM>(vm: LoginVM(), empty: null)
        : ViewConfig<LoginVM>.noRoot(vm: LoginVM(), empty: null);
  }

  @override
  Widget vmBuild(BuildContext context, LoginVM vm, Widget child, Widget state) {
    vm.build();
    return Scaffold(
        backgroundColor: Color(0xffF2F5F9),
        body: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            new SliverList(
                delegate: new SliverChildListDelegate([
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 300, left: 10, right: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: TextField(
                            onSubmitted: (s) => vm.fastAddTask(text: s),
                            style: TextStyles.textBold18,
                            controller: vm.textEditingController,
                            decoration: InputDecoration(
                              labelText: '账号',
                              labelStyle: TextStyle(
                                color: Colors.pink,
                                fontSize: 12,
                              ),
                              hintText: '请输入账号',
                              hintStyle: TextStyles.textDarkGray14,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pink,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          onSubmitted: (s) => vm.fastAddTask(text: s),
                          style: TextStyles.textBold18,
                          controller: vm.infoEditingController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: '密码',
                            labelStyle: TextStyle(
                              color: Colors.pink,
                              fontSize: 12,
                            ),
                            hintText: '请输入密码',
                            hintStyle: TextStyles.textDarkGray14,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ),
                        Row(children: [
                          ValueListenableBuilder<bool>(
                            valueListenable: vm.remember,
                            builder: (_, value, __) {
                              return  Checkbox(value:value, onChanged: (b)=> _check(vm));
                            },
                          )
                         ,
                          GestureDetector(
                            onTap: ()=>_check(vm), //写入方法名称就可以了，但是是无参的
                            child: getCenterText("记住密码")
                          ),
                        ],),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, left: 20, right: 20),
                          height: 54.0,
                          width: double.infinity,
                          child: FlatButton(
                            textColor: Colours.text_gray,
                            child: const Text("登陆",
                                style: TextStyle(fontSize: Dimens.font_sp18)),
                            onPressed: () => _login(vm),
                          ),
                        ),
                        Row(children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10, left: 8),
                            child: Icon(
                              Icons.person_outline,
                              size: 16,
                              color: Colours.button_disabled,
                            ),
                          ),
                          Container(
                            width: 300,
                            height: 60,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: getTaskCatalog(),
                            ),
                          )
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
                          bottomRight: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0)),
                    ),
                  ),
//            Padding(
//              padding: EdgeInsets.only(bottom: 20),
//            ),
                  getCenterText("Copyright © 2020 知识宝库"),
                  getCenterText("Powered by Flutter")
                ],
              ),
            ]))
          ],
        ));
  }

  Widget _item(Task item) {
    var timeColor;
    var cha = item.endTime - DateTime.now().millisecondsSinceEpoch;
    var re = cha ~/ (24 * 60 * 60 * 1000);
    if (re <= 0) {
      timeColor = Color(0xffff1b1b);
    } else if (re > 0) {
      timeColor = Color(0xff86A8E7);
    } else {
      timeColor = Color(0xFFa8a8b3);
    }
    List<Widget> progress = [];
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
    for (int i = 0; i < item.level.toInt(); i++) levelS += "!";
    return MyCard(
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
                    DateTime.fromMillisecondsSinceEpoch(item.endTime.toInt())
                        .toString()
                        .substring(
                            0,
                            DateTime.fromMillisecondsSinceEpoch(
                                        item.endTime.toInt())
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
                children: [
                  Row(
                    children: [
                      Text(
                        levelS,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xffff1b1b),
                            fontSize: 18),
                      ),
                      Text(
                        item.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Color(0xFF807F8F),
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Text(
                    item.info,
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
    );
  }

  getListView(LoginVM vm) {
    return Container(
      child: Column(
        children: <Widget>[
          getTouchBar(),
          Container(
            width: 300,
            height: 49,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: TextField(
                      onSubmitted: (s) => vm.fastAddTask(text: s),
                      style: TextStyles.textBold18,
                      controller: vm.textEditingController,
                      decoration: InputDecoration.collapsed(
                          hintText: '输入任务标题  如：查看股票走向...',
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
                  onSubmitted: (s) => vm.fastAddTask(text: s),
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
      GestureDetector(
        onTap: _rigister, //写入方法名称就可以了，但是是无参的
        child: getCenterText("账号系统来自  【acc.moi.pub】点击注册 ️"),
      ),

//      Icon(
//        Icons.navigate_next,
//        size: 10,
//        color: Colours.dark_text,
//      ),
//      getCenterText("add")
    ];
  }


}
