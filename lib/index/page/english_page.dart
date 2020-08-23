import 'package:flustars/flustars.dart' as FlutterStars;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:task/common/common.dart';
import 'package:task/index/page/index_page.dart';

import 'package:task/res/resources.dart';
import 'package:task/routers/fluro_navigator.dart';

import 'package:task/util/ColorUtil.dart';
import 'package:task/util/theme_utils.dart';
import 'package:task/widgets/SliverAppBarDelegate.dart';
import 'package:task/widgets/english/englishmuliti_select_choice.dart';
import 'package:task/widgets/load_image.dart';
import 'package:task/widgets/my_card.dart';
import 'package:task/widgets/state_layout.dart';
import 'package:task/widgets/support/card.dart';
import 'package:task/widgets/support/test_select_entity.dart';
import 'package:provider/provider.dart';

import '../index_router.dart';
import 'index_page_provider.dart';

/// https://dribbble.com/shots/6356495-Keep-learning/attachments
/// design/首页/English.html
class EnglishPage extends StatefulWidget {
  @override
  _EnglishPageState createState() => _EnglishPageState();
}

class _EnglishPageState extends State<EnglishPage>
    with
        AutomaticKeepAliveClientMixin<EnglishPage>,
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
  List<BookItem> _books = [];

  @override
  void initState() {
    super.initState();
    initData();
    _books.clear();
    _books.add(
        BookItem("Unit 5", "- Runing business in Sweden", 34, "Business", 15));
    _books.add(BookItem("Unit 3", "- Job interview", 48, "Business", 45));
    _books.add(
        BookItem("Unit 8", "- Runing business in Sweden", 23, "Business", 23));
    _books.add(
        BookItem("Unit 7", "- Runing business in Sweden", 59, "Business", 23));
    _books.add(
        BookItem("Unit 2", "- Runing business in Sweden", 123, "Business", 99));
    _books.add(BookItem("Unit 3", "- Job interview", 48, "Business", 45));
    _books.add(
        BookItem("Unit 8", "- Runing business in Sweden", 23, "Business", 23));
    _books.add(
        BookItem("Unit 7", "- Runing business in Sweden", 59, "Business", 23));
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

    selectNormalList.add(TestSelectEntity(title: "Android"));
    allLNormaList.add(TestSelectEntity(title: "Android"));
    allLNormaList.add(TestSelectEntity(title: "iOS"));
    allLNormaList.add(TestSelectEntity(title: "Web"));
    allLNormaList.add(TestSelectEntity(title: "Java"));
  }

