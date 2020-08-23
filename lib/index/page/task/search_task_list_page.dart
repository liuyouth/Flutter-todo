import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:task/index/index_router.dart';
import 'package:task/index/page/task/search_task_list_core.dart';
import 'package:task/index/page/task/task.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';
import 'package:task/res/resources.dart';
import 'package:task/res/styles.dart';
import 'package:task/routers/fluro_navigator.dart';
import 'package:task/util/log_utils.dart';
import 'package:task/widgets/lb/BottomDragWidget.dart';
import 'package:task/widgets/lb/TopDragWidget.dart';
import 'package:task/widgets/my_card.dart';

class SearchTaskListPage extends StatelessWidget
    with BaseView<SearchTaskListVM> {
  const SearchTaskListPage(
    this.rootRefresh, {
    Key key,
    this.configState = false,
    this.loadData = true,
  }) : super(key: key);

  /// 是否全局刷新
  final bool rootRefresh;
  final bool configState;
  final bool loadData;
  _refresh(SearchTaskListVM vm){
    vm.viewRefresh(rootRefresh: true);
  }
  _onCancelBack(BuildContext c) {
    Navigator.of(c).pop(1);
  }
//
  @override
  ViewConfig<SearchTaskListVM> initConfig(BuildContext context) {
    var _empty = configState
        ? (vm) => Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("没有搜索到匹配的数据", style: TextStyles.textDarkGray14),
                Text("", style: TextStyles.textDarkGray14),
                InkWell(onTap:  ()=>_refresh(vm), child: Text("刷新一下", style: TextStyles.btnText,),),
              ],))
        : null;
    return rootRefresh
        ? ViewConfig<SearchTaskListVM>(vm: SearchTaskListVM(loadData), empty: _empty)
        : ViewConfig<SearchTaskListVM>.noRoot(vm: SearchTaskListVM(loadData), empty: _empty);
  }


  @override
  Widget vmBuild(
      BuildContext context, SearchTaskListVM vm, Widget child, Widget state) {
    return Scaffold(
        backgroundColor: Color(0xffF2F5F9),
        body: TopDragWidget(
          dragContainer: TopDragContainer( defaultShowHeight: 100.0, height: 200.0, 
            drawer: getSearchBar(vm, context),),
          body: Container(child: Column(
                children: [
                  Container(height: 100,),
                  Expanded(
                    child: state ??
                        Padding(padding: EdgeInsets.only(),
                            child: Column(
                              children: [
                                Expanded(
                                  child: EasyRefresh(
                                    controller: vm.refreshController,
                                    onLoad: vm.loadMore,
                                    onRefresh: vm.pullRefresh,
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(10),
                                      itemCount: vm.list.length,
                                      itemBuilder: (ctx, index) {
                                        return Selector<SearchTaskListVM, Task>(
                                          selector: (_, aVM) => vm.list[index],
                                          shouldRebuild: (pre, next) => pre == next,
                                          builder: (_, Task value, __) => _item(vm,value),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )),
                  )
                ],
              ),
            ),
           ));
  }

  Widget _item(SearchTaskListVM vm, Task item) {
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

  getSearchBar(SearchTaskListVM vm, BuildContext c) {
    return Container(
      ///总高度 不管用
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color(0x80ccd7e9),
              offset: Offset(1.0, 2.0),
              blurRadius: 8.0,
              spreadRadius: .2),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Text(""),
          ),
//          Divider(
//            height: 1.0,
//            color: Colors.black12,
//          ),
          Container(
            width: 300,
            height: 10,
          ),
          Container(
            height: 45,
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: TextField(
                      autofocus: true,
                      controller: vm.textEditingController,
                      decoration: InputDecoration(
                          labelText: '搜索',
                          contentPadding: EdgeInsets.all(15.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(22.0)),
                          fillColor: Colors.blue.shade50,
                          filled: true,
//                          backspace
//                          suffixIcon: vm.textEditingController.text.isNotEmpty ? Icon(Icons.close,color: Colors.black38) :null,
//                          helperText: 'help',
//                          prefixIcon: Icon(Icons.local_airport),
//                          suffixText: 'airport'
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _onCancelBack(c),
                  child: Padding(padding: EdgeInsets.all(3),child:
                  Text("取消", style: TextStyles.btnText,),)
                ),
              ],
            ),
          ),
//          Expanded(child: newListView(),)

          Container(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: 40,
                height: 6,
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
            ),
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
