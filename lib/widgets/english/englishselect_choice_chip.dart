import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// @desp:
/// @time 2019/10/30 14:44
/// @author lizubing
class SelectChoiceChip extends StatefulWidget {
  final String text;
  final double height;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final Color textColor;
  final Color boxColor;
  final Color textSelectColor;
  final Color boxSelectColor;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder border;
  final BoxBorder selectBorder;
  final ValueChanged<bool> onSelected;
  final bool selected;

  const SelectChoiceChip({
    @required this.text,
    this.height = 28,
    this.padding = const EdgeInsets.only(left: 18, right: 18),
    this.fontSize = 15,
    this.textColor = const Color(0xFF807F8F),
    this.textSelectColor = const Color(0xFF15142A),
    this.boxColor = const Color(0x00FFFFFF),
    this.boxSelectColor = const Color(0xff5676E7),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.border = const Border.fromBorderSide(BorderSide(
        color: Color(0x00535353), width: 1, style: BorderStyle.solid)),
    this.selectBorder = const Border.fromBorderSide(BorderSide(
        color: Color(0x001C74D0), width: 1, style: BorderStyle.solid)),
    this.onSelected,
    this.selected,
  });

  @override
  State<StatefulWidget> createState() {
    return _SelectChoiceChipState();
  }
}

class _SelectChoiceChipState extends State<SelectChoiceChip> {
  @override
  Widget build(BuildContext context) {
    bool _select = widget.selected;

    return GestureDetector(
      onTap: () {
        widget.onSelected(!_select);
      },
      child: Container(
        height: widget.height,
        padding: widget.padding,
        child: Stack(
          overflow: Overflow.clip,
          alignment: Alignment.topCenter,
          children: <Widget>[
            Text(
              widget.text,
              style: new TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: widget.fontSize,
                  color: _select ? widget.textSelectColor : widget.textColor),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                  height: 3,
                  width: 23,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: widget.boxColor,
                          offset: Offset(0, 0),
                          blurRadius: 8.0,
                          spreadRadius: 1.0),
                    ],
                    color: _select ? widget.boxSelectColor : widget.boxColor,
                    borderRadius: widget.borderRadius,
                  )),
            )
          ],
        ),
//          decoration: new BoxDecoration(
//              color: _select ? widget.boxSelectColor : widget.boxColor,
//              borderRadius: widget.borderRadius,
//              border: _select ? widget.selectBorder : widget.border)
      ),
    );
  }
}
