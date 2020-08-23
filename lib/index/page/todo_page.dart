import 'dart:ui';

import 'package:flustars/flustars.dart' as FlutterStars;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:task/common/common.dart';
import 'package:task/res/resources.dart';
import 'package:task/routers/fluro_navigator.dart';

import 'package:task/util/ColorUtil.dart';
import 'package:task/util/theme_utils.dart';
import 'package:task/widgets/load_image.dart';
import 'package:task/widgets/my_card.dart';
import 'package:task/widgets/state_layout.dart';
import 'package:task/widgets/support/card.dart';
import 'package:task/widgets/support/test_select_entity.dart';
import 'package:task/widgets/support_index_top_bar.dart';
import 'package:provider/provider.dart';

import '../index_router.dart';
import 'index_page_provider.dart';

/// https://dribbble.com/shots/4496674-Daily-Ui-Challenge-041-Workout-Tracker/attachments/1019164
/// design/首页/index.html
class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage>
    with
        AutomaticKeepAliveClientMixin<TodoPage>,
        SingleTickerProviderStateMixin {
  //定义一个controller
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  IndexPageProvider provider = IndexPageProvider();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  bool _isClick = false;
  List<ItemClickOfNet> _list = [];
  num selectedPosition = 0;
  List<String> _guideList = [
    "https://images.unsplash.com/photo-1558980664-10e7170b5df9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2102&q=80",
    "https://ww1.sinaimg.cn/large/0065oQSqly1g2hekfwnd7j30sg0x4djy.jp",
    "https://ws1.sinaimg.cn/large/0065oQSqly1fymj13tnjmj30r60zf79k.jpg",
    "http://ww1.sinaimg.cn/large/0065oQSqly1g2pquqlp0nj30n00yiq8u.jpg"
  ];

  @override
  void initState() {
    super.initState();
    initData();
    _list.clear();
    _list.add(ItemClickOfNet.create("待办清单", "todo/todo_ic"));
    _list.add(
        ItemClickOfNet.create("Leaning English", "english/english_logo_ic"));
    _list.add(ItemClickOfNet.create("流水账", "english/bill_ic"));
    _list.add(ItemClickOfNet.create("全民运动", "support/support_ic"));

    //监听输入改变
    _nameController.addListener(_verify);
    _passwordController.addListener(_verify);
    _nameController.text = FlutterStars.SpUtil.getString(Constant.phone);
  }

  void _verify() {
    String name = _nameController.text;
    String password = _passwordController.text;
    bool isClick = true;
    if (name.isEmpty || name.length < 11) {
      isClick = false;
    }
    if (password.isEmpty || password.length < 6) {
      isClick = false;
    }

    /// 状态不一样在刷新，避免重复不必要的setState
    if (isClick != _isClick) {
      setState(() {
        _isClick = isClick;
      });
    }
  }

//  void _login() {
//    FlutterStars.SpUtil.putString(Constant.phone, _nameController.text);
//    NavigatorUtils.push(context, StoreRouter.auditPage);
//  }

  bool isDark = false;
  String groupValue;
  List<TestSelectEntity> selectList = new List();

  List<TestSelectEntity> allList = new List();

  List<TestSelectEntity> selectNormalList = new List();

  List<TestSelectEntity> allLNormaList = new List();

  void initData() {

  }

//  http://bizhi.bcoderss.com/wp-content/uploads/2019/09/d9a34d380cd79123ba7354cda3345982b3b7809f.jpg
  @override
  Widget build(BuildContext context) {
    super.build(context);
    isDark = ThemeUtils.isDark(context);
    //黑色
    // 定义当前页面 系统栏文字颜色
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarBrightness: Brightness.dark));
    return ChangeNotifierProvider<IndexPageProvider>(
        create: (_) => provider,
        child: Scaffold(
          body: Stack(children: <Widget>[
            /// 像素对齐问题的临时解决方法

            NestedScrollView(
              key: const Key('order_list'),
              physics: ClampingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return _sliverBuilder(context);
              },
              body: Text("sss"),
            ),
            Container(
                alignment: Alignment.bottomCenter,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0x80ccd7e9),
                          offset: Offset(0, 0.5),
                          blurRadius: 8.0,
                          spreadRadius: -.0),
                    ],
                    color: isDark ? Colours.dark_bg_color : Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Container(
                        width: double.infinity,
                        height: 50.0,
                        padding: const EdgeInsets.only(top: 0, left: 16),
                        child: Row(
                          children: <Widget>[
                        new ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                      child:
                            Image.network(
                              "https://pic3.zhimg.com/80/v2-af4b4789394e3bd774c5b8127b7901aa_1440w.jpg",
                              width: 40,
                              height: 40,
                            )),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "叫我靓仔啦~ ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Color(0xFF5A76E5),
                                    fontSize: Dimens.font_sp18),
                              ),
                            )
                          ],
                        )),
                  ),
                )),
          ]),
        ));

