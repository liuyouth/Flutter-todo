
import 'package:fluro/fluro.dart';
import 'package:task/index/page/english_page.dart';
import 'package:task/index/page/in_page.dart';
import 'package:task/index/page/index_page.dart';
import 'package:task/index/page/login/login_page.dart';
import 'package:task/index/page/suitcase_page.dart';
import 'package:task/index/page/task/info_page.dart';
import 'package:task/index/page/task/search_task_list_page.dart';

import 'package:task/index/page/task/task_list_page.dart';

import 'package:task/index/page/todo_page.dart';

//import 'package:task/index/page/todo_page.dart';
import 'package:task/index/page/todo_page_mvvm.dart';

import 'package:task/routers/router_init.dart';





class IndexRouter implements IRouterProvider{

  static String indexPage = "/index";
  static String englishPage = "/english";
  static String inPage = "/in";
  static String todoPage = "/todo";
  static String taskPage = "/task";
  static String infoPage = "/info/";
  static String searchTaskPage = "/task/search";
  static String suitcasePage = "/suitcase";
  static String artPage = "/art";
  static String sPage = "/s";
  static String loginPage = "/login";

  
  @override
  void initRouter(Router router) {
    router.define(loginPage, handler: Handler(handlerFunc: (_, params) => LoginPage()));
    router.define(infoPage, handler: Handler(handlerFunc: (_, params) => InfoPage(number: int.parse(params["number"].first))));
    router.define(sPage, handler: Handler(handlerFunc: (_, params) => SelectPage()));
    router.define(taskPage, handler: Handler(handlerFunc: (_, params) => TaskListPage( true,loadData: true,configState: true)));
    router.define(searchTaskPage, handler: Handler(handlerFunc: (_, params) => SearchTaskListPage( true,loadData: true,configState: true)));
    router.define(inPage, handler: Handler(handlerFunc: (_, params) => IndexPage()));
    router.define(englishPage, handler: Handler(handlerFunc: (_, params) => EnglishPage()));
    router.define(indexPage, handler: Handler(handlerFunc: (_, params) => InPage()));
    router.define(todoPage, handler: Handler(handlerFunc: (_, params) => TodoPage()));
    router.define(suitcasePage, handler: Handler(handlerFunc: (_, params) => SuitcasePage()));
  }
  
}