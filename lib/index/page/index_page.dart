import 'package:flustars/flustars.dart' as FlutterStars;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:task/account/page/withdrawal_account_page.dart';
import 'package:task/common/common.dart';
//import 'package:task/order/page/order_page.dart';
import 'package:task/res/resources.dart';
import 'package:task/routers/fluro_navigator.dart';
//import 'package:task/store/store_router.dart';
import 'package:task/util/ColorUtil.dart';
import 'package:task/util/theme_utils.dart';
import 'package:task/widgets/SliverAppBarDelegate.dart';
import 'package:task/widgets/load_image.dart';
import 'package:task/widgets/my_card.dart';
import 'package:task/widgets/state_layout.dart';
import 'package:task/widgets/support/card.dart';
import 'package:task/widgets/support/muliti_select_choice.dart';
import 'package:task/widgets/support/test_select_entity.dart';
import 'package:task/widgets/support_index_top_bar.dart';
import 'package:provider/provider.dart';

import '../index_router.dart';
import 'index_page_provider.dart';
/// https://dribbble.com/shots/4496674-Daily-Ui-Challenge-041-Workout-Tracker/attachments/1019164
/// design/首页/index.html
class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>
    with
        AutomaticKeepAliveClientMixin<IndexPage>,
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
  @override
  void initState() {
    super.initState();
    initData();
    _list.clear();
    _list.add(ItemClickOfNet.create("Arms"));
    _list.add(ItemClickOfNet.create("Abs"));
    _list.add(ItemClickOfNet.create("Rear"));
    _list.add(ItemClickOfNet.create("Legs"));
    _list.add(ItemClickOfNet.create("Back"));
    _list.add(ItemClickOfNet.create("Chest"));
    _list.add(ItemClickOfNet.create("Other"));

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
    allList.add(TestSelectEntity(title: "Android"));
    allList.add(TestSelectEntity(title: "iOS"));
    allList.add(TestSelectEntity(title: "Web"));
    allList.add(TestSelectEntity(title: "Java"));
    allList.add(TestSelectEntity(title: "Python"));
    allList.add(TestSelectEntity(title: "Go"));
    selectNormalList.add(TestSelectEntity(title: "Android"));
    allLNormaList.add(TestSelectEntity(title: "Android"));
    allLNormaList.add(TestSelectEntity(title: "iOS"));
    allLNormaList.add(TestSelectEntity(title: "Web"));
    allLNormaList.add(TestSelectEntity(title: "Java"));
    allLNormaList.add(TestSelectEntity(title: "Python"));
    allLNormaList.add(TestSelectEntity(title: "Go"));
  }

//  http://bizhi.bcoderss.com/wp-content/uploads/2019/09/d9a34d380cd79123ba7354cda3345982b3b7809f.jpg
  @override
  Widget build(BuildContext context) {
    super.build(context);
    isDark = ThemeUtils.isDark(context);
    return ChangeNotifierProvider<IndexPageProvider>(
      create: (_) => provider,
      child: Scaffold(
        body: Stack(children: <Widget>[
          /// 像素对齐问题的临时解决方法
//          SafeArea(
//            child: SizedBox(
//              height: 180,
//              width: double.infinity,
//                child: isDark ? null : const DecoratedBox(
//                    decoration: BoxDecoration(
//                        gradient: LinearGradient(colors: const [Color(0xFF5793FA), Color(0xFF4647FA)])
//                    )
//                )
//            ),
//          ),
//            ),
          NestedScrollView(
            key: const Key('order_list'),
            physics: ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return _sliverBuilder(context);
            },
            body: Padding(
              padding: EdgeInsets.only(top: 85, left: 20, right: 20),
              child: Container(
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: 7,
                      padding: EdgeInsets.all(10),
                      //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //横轴元素个数
                          crossAxisCount: 2,
                          //纵轴间距
                          mainAxisSpacing: 20.0,
                          //横轴间距
                          crossAxisSpacing: 20.0,
                          //子组件宽高长度比例
                          childAspectRatio: 1.0),
                      itemBuilder: (BuildContext context, int index) {
                        //Widget Function(BuildContext context, int index)
                        return getItemContainer(index);
                      })),
            ),

//              body: PageView.builder(
//                key: const Key('pageView'),
//                itemCount: 5,
//                onPageChanged: _onPageChange,
//                controller: _pageController,
//                itemBuilder: (_, index) {
//                  return OrderList(index: index);
//                },
          ),
        ]),
      ),
    );
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
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          expandedHeight: 130.0,
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
            titlePadding: const EdgeInsetsDirectional.only(
                start: 26.0, end: 16.0, top: 76, bottom: 6.0),
            collapseMode: CollapseMode.pin,
            title: Text(
              '今天从哪里开始呢？',
              style: TextStyle(color: ColorUtil.hexToColor("#263248")),
            ),
          ),
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color:  Color(0x80ccd7e9),
                      offset: Offset(0, 0.5),
                      blurRadius: 8.0,
                      spreadRadius: -.0),
                ],
                color: isDark ? Colours.dark_bg_color : Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                    height: 50.0,
                    padding: const EdgeInsets.only(top: 8),
                    child: MultiSelectChip(
                      allLNormaList,
                      selectList: selectNormalList,
                      onSelectionChanged: (selectedList) {
                        selectedList.forEach((e) {
                          print((e as TestSelectEntity).title);
                        });

//                        allLNormaList = selectedList;
                      },
                    )),
              ),
            ),
            50.0),
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
    return MyCard(
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Container(
          alignment: Alignment.center,
          child:
          SizedBox(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 60.0,
                      width: 60.0,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(20.0),
                      ),
                      child: LoadAssetImage("support/arms")),
                ),
                Align(
                  alignment: Alignment.center,
                  child:Padding(
                    padding: EdgeInsets.only(top: 68),
                    child: Text(
                      _list[index].title,
                      style: TextStyle(color: Color(0xff263248),fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ),
                ),

              ],
            ),
          )
          ,
        ),
      ),

    );
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
      this.backGroundColors,
      this.typeName,
      this.type,
      this.code);

  ItemClickOfNet.create(title) {
    this.title = title;
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