//    MultiSelectChip(
//      allLNormaList,
//      selectList: selectNormalList,
//      onSelectionChanged: (selectedList) {
//        selectedList.forEach((e) {
//          print((e as TestSelectEntity).title);
//        });
////                        allLNormaList = selectedList;
//      },
//    )
  }

  List<Widget> _sliverBuilder(BuildContext context) {
    return <Widget>[
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 16),
            child: IconButton(
              onPressed: () {
                NavigatorUtils.push(context, IndexRouter.englishPage);
              },
              tooltip: 'English',
              icon: LoadAssetImage(
                "support/statistics",
                width: 26.0,
                height: 26.0,
                color: ThemeUtils.getIconColor(context),
              ),
            ),
          ),
          brightness: Brightness.dark,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: IconButton(
                onPressed: () {
                  NavigatorUtils.push(context, IndexRouter.indexPage);
                },
                tooltip: '应用',
                icon: LoadAssetImage(
                  "support/functions",
                  width: 26.0,
                  height: 26.0,
                  color: ThemeUtils.getIconColor(context),
                ),
              ),
            )
          ],
          backgroundColor: isDark ? Colors.black38 : Colors.white,
          elevation: 0.0,
          centerTitle: true,
          expandedHeight: 60.0,
          floating: false,
          // 不随着滑动隐藏标题
          pinned: true,
          // 固定在顶部
          flexibleSpace: SupportIndexTopBar(
//            background: isDark ? Container(height: 113.0, color: Colours.dark_bg_color,) :
//            const LoadAssetImage("order/order_bg",
//              width: double.infinity,
//              height: 113.0,
//              fit: BoxFit.fill,
//            ),
            centerTitle: true,
            titlePadding: const EdgeInsetsDirectional.only(),
            collapseMode: CollapseMode.pin,
//            title: Swiper(
//              key: const Key('swiper'),
//              itemCount: _guideList.length,
//              loop: true,
//              itemBuilder: (_, index){
//                return CachedNetworkImage(
//                  fit: BoxFit.fill,
//                  imageUrl: "${_guideList[index]}",
//                  placeholder: (context, url) => Container(
//                    alignment: Alignment.center,
//                    child: new CircularProgressIndicator(),
//                  ),
//                  errorWidget: (context, url, error) => new Icon(Icons.error),
//                );
////                return LoadAssetImage(
////                  _guideList[index],
////                  key: Key(_guideList[index]),
////                  fit: BoxFit.cover,
////                  width: double.infinity,
////                  height: double.infinity,
////                );
//              },
//              onTap: (index){
////                if (index == _guideList.length - 1){
////                  _goLogin();
////                }
//              },
//            ),
          ),
        ),
      ),
    ];
  }

  getMoCard() {
    return _list.isEmpty
        ? const StateLayout(type: StateType.empty)
        : Container(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _list.length,
              itemBuilder: (_, index) {
                return Container(
                    width: 230,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: AccountCard(
                        type: _list[index].type,
                        child: InkWell(
                          //Toast.show("长按删除账号！");
                          onLongPress: () {
                            _showDeleteBottomSheet(index);
                          },
                          child: SizedBox(
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 25.0,
                                  left: 24.0,
                                  child: Container(
                                      height: 40.0,
                                      width: 40.0,
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: LoadAssetImage(
                                          _list[index].type == 1
                                              ? "account/wechat"
                                              : "account/yhk")),
                                ),
                                Positioned(
                                  top: 22.0,
                                  left: 72.0,
                                  child: Text(_list[index].title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.font_sp18)),
                                ),
                                Positioned(
                                  top: 48.0,
                                  left: 72.0,
                                  child: Text(_list[index].title,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0)),
                                ),
                                Positioned(
                                  bottom: 24.0,
                                  left: 72.0,
                                  child: Text(_list[index].title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.font_sp18,
                                          letterSpacing: 1.0)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            ));
  }

  getWeekList() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: 7,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (_, index) {
        return Container(
          height: 150,
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Card(
              color: ColorUtil.hexToColor("#47484B"),
              child: Padding(
                padding: EdgeInsets.all(3),
                child: Text(
                  "星期$index",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _showDeleteBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SafeArea(
            child: Container(
                height: 161.2,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 52.0,
                      child: const Center(
                        child: const Text(
                          "是否确认解绑，防止错误操作",
                          style: TextStyles.textSize16,
                        ),
                      ),
                    ),
                    Gaps.line,
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Theme.of(context).errorColor,
                        child: const Text("确认解绑",
                            style: TextStyle(fontSize: Dimens.font_sp18)),
                        onPressed: () {
                          setState(() {
                            _list.removeAt(index);
                          });
                          NavigatorUtils.goBack(context);
                        },
                      ),
                    ),
                    Gaps.line,
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Colours.text_gray,
                        child: const Text("取消",
                            style: TextStyle(fontSize: Dimens.font_sp18)),
                        onPressed: () {
                          NavigatorUtils.goBack(context);
                        },
                      ),
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }

  getCard(String s) {}

  @override
  bool get wantKeepAlive => true;

  Widget getItemContainer(int index) {
    switch (index) {
      case 0:
        return getToDoCard(index);
      case 1:
        return getEnglishCard(index);
      default:
        return MyCard(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 14, left: 14),
              child: Row(
                children: <Widget>[
                  LoadAssetImage(
                    _list[index].icon,
                    width: 40,
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      _list[index].title,
                      style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Color(0xFF807F8F),
                          fontSize: Dimens.font_sp18),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 100,
                        height: 90,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  height: 60.0,
                                  width: 60.0,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: LoadAssetImage("support/arms")),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(top: 68),
                                child: Text(
                                  _list[index].title,
                                  style: TextStyle(
                                      color: Color(0xff263248),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 100,
                        height: 90,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                  height: 60.0,
                                  width: 60.0,
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: LoadAssetImage("english/todo_ic")),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.only(top: 68),
                                child: Text(
                                  _list[index].title,
                                  style: TextStyle(
                                      color: Color(0xff263248),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
    }
  }

  Widget getToDoCard(index) {
    return MyCard(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 14, left: 14, bottom: 10),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  NavigatorUtils.push(context, IndexRouter.todoPage);
                },
                tooltip: "待办清单",
                icon: LoadAssetImage(
                  _list[index].icon,
                  width: 40,
                  height: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  _list[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF807F8F),
                      fontSize: Dimens.font_sp18),
                ),
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    left: 18, right: 8, top: 8, bottom: 8),
                child: LoadAssetImage(
                  "todo/level1",
                  width: 22,
                  height: 22,
                )),
            Text(
              "今日待办 （8）",
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Color(0xFF576787),
                  fontSize: Dimens.font_sp18),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                    left: 18, right: 8, top: 8, bottom: 8),
                child: LoadAssetImage(
                  "todo/level2",
                  width: 22,
                  height: 22,
                )),
            Text(
              "本周待办 （36）",
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Color(0xFF7487D0),
                  fontSize: Dimens.font_sp16),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, right: 8, top: 8, bottom: 8),
              child: LoadAssetImage(
                "todo/level3",
                width: 22,
                height: 22,
              ),
            ),
            Text(
              "逾期待办 （1）",
              style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: Color(0xFFFF6777),
                  fontSize: Dimens.font_sp14),
            )
          ],
        )
