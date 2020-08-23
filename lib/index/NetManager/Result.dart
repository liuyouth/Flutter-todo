import 'package:common_utils/common_utils.dart';
import 'package:task/common/common.dart';
import 'package:task/entity_factory.dart';

/// Result 请求数据 root 层
/// 囊括了 常规数据 和 列表数据
/// 在调用时 调用getData()方法获取对应的数据
/// data.getData() 并不用转换类型
abstract class ResultI<T> {
  int code;
  String msg;
  dynamic data;

  ResultI();

  ResultI.all(this.code, this.msg, this.data);

  dynamic getData();

  @override
  String toString() {
    return 'ResultI{code: $code, msg: $msg, data: $data}';
  }
}

class Result<T> extends ResultI<T> {
  Result(code, msg, data) : super() {
    this.code = code;
    this.msg = msg;
    this.data = data;
  }

  Result.e();

  Result.fromJson(Map<String, dynamic> json) {
    code = json[Constant.code];
    msg = json[Constant.message];

    if (json.containsKey(Constant.data)) {
      if (json[Constant.data] is List) {
        LogUtil.e(json[Constant.data],
            tag: "fromJson ：Wrong use of Result. ListResult should be used");
      } else {
        print("eeeeo||||" + T.toString());
        if (T.toString() == "String") {
          data = json[Constant.data].toString() as T;
        } else if (T.toString() == "Map<dynamic, dynamic>") {
          data = json[Constant.data] as T;
        } else {
          data = EntityFactory.generateOBJ<T>(json[Constant.data]);
        }
      }
    }
  }

  @override
  String toString() {
    return 'Result{code: $code, msg: $msg, data: $data}';
  }

  @override
  T getData() {
    return data;
  }
}

class ListResult<T> extends ResultI<T> {
  int total;
  int allPage;

  ListResult(code, msg, data) : super.all(code, msg, data) {
    this.code = code;
    this.msg = msg;
    this.data = data;
  }

  ListResult.fromJson(Map<String, dynamic> json) {
    code = json[Constant.code];
    msg = json[Constant.message];
    allPage = json["allPage"];
    total = json["total"];
    if (json.containsKey(Constant.data)) {
      if (json[Constant.data] is List) {
        data = [];
        (json[Constant.data] as List).forEach((item) {
          data.add(EntityFactory.generateOBJ<T>(item));
        });
      } else {
        LogUtil.e(json[Constant.data],
            tag: "fromJson: Wrong use of ListResult. Result should be used");
      }
    }
    print(this.toString());
  }

  @override
  List<T> getData() {
    List<T> datas = [];
    for (var d in data) {
      if (d is T) datas.add(d);
    }
    return datas;
  }

  @override
  String toString() {
    return 'ListResult{code: $code, msg: $msg, total: $total, allPage: $allPage,data: $data}';
  }
}
