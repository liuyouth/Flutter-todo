import 'dart:convert';

import 'package:flustars/flustars.dart' as FlutterStars;
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:task/common/common.dart';
import 'package:task/index/page/index_page.dart';

import 'package:task/res/resources.dart';
import 'package:task/routers/fluro_navigator.dart';
import 'package:task/util/theme_utils.dart';
import 'package:task/widgets/SliverAppBarDelegate.dart';
import 'package:task/widgets/english/englishmuliti_select_choice.dart';
import 'package:task/widgets/load_image.dart';
import 'package:task/widgets/my_card.dart';
import 'package:task/widgets/support/test_select_entity.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'index_page_provider.dart';

/// https://dribbble.com/shots/6356495-Keep-learning/attachments
/// design/首页/English.html
class SuitcasePage extends StatefulWidget {
  @override
  _SuitcasePageState createState() => _SuitcasePageState();
}

class _SuitcasePageState extends State<SuitcasePage>
    with
        AutomaticKeepAliveClientMixin<SuitcasePage>,
        SingleTickerProviderStateMixin {
  //定义一个controller
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  IndexPageProvider provider = IndexPageProvider();
  final FocusNode _nodeText1 = FocusNode();

  //用于切换焦点
  FocusScopeNode focusScopeNode;
  bool _isClick = false;
  List<ItemClickOfNet> _list = [];
  num selectedPosition = 0;
  List<BookItem> _books = [BookItem(213333, "wee", "233", 1, "嗯嗯嗯", 0)];

  @override
  void initState() {
    super.initState();
    initData().then((list) => initGroups(list));
    //监听输入改变
    _nameController.addListener(_verify);
    _passwordController.addListener(_verify);
    _nameController.text = FlutterStars.SpUtil.getString(Constant.phone);
  }

  void initGroups(list) {
    allLNormaList = list;
    selectNormalList.add(allLNormaList[0]);
    selectGroup(selectNormalList[0]);
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

  bool isDark = false;
  String groupValue;
  List<TestSelectEntity> selectList = new List();

  List<TestSelectEntity> allList = new List();

  List<TestSelectEntity> selectNormalList = new List();

  List<TestSelectEntity> allLNormaList = new List();

  Future initData() async {
    await SpUtil.getInstance();
    if (SpUtil.getObjectList("groups") == null) {
      allLNormaList = new List();
      allLNormaList.add(TestSelectEntity.of(id: 0, title: "主行李箱"));
      allLNormaList.add(TestSelectEntity.of(id: 1, title: "背包"));
      allLNormaList.add(TestSelectEntity.of(id: 2, title: "副行李箱"));
      allLNormaList.add(TestSelectEntity.of(id: 3, title: "第二背包"));
    } else
      allLNormaList = SpUtil.getObjectList("groups").cast<TestSelectEntity>();
    return allLNormaList;

    print("initData " + _books.length.toString());
  }

  void selectGroup(TestSelectEntity selected) {
    _books =
        SpUtil.getObjList(selected.id.toString(), (v) => BookItem.fromJson(v));
    print("_books222" + _books.length.toString());

    if (SpUtil.getObjectList(selected.id.toString()) == null) {
      _books = new List();
    } else {
      _books = SpUtil.getObjList(
          selected.id.toString(), (v) => BookItem.fromJson(v));
    }

    setState(() {
      _books = _books;
    });
  }

  void save(BookItem book) {
    setState(() {
      _books.add(book);
    });
    SpUtil.putObjectList(selectNormalList[0].id.toString(), _books);
    if (SpUtil.getObjectList(selectNormalList[0].id.toString()) == null) {
      _books = new List();
    } else {
      _books = SpUtil.getObjList(
          selectNormalList[0].id.toString(), (v) => BookItem.fromJson(v));
    }
  }

  void update(BookItem book) {
    for (var x in _books) {
      print(x.toJson().toString());
    }
    int index = _books.indexWhere((BookItem element) {
      return element.id == book.id;
    });
    setState(() {
      _books.removeAt(index);
      _books.insert(index, book);
    });
    SpUtil.putObjectList(selectNormalList[0].id.toString(), _books);
  }

  void removeAt(int index) {}
  TextEditingController textEditingController = new TextEditingController();

//  http://bizhi.bcoderss.com/wp-content/uploads/2019/09/d9a34d380cd79123ba7354cda3345982b3b7809f.jpg
  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("build" + _books.length.toString());
    setState(() {
      _books = _books;
    });
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
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: _books.length,
                  padding: EdgeInsets.all(10),
                  //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 1,
                      //纵轴间距
                      mainAxisSpacing: 15.0,
                      //横轴间距
                      crossAxisSpacing: 20.0,
                      //子组件宽高长度比例
                      childAspectRatio: 6.0),
                  itemBuilder: (BuildContext context, int index) {
                    //Widget Function(BuildContext context, int index)
                    return getItemContainer(index);
                  }),
            ),

//              body: PageView.builder(
//                key: const Key('pageView'),
//                itemCount: 5,
//                onPageChanged: _onPageChange,
//                controller: _pageController,
//                itemBuilder: (_, index) {
//                  return OrderList(index: index);
//                },
          )
        ]),
      ),
    );
  }

  _showDeleteBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SafeArea(
            child: Container(
                height: 165.2,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Theme.of(context).accentColor,
                        child: const Text("编辑",
                            style: TextStyle(fontSize: Dimens.font_sp18)),
                        onPressed: () {
                          NavigatorUtils.goBack(context);

                          showEditInput("编辑", "修改物品名称", "请输入新名称",
                              _books[index].info.toString(), () {
                            if (textEditingController.text.length > 0) {
//        save(BookItem.of(textEditingController.text));
                              _books[index].info = textEditingController.text;
                              update(_books[index]);
                            } else
                              showToast("该物品没有名称，添加失败");
                          });
                        },
                      ),
                    ),
