
import 'package:task/index/page/task/task.dart';

import 'index/page/login/user.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "Task") {
      return Task.fromJson(json) as T;
    } else if (T.toString() == "User") {
      return User.fromJson(json) as T;
//    } else if (T.toString() == "SearchEntity") {
//      return SearchEntity.fromJson(json) as T;
//    } else if (T.toString() == "UserEntity") {
//      return UserEntity.fromJson(json) as T;
    } else {
      print('generateOBJ error: ' +T.toString());
      return null;
    }
  }
}