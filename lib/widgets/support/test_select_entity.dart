import 'base_select_entity.dart';

/// @desp:
/// @time 2019/6/18 17:14
/// @author lizubing

class TestSelectEntity implements BaseSelectEntity {
  final String title;
  int id;
  TestSelectEntity({this.title});
  TestSelectEntity.of({this.id,this.title});

  @override
  String getTag() {
    return title;
  }
}