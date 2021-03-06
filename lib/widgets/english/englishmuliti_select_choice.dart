
/// @desp:标签选择器
/// @time 2019/5/13 11:20
/// @author lizubing
import 'package:flutter/material.dart';
import 'package:task/widgets/english/englishselect_choice_chip.dart';

import 'package:task/widgets/support/base_select_entity.dart';





class MultiSelectChip<T extends BaseSelectEntity> extends StatefulWidget {
  /// 标签的list
  final List<T> dataList;

  /// 标签的list
  final List<T> selectList;

  ///选择回调事件
  final Function(List<T>) onSelectionChanged;

  MultiSelectChip(this.dataList, {this.selectList, this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState(selectList);
}

class _MultiSelectChipState<T extends BaseSelectEntity>
    extends State<MultiSelectChip> {
  List<T> selectList;

  _MultiSelectChipState(this.selectList);

  _buildChoiceList() {
    List<Widget> choices = List();
    widget.dataList.forEach((item) {
//      print("eeeeeeeeee"+selectList.length.toString() + " . " + selectList.contains(item).toString() +
//      " "+ widget.dataList.length.toString());
      choices.add(Container(
        padding: EdgeInsets.only(top: 4,left: 4,right: 4,),
        child: SelectChoiceChip(
          text: item.getTag(),
          selected: selectList.contains(item),
          onSelected: (selected) {
            setState(() {
              selectList.clear();
              selectList.contains(item)
                  ? selectList.remove(item)
                  : selectList.add(item);
              widget.onSelectionChanged(selectList);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
        scrollDirection:Axis.horizontal,
      children: _buildChoiceList(),
    );
  }
}