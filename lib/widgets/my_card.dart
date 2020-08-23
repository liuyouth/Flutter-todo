import 'package:flutter/material.dart';
import 'package:task/res/colors.dart';
import 'package:task/util/theme_utils.dart';

class MyCard extends StatelessWidget {
  const MyCard({Key key, @required this.child, this.color, this.shadowColor})
      : super(key: key);

  final Widget child;
  final Color color;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    Color _backgroundColor;
    Color _shadowColor;
    bool isDark = ThemeUtils.isDark(context);
    if (color == null) {
      _backgroundColor = isDark ? Colours.dark_bg_gray_ : Colors.white;
    } else {
      _backgroundColor = color;
    }
//    #ccd7e9
    // DCE7FA
    if (shadowColor == null) {
      _shadowColor = isDark ? Colors.transparent : const Color(0x80ccd7e9);
    } else {
      _shadowColor = isDark ? Colors.transparent : shadowColor;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: _shadowColor,
                offset: Offset(1.0, 2.0),
                blurRadius: 8.0,
                spreadRadius: -.0),
          ]),
      child: child,
    );
  }
}
