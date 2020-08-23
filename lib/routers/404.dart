import 'package:flutter/material.dart';
import 'package:task/widgets/app_bar.dart';
import 'package:task/widgets/state_layout.dart';


class WidgetNotFound extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        centerTitle: "页面不存在",
      ),
      body: const StateLayout(
        type: StateType.account,
        hintText: "页面不存在",
      ),
    );
  }
}
