// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/notifications/notification_api.dart';
import 'package:todo/todo/screens/add_todo_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../config/pallete.dart';
import '../todo/models/todo.dart';
import '../todo/widgets/todo_tile.dart';
import 'model/tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  List<Todo> todo = [];
  final TextEditingController searchController = TextEditingController();
  String search = '';
  late SharedPreferences prefs;
  setupTodo() async {
    prefs = await SharedPreferences.getInstance();
    String stringTodo = prefs.getString('todo') ?? '';
    if (stringTodo.isNotEmpty) {
      List todoList = jsonDecode(stringTodo);
      for (var t in todoList) {
        setState(() {
          todo.add(Todo(id: 0, title: '', date: '', time: '', status: false)
              .fromJson(t));
        });
      }
    }
  }

  void saveTodo() {
    List items = todo.map((e) => e.toJson()).toList();
    prefs.setString('todo', jsonEncode(items));
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    _controller.addListener(_handleTabSelection);
    setupTodo();

    NotificationApi.init();
    tz.initializeTimeZones();
    setNotifications(todo);
    // listenNotifications();
  }

  // void listenNotifications() => NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setNotifications(List<Todo> todos) {
    NotificationApi.cancelAllNotifications();
    if (todos.isNotEmpty) {
      for (var t in todos) {
        var date = t.date.split('/');
        var time = t.time.split(':');
        int day = int.parse(date[0]);
        int month = int.parse(date[1]);
        int year = int.parse(date[2]);
        int hour = int.parse(time[0]);
        int min = int.parse(time[1]);
        DateTime dt = DateTime(year, month, day, hour, min);
        if (dt.isAfter(DateTime.now()) &&
            dt.difference(DateTime.now()).inMinutes >= 10) {
          NotificationApi.showNotification(
              id: t.id,
              title: t.title,
              body: t.date + ' ' + t.time,
              payload: 'payload',
              dt: dt.subtract(Duration(minutes: 10)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final types = [
      0,
      1,
      2,
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text('Todo',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600)),
            SizedBox(
              width: 10.w,
            ),
            InkWell(
                child: Icon(
                  Icons.alarm,
                  color: Palette.theme,
                ),
                onTap: () {
                  NotificationApi.showNotification(
                      id: 0,
                      title: 'Todo',
                      body: 'Hello',
                      payload: 'payload',
                      dt: DateTime.now().add(Duration(seconds: 2)));
                })
          ],
        ),
        toolbarHeight: 70.w,
        elevation: 0,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 70.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {
                              search = value;
                            });
                          },
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.only(
                                  left: 10.w,
                                  top: 10.w,
                                  bottom: 10.w,
                                  right: 0.w),
                              hintText: 'Search for todo',
                              hintStyle: TextStyle(
                                  fontSize: 13.sp, color: Palette.grey),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0x1A000000)),
                                borderRadius: BorderRadius.all(Radius.zero),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0x1A000000)),
                                borderRadius: BorderRadius.all(Radius.zero),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Palette.grey,
                                size: 15.w,
                              ),
                              prefixIconConstraints:
                                  const BoxConstraints(minWidth: 30)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    height: 50.w,
                    child: TabBar(
                        isScrollable: true,
                        labelStyle: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w500),
                        unselectedLabelColor: Colors.black,
                        indicatorColor: Colors.transparent,
                        labelColor: Palette.theme,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.only(right: 10.w),
                        enableFeedback: false,
                        controller: _controller,
                        automaticIndicatorColorAdjustment: true,
                        tabs: [
                          for (final tab in tabs)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.w),
                                  color: _controller.index == tab.id
                                      ? Palette.lightBlue
                                      : Palette.lightgrey),
                              child: Tab(
                                text: tab.title,
                              ),
                            ),
                        ])),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var type in types)
              Container(
                  color: Colors.white,
                  child: ListView.builder(
                    itemCount: todo.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: ((context, index) {
                      final item = todo[index];
                      return Dismissible(
                        key: Key(item.id.toString()),
                        onDismissed: (direction) {
                          // Remove the item from the data source.
                          setState(() {
                            todo.removeAt(index);
                          });
                          saveTodo();
                          setNotifications(todo);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Todo removed')));
                        },
                        background: Container(
                          color: Colors.red,
                          child: Center(
                            child: Text(
                              'Remove',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.sp),
                            ),
                          ),
                        ),
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                todo[index].status = !todo[index].status;
                              });
                              saveTodo();
                            },
                            child: type == 0
                                ? isSearch(todo[index].title, search)
                                    ? TodoTile(todo: todo[index])
                                    : SizedBox.shrink()
                                : type == 1
                                    ? isToday(todo[index])
                                        ? isSearch(todo[index].title, search)
                                            ? TodoTile(todo: todo[index])
                                            : SizedBox.shrink()
                                        : SizedBox.shrink()
                                    : isUpcomming(todo[index])
                                        ? isSearch(todo[index].title, search)
                                            ? TodoTile(todo: todo[index])
                                            : SizedBox.shrink()
                                        : SizedBox.shrink()),
                      );
                    }),
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.theme,
        onPressed: () {
          addTodo();
          // setNotifications(todo);
        },
        child: Icon(
          Icons.add,
          size: 25.w,
        ),
      ),
    );
  }

  addTodo() async {
    int id = todo.isEmpty ? 0 : todo.last.id + 1;
    Todo t = Todo(id: id, title: '', date: '', time: '', status: false);
    Todo? returnTodo = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddTodoScreen(todo: t)));
    if (returnTodo != null) {
      setState(() {
        todo.add(returnTodo);
      });
      saveTodo();
      setNotifications(todo);
    }
  }

  bool isSearch(String title, String search) {
    if (title.toLowerCase().contains(search.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }

  bool isToday(Todo todo) {
    DateTime now = DateTime.now();
    var d = todo.date.split('/');
    int _day = int.parse(d[0]);
    int _month = int.parse(d[1]);
    int _year = int.parse(d[2]);
    DateTime date = DateTime(_year, _month, _day, now.hour, now.minute,
        now.second, now.millisecond, now.microsecond);
    if (date.isAtSameMomentAs(now)) {
      return true;
    } else {
      return false;
    }
  }

  bool isUpcomming(Todo todo) {
    DateTime now = DateTime.now();
    var d = todo.date.split('/');
    int _day = int.parse(d[0]);
    int _month = int.parse(d[1]);
    int _year = int.parse(d[2]);
    DateTime date = DateTime(_year, _month, _day, now.hour, now.minute,
        now.second, now.millisecond, now.microsecond);
    if (date.isAfter(now)) {
      return true;
    } else {
      return false;
    }
  }
}
