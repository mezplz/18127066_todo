// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/todo/widgets/todo_tile.dart';
import '../models/todo.dart';

class TodoListScreen extends StatefulWidget {
  final List<Todo> todo;
  final String search;
  final int type;
  const TodoListScreen(
      {Key? key, required this.todo, required this.search, required this.type})
      : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: widget.todo.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: ((context, index) {
            final item = widget.todo[index];
            return Dismissible(
              key: Key(item.id.toString()),
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  widget.todo.removeAt(index);
                });
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Todo removed')));
              },
              background: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    'Remove',
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                ),
              ),
              child: InkWell(
                  onTap: () => setState(() {
                        widget.todo[index].status = !widget.todo[index].status;
                      }),
                  child: widget.type == 0
                      ? isSearch(widget.todo[index].title, widget.search)
                          ? TodoTile(todo: widget.todo[index])
                          : SizedBox.shrink()
                      : widget.type == 1
                          ? isToday(widget.todo[index])
                              ? isSearch(
                                      widget.todo[index].title, widget.search)
                                  ? TodoTile(todo: widget.todo[index])
                                  : SizedBox.shrink()
                              : SizedBox.shrink()
                          : isUpcomming(widget.todo[index])
                              ? isSearch(
                                      widget.todo[index].title, widget.search)
                                  ? TodoTile(todo: widget.todo[index])
                                  : SizedBox.shrink()
                              : SizedBox.shrink()),
            );
          }),
        ));
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
