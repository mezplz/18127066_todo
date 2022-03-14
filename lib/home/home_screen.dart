import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/todo/screens/add_todo_screen.dart';
import 'package:todo/todo/screens/todo_list_screen.dart';

import '../config/pallete.dart';
import '../todo/models/todo.dart';
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
  // late SharedPreferences prefs;
  // setupTodo() async {
  //   prefs = await SharedPreferences.getInstance();
  //   String? stringTodo = prefs.getString('todo');
  //   List todoList = jsonDecode(stringTodo!);
  //   for (var todo in todoList) {
  //     setState(() {
  //       todo.add(Todo(id: 0, title: '', date: '', time: '', status: false)
  //           .fromJson(todo));
  //     });
  //   }
  // }

  //  void saveTodo() {
  //   List items = todo.map((e) => e.toJson()).toList();
  //   prefs.setString('todo', jsonEncode(items));
  // }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    _controller.addListener(_handleTabSelection);
    // setupTodo();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Todo',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600)),
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
            TodoListScreen(
              todo: todo,
              search: search,
              type: 0,
            ),
            TodoListScreen(
              todo: todo,
              search: search,
              type: 1,
            ),
            TodoListScreen(
              todo: todo,
              search: search,
              type: 2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.theme,
        onPressed: () {
          addTodo();
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
    Todo returnTodo = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddTodoScreen(todo: t)));
    if (returnTodo != null) {
      setState(() {
        todo.add(returnTodo);
      });
      // saveTodo();
    }
  }
}