//            Padding(
//              padding: const EdgeInsets.only(top: 12),
//              child: Row(
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.all(15),
//                    child: Container(
//                      alignment: Alignment.center,
//                      child: SizedBox(
//                        width: 100,
//                        height: 90,
//                        child: Stack(
//                          children: <Widget>[
//                            Align(
//                              alignment: Alignment.center,
//                              child: Container(
//                                  height: 60.0,
//                                  width: 60.0,
//                                  padding: const EdgeInsets.all(8.0),
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(20.0),
//                                  ),
//                                  child: LoadAssetImage("support/arms")),
//                            ),
//                            Align(
//                              alignment: Alignment.center,
//                              child: Padding(
//                                padding: EdgeInsets.only(top: 68),
//                                child: Text(
//                                  _list[index].title,
//                                  style: TextStyle(
//                                      color: Color(0xff263248),
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 18),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(left: 15, right: 15),
//                    child: Container(
//                      alignment: Alignment.center,
//                      child: SizedBox(
//                        width: 100,
//                        height: 90,
//                        child: Stack(
//                          children: <Widget>[
//                            Align(
//                              alignment: Alignment.center,
//                              child: Container(
//                                  height: 60.0,
//                                  width: 60.0,
//                                  padding: const EdgeInsets.all(8.0),
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(20.0),
//                                  ),
//                                  child: LoadAssetImage("english/todo_ic")),
//                            ),
//                            Align(
//                              alignment: Alignment.center,
//                              child: Padding(
//                                padding: EdgeInsets.only(top: 68),
//                                child: Text(
//                                  _list[index].title,
//                                  style: TextStyle(
//                                      color: Color(0xff263248),
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 18),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  )
//                ],
//              ),
//            ),
      ],
    ));
  }

  Widget getEnglishCard(index) {
    return MyCard(
        child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 14, left: 14, bottom: 10),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  NavigatorUtils.push(context, IndexRouter.englishPage);
                },
                tooltip: "学习英语",
                icon: LoadAssetImage(
                  _list[index].icon,
                  width: 40,
                  height: 40,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  _list[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.w200,
                      color: Color(0xFF807F8F),
                      fontSize: Dimens.font_sp18),
                ),
              )
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Container(
                height: 100.0,
                width: 120.0,
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x805793FA),
                        offset: Offset(0.0, 2.0),
                        blurRadius: 6.0,
                        spreadRadius: 0.0),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          width: 96,
                          height: 66,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 35),
                                child: Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: Dimens.font_sp38,
                                      fontWeight: FontWeight.w200),
                                ),
                              ),
                              Text(
                                "今日已记录(个)",
                                style: TextStyle(color: Colors.black38),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            height: 24.0,
                            width: 24.0,
                            child: LoadAssetImage("english/book_ic")),
                      ),
                    ])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: Container(
                height: 100.0,
                width: 120.0,
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x805767FA),
                        offset: Offset(0.0, 2.0),
                        blurRadius: 6.0,
                        spreadRadius: 0.0),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                            width: 60,
                            height: 56,
                            child: Column(children: <Widget>[
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: Dimens.font_sp38,
                                    fontWeight: FontWeight.w200),
                              )
                            ])),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                            width: 60,
                            height: 56,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: Dimens.font_sp38,
                                      fontWeight: FontWeight.w200),
                                )
                              ],
                            )),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            height: 24.0,
                            width: 24.0,
                            child: LoadAssetImage("english/text_ic")),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              "今日测验统计",
                              style: TextStyle(color: Colors.black38),
                            )),
                      ),
                    ])),
              ),
            )
          ],
        ),

