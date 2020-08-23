import 'package:flutter/cupertino.dart';
import 'package:task/res/colors.dart';
import 'package:task/util/theme_utils.dart';


class AccountCard extends StatefulWidget {

  const AccountCard({
    Key key,
    @required this.child,
    this.type
  }): super(key: key);

  final Widget child;
  final int type;

  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: ThemeUtils.isDark(context) ? null : [
            BoxShadow(color: widget.type == 1 ? const Color(0x804EE07A) : const Color(0x805793FA), offset: Offset(0.0, 2.0), blurRadius: 8.0, spreadRadius: 0.0),
          ],
          gradient: LinearGradient(
              colors: widget.type == 1 ? const [Color(0xFF40E6AE), Color(0xFF2DE062)] : const [Color(0xFF57C4FA), Colours.app_main]
          )
      ),
      child: widget.child,
    );
  }
}