//  http://bizhi.bcoderss.com/wp-content/uploads/2019/09/d9a34d380cd79123ba7354cda3345982b3b7809f.jpg
  @override
  Widget build(BuildContext context) {
    super.build(context);
    isDark = ThemeUtils.isDark(context);
    return ChangeNotifierProvider<IndexPageProvider>(
      create: (_) => provider,
      child: Scaffold(
        backgroundColor: Color(0xffEEF1FA),
        body: Stack(children: <Widget>[
          NestedScrollView(
            key: const Key('order_list'),
            physics: ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return _sliverBuilder(context);
            },
            body: Padding(
              padding: EdgeInsets.only(top: 5, left: 6, right: 6),
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 7,
                  padding: EdgeInsets.all(10),
                  //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 1,
                      //纵轴间距
                      mainAxisSpacing: 15.0,
                      //横轴间距
                      crossAxisSpacing: 10.0,
                      //子组件宽高长度比例
                      childAspectRatio: 4.0),
                  itemBuilder: (BuildContext context, int index) {
                    //Widget Function(BuildContext context, int index)
                    return getItemContainer(index);
                  }),

//              body: PageView.builder(
//                key: const Key('pageView'),
//                itemCount: 5,
//                onPageChanged: _onPageChange,
//                controller: _pageController,
//                itemBuilder: (_, index) {
//                  return OrderList(index: index);
//                },
            ),
          )
        ]),
      ),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context) {
    return <Widget>[
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            DecoratedBox(
              decoration: BoxDecoration(
                color: isDark ? Colours.dark_bg_color : Colors.white,
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Container(
                      padding: const EdgeInsets.only(top: 30),
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            top: 5,
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Christine Collier",
                                  style: TextStyle(
                                      color: Color(0xff15142A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Business English",
                                  style: TextStyle(
                                      color: Color(0xff807F8F),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            right: 15,
                            bottom: 0,
                            child: IconButton(
                              onPressed: () {
                                NavigatorUtils.push(
                                    context, IndexRouter.indexPage);
                              },
                              tooltip: '菜单',
                              icon: LoadAssetImage(
                                "english/english_index_menu_ic",
                                width: 26.0,
                                height: 26.0,
                                color: ThemeUtils.getIconColor(context),
                              ),
                            ),
                          ),
                        ],
                      ))),
            ),
            90.0),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: SliverAppBarDelegate(
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
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
//                padding: EdgeInsets.only(left: 20,right: 20),
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                    decoration: BoxDecoration(),
                    height: 50.0,
                    padding: const EdgeInsets.only(top: 0),
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
            45.0),
      ),
      SliverAppBar(
        automaticallyImplyLeading: false,
        //展开高度200
        expandedHeight: 90.0,
        //不随着滑动隐藏标题
        floating: true,
        //固定在顶部
        pinned: false,
        flexibleSpace: FlexibleSpaceBar(
          background: LoadAssetImage(
            "english/english_book",
            color: ThemeUtils.getIconColor(context),
            fit: BoxFit.fill,
          ),
        ),
      ),
      SliverPersistentHeader(
        delegate: SliverAppBarDelegate(
            DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 10, left: 16, right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Latest results",
                        style: TextStyle(
                            color: Color(0xff15142A),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Latest results",
                            style: TextStyle(
                                color: Color(0xff15142A),
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: LoadAssetImage(
                              "english/english_index_down_ic",
                              color: ThemeUtils.getIconColor(context),
                              width: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            30),
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
          padding: EdgeInsets.only(top: 15,left: 15,bottom: 15,right: 10),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _books[index].title + _books[index].info,
                  style: TextStyle(
                      color: Color(0xff15142A),
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18),
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                           mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: LoadAssetImage(
                                    "english/english_index_file_ic",
                                    color: ThemeUtils.getIconColor(context),
                                    width: 10,
                                  ),
                                ),
                                Text(
                                  _books[index].pageSize.toString() + " cards",
                                  style: TextStyle(
                                      color: Color(0xff15142A),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 15, right: 5),
                                  child: LoadAssetImage(
                                    "english/english_index_tag_ic",
                                    color: ThemeUtils.getIconColor(context),
                                    width: 10,
                                  ),
                                ),
                                Text(
                                  _books[index].tag,
                                  style: TextStyle(
                                      color: Color(0xff15142A),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[

                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Text(
                                    _books[index].percentage.toString()+"%",
                                    style: TextStyle(
                                        color: Color(0xffFF5562),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                SizedBox(
                                    height: 5.0,
                                    width: 70.0,
                                    // 圆角矩形剪裁（`ClipRRect`）组件，使用圆角矩形剪辑其子项的组件。
                                    child: ClipRRect(
                                      // 边界半径（`borderRadius`）属性，圆角的边界半径。
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      child: LinearProgressIndicator(
                                        value: _books[index].percentage/100,
                                        backgroundColor: Color(0xffDFE0E5),
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF5562)),
                                      ),
                                    )
                                )
                              ],
                            )
                          ],
                        )),

                  ],
                )
              ),
            ],
          )
//        Container(
//          alignment: Alignment.center,
//          child: SizedBox(
//            child: Stack(
//              children: <Widget>[
//
//                Align(
//                  alignment: Alignment.center,
//                  child: Container(
//                      height: 40.0,
//                      width: 40.0,
//                      padding: const EdgeInsets.all(8.0),
//                      child: LoadAssetImage("support/arms",width: 40,height: 40,)),
//                ),
//                Align(
//                  alignment: Alignment.center,
//                  child: Padding(
//                    padding: EdgeInsets.only(top: 68),
//                    child: Text(
//                      _list[index].title,
//                      style: TextStyle(
//                          color: Color(0xff263248),
//                          fontWeight: FontWeight.w500,
//                          fontSize: 18),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
          ),
    );
  }
}

class BookItem {
  String title;
  String info;
  int pageSize;
  String tag;
  int percentage;

  BookItem(this.title, this.info, this.pageSize, this.tag, this.percentage);
}