//                    Container(
//                        height: 52.0,
//                        child: Row(
//                          children: <Widget>[
//                            FlatButton(
//                              child: Text(
//                                "编辑",
//                                style: TextStyle(
//                                    color: Color(0xff15142A),
//                                    fontSize: 15,
//                                    fontWeight: FontWeight.w500),
//                              ),
//                              onPressed: () {
//                                NavigatorUtils.goBack(context);
//                                Future.delayed(Duration(milliseconds: 0), (){
//                                  showEditInput("编辑", "修改物品名称", "请输入新名称",
//                                      _books[index].info.toString(), () {
//                                        if (textEditingController.text.length > 0) {
////        save(BookItem.of(textEditingController.text));
//                                          _books[index].info = textEditingController.text;
//                                          update(_books[index]);
//                                        } else
//                                          showToast("该物品没有名称，添加失败");
//                                      });
//                                });
//
//                              },
//                            ),
//                          ],
//                        )),
                    Gaps.line,
                    Container(
                      height: 54.0,
                      width: double.infinity,
                      child: FlatButton(
                        textColor: Theme.of(context).errorColor,
                        child: const Text("删除",
                            style: TextStyle(fontSize: Dimens.font_sp18)),
                        onPressed: () {
                          setState(() {
                            removeAt(index);
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

  @override
  bool get wantKeepAlive => true;

  Widget getItemContainer(int index) {
    return MyCard(
        child: InkWell(
      //Toast.show("长按删除账号！");
      onLongPress: () {
        _showDeleteBottomSheet(index);
      },
      child: GestureDetector(
          child: Padding(
              padding: EdgeInsets.only(top: 5, left: 15, bottom: 5, right: 15),
              child:   Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _books[index].info,
                        style: TextStyle(
                            color: Color(0xff15142A),
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _books[index].isOk
                          ? LoadAssetImage(
                              "todo/ok",
                              width: 20.0,
                              height: 20.0,
                              color: ThemeUtils.getIconColor(context),
                            )
                          : null,
//                    child: _books[index].isOk ? Image.asset("todo/ok") : null,
                    ),
                  ],
                ),
              ),
          onTap: () {
            print(_books[index].isOk);
            print(index);
            _books[index].isOk = !_books[index].isOk;
            update(_books[index]);
          }),
    ));
  }

  void showEditInput(title, info, hint, String value, voidCallback) {
    if (null == focusScopeNode) {
      focusScopeNode = FocusScope.of(context);
    }
    focusScopeNode.requestFocus(_nodeText1);

    textEditingController.text = value;
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Card(
              elevation: 0.0,
              child: Column(
                children: <Widget>[
                  Text(info),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: hint,
                        filled: true,
                        fillColor: Colors.grey.shade50),
                    controller: textEditingController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('取消'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  voidCallback();
//                  showToast(textEditingController.text);
                },
                child: Text('确定'),
              ),
            ],
          );
        });
  }

  void showAddGoodsDiaLog() {
    showEditInput(
        "清单添加物品", "向" + selectNormalList[0].title + "添加物品", "要添加的物品名称", "", () {
      if (textEditingController.text.length > 0) {
//        save(BookItem.of(textEditingController.text));
        print(_books);
        print(_books.length);
        BookItem boo = BookItem(_books.length - 1, "Unit 5",
            textEditingController.text, 34, "Business", 15);
        save(boo);
      } else
        showToast("该物品没有名称，添加失败");
    });
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
                                  "随行清单",
                                  style: TextStyle(
                                      color: Color(0xff15142A),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "出行必备物品",
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
                                showToast("编辑功能稍后上线");
//                                showEditInput(
//                                    "编辑", "修改清单名称", "请输入新名称", "", () {});
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
//                        selectedList.forEach((e) {
//                          print((e as TestSelectEntity).title);
//                        });
                        selectGroup(selectedList[0]);
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
                  padding: EdgeInsets.only(top: 10, left: 0, right: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          "添加",
                          style: TextStyle(
                              color: Color(0xff15142A),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          showAddGoodsDiaLog();
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "长按某条进行编辑",
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
}

class BookItem {
  int id;
  String title;
  String info;
  int pageSize;
  String tag;
  int percentage;
  bool isOk = false;

  /// 将json字符串解析成实体类对象
  BookItem parsePlatformJson(String jsonStr) {
    BookItem result = BookItem.fromMap(jsonDecode(jsonStr));
    return result;
  }

  BookItem(
      this.id, this.title, this.info, this.pageSize, this.tag, this.percentage);

  static BookItem fromMap(Map<String, dynamic> map) {
    BookItem b = new BookItem(map["id"], map["title"], map["info"],
        map["pageSize"], map["tag"], map["percentage"]);
    return b;
  }

//  BookItem.fromJSON(Map<String, dynamic> response);
  /// 必须写.
  BookItem.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        isOk = json['isOk'],
        info = json['info'],
        tag = json['tag'],
        id = json['id'];

  /// 必须写.
  Map<String, dynamic> toJson() =>
      {'title': title, 'id': id, 'info': info, 'tag': tag, 'isOk': isOk};
}