//            Padding(
//              padding: const EdgeInsets.only(top: 12),
//              child: Row(
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.all(15),
//                    child: Container(
//                      alignment: Alignment.center,
//                      child: SizedBox(
//                        width: 100,
//                        height: 90,
//                        child: Stack(
//                          children: <Widget>[
//                            Align(
//                              alignment: Alignment.center,
//                              child: Container(
//                                  height: 60.0,
//                                  width: 60.0,
//                                  padding: const EdgeInsets.all(8.0),
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(20.0),
//                                  ),
//                                  child: LoadAssetImage("support/arms")),
//                            ),
//                            Align(
//                              alignment: Alignment.center,
//                              child: Padding(
//                                padding: EdgeInsets.only(top: 68),
//                                child: Text(
//                                  _list[index].title,
//                                  style: TextStyle(
//                                      color: Color(0xff263248),
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 18),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.only(left: 15, right: 15),
//                    child: Container(
//                      alignment: Alignment.center,
//                      child: SizedBox(
//                        width: 100,
//                        height: 90,
//                        child: Stack(
//                          children: <Widget>[
//                            Align(
//                              alignment: Alignment.center,
//                              child: Container(
//                                  height: 60.0,
//                                  width: 60.0,
//                                  padding: const EdgeInsets.all(8.0),
//                                  decoration: BoxDecoration(
//                                    borderRadius: BorderRadius.circular(20.0),
//                                  ),
//                                  child: LoadAssetImage("english/todo_ic")),
//                            ),
//                            Align(
//                              alignment: Alignment.center,
//                              child: Padding(
//                                padding: EdgeInsets.only(top: 68),
//                                child: Text(
//                                  _list[index].title,
//                                  style: TextStyle(
//                                      color: Color(0xff263248),
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 18),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  )
//                ],
//              ),
//            ),
      ],
    ));
  }
}

// 定义当前页面 系统栏文字颜色
//SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
//    .copyWith(statusBarBrightness: Brightness.light));

class ItemClickOfNet {
  String title;
  String info;
  List<String> backGroundColors; // 背景颜色 多个采用渐变
  String backGroundUrl; // 背景图片
  String icon;
  String url; // 优先点击跳转web 如果有值
  String routerUrl; // 点击跳转
  String typeName; // 类型名称  首页模块列表  每日任务列表
  int type; // 类型id
  String code; // 预留
  ItemClickOfNet(
      this.title,
      this.info,
      this.url,
      this.routerUrl,
      this.backGroundUrl,
      this.icon,
      this.backGroundColors,
      this.typeName,
      this.type,
      this.code);

  ItemClickOfNet.create(title, icon) {
    this.title = title;
    this.icon = icon;
    this.type = 1;
  }

  ItemClickOfNet.fromJsonMap(Map<String, dynamic> map)
      : title = map["title"],
        info = map["info"],
        typeName = map["typeName"],
        type = map["type"],
        code = map["code"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = title;
    data['typeName'] = typeName;
    data['type'] = type;
    data['code'] = code;
    return data;
  }
}
