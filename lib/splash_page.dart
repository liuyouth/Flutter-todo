
import 'dart:async';


import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:task/common/common.dart';
import 'package:task/index/index_router.dart';
import 'package:task/index/page/login/login_core.dart';
import 'package:task/index/page/task/info_core.dart';
import 'package:task/index/page/task/search_task_list_core.dart';

import 'package:task/index/page/task/task_list_core.dart';


import 'package:task/provider/theme_provider.dart';
import 'package:task/routers/fluro_navigator.dart';
import 'package:task/util/image_utils.dart';
import 'package:task/util/log_utils.dart';
import 'package:task/widgets/load_image.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
//import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:flustars/flustars.dart';
import 'package:task/index/page/task/task_list_core.dart';
import 'package:task/packages/fast_mvvm/fast_mvvm.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  int _status = 0;
  List<String> _guideList = ["app_start_1", "app_start_2", "app_start_3"];
  StreamSubscription _subscription;

  @override
  void initState() {
    initMVVM<BaseViewModel>(
      [LoginModel(),
        InfoModel(),
        TaskListModel(),SearchTaskListModel()],
      controllerBuild: () => EasyRefreshController(),
      resetRefreshState: (c) =>
          (c as EasyRefreshController)?.resetRefreshState(),
      finishRefresh: (c, {bool success, bool noMore}) =>
          (c as EasyRefreshController)
              ?.finishRefresh(success: success, noMore: noMore),
      resetLoadState: (c) => (c as EasyRefreshController)?.resetLoadState(),
      finishLoad: (c, {bool success, bool noMore}) =>
          (c as EasyRefreshController)
              ?.finishLoad(success: success, noMore: noMore),
    );
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Log.init();
      await SpUtil.getInstance();
      // 由于SpUtil未初始化，所以MaterialApp获取的为默认主题配置，这里同步一下。
//      Provider.of<ThemeProvider>(context).syncTheme();
      if (SpUtil.getBool(Constant.keyGuide, defValue: true)){
//        / 预先缓存图片，避免直接使用时因为首次加载造成闪动
        _guideList.forEach((image){
          precacheImage(ImageUtils.getAssetImage(image), context);
        });
      }
      _initSplash();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initGuide() {
    setState(() {
      _status = 1;
    });
  }

  void _initSplash(){
    _subscription = Observable.just(1).delay(Duration(milliseconds: 1500)).listen((_){
      if (SpUtil.getBool(Constant.keyGuide, defValue: true)) {
        SpUtil.putBool(Constant.keyGuide, false);
        _initGuide();
      } else {
        _goLogin();
      }
    });
  }

  _goLogin(){
//    NavigatorUtils.push(context, IndexRouter.taskPage,replace: true);
    NavigatorUtils.push(context, IndexRouter.loginPage, replace: true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _status == 0 ? Image.asset(
        ImageUtils.getImgPath("start_page", format: "jpg"),
        width: double.infinity,
        fit: BoxFit.fill,
        height: double.infinity,
      ) : Swiper(
        key: const Key('swiper'),
        itemCount: _guideList.length,
        loop: false,
        itemBuilder: (_, index){
          return LoadAssetImage(
            _guideList[index],
            key: Key(_guideList[index]),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        },
        onTap: (index){
          if (index == _guideList.length - 1){
            _goLogin();
          }
        },
      )
    );
  }
}
