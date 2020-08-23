
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:task/res/resources.dart';
import 'package:task/util/image_utils.dart';
import 'package:task/util/theme_utils.dart';

class SelectedImage extends StatelessWidget {

  const SelectedImage({
    Key key,
    this.size : 80.0,
    this.onTap,
    this.image
  }): super(key: key);

  final double size;
  final GestureTapCallback onTap;
  final File image;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          // 图片圆角展示
          borderRadius: BorderRadius.circular(16.0),
          image: DecorationImage(
            image: image == null ? ImageUtils.getAssetImage("store/icon_zj") : FileImage(image),
            fit: BoxFit.cover,
            colorFilter: image == null ? ColorFilter.mode(ThemeUtils.getDarkColor(context, Colours.dark_unselected_item_color), BlendMode.srcIn) : null
          ),
        ),
      ),
    );
  }
}

