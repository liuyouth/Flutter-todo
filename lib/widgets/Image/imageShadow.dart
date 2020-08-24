import 'dart:ui';

import 'package:flutter/widgets.dart';
/// @desp: 图片阴影
/// @time 2020年08月23日12:28:34
/// @author liubo
class ImageShadow extends StatefulWidget {
  final String url;
  const ImageShadow({
    @required this.url});

  @override
  State<StatefulWidget> createState() {
    return _ImageShadowState();
  }


}

// ignore: camel_case_types
class _ImageShadowState extends State<ImageShadow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Stack(//重叠的Stack Widget，实现重贴
        children: <Widget>[
          Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
// 容器组件
                    width: 200.0,
                    height: 200.0,
                    child: Center(
                        child: Image.network(widget.url)),
                  ))),
          Center(
            child: ClipRect(
//裁切长方形
              child: BackdropFilter(
//背景滤镜器
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 6.0),
//图片模糊过滤，横向竖向都设置5.0
                child: Opacity(
//透明控件
                    opacity: 1,
                    child: Container(
// 容器组件
                        width: 220.0,
                        height: 230.0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: const EdgeInsets.only(top: 5),
                            width: 200.0,
                            height: 205.0,
                            child: new ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                  widget.url),
                            ),
                          ),
                        ))),
              ),
            ),
          )
        ]),);
  }
}
