// ignore_for_file: prefer_const_constructors, unnecessary_this, no_logic_in_create_state, unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/config/pallete.dart';

import '../models/todo.dart';

class AddTodoScreen extends StatefulWidget {
  final Todo todo;
  const AddTodoScreen({Key? key, required this.todo}) : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState(todo: this.todo);
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  Todo todo;
  _AddTodoScreenState({required this.todo});
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (todo != null) {
      titleController.text = todo.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 50.w, left: 20.w, right: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(onTap: () => Get.back(), child: Icon(Icons.arrow_back)),
          SizedBox(
            height: 20.w,
          ),
          Text(
            'Add a todo',
            style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(
            height: 30.w,
          ),
          Text(
            'Title',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          TextFormField(
            onChanged: (data) {
              todo.title = data;
            },
            controller: titleController,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w300),
            decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10.w),
                hintText: 'Title',
                hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: Palette.grey,
                    fontWeight: FontWeight.w200),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 1.w,
                        color: Palette.div))),
          ),
          SizedBox(
            height: 20.w,
          ),
          Text(
            'Datetime',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          SizedBox(
            height: 10.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
                style: TextStyle(fontSize: 15.sp),
              ),
              SizedBox(
                width: 5.w,
              ),
              InkWell(
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));

                  if (newDate == null) return;
                  setState(() => date = newDate);
                },
                child: Icon(
                  Icons.calendar_today,
                  size: 15.sp,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 15.sp),
              ),
              SizedBox(
                width: 5.w,
              ),
              InkWell(
                onTap: () async {
                  TimeOfDay? newTime = await showTimePicker(
                    context: context,
                    initialTime: time,
                  );

                  if (newTime == null) return;
                  setState(() => time = newTime);
                },
                child: Icon(
                  Icons.access_time,
                  size: 15.sp,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.w,
          ),
          SizedBox(
            height: 20.w,
          ),
          SizedBox(
            width: 335.w,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                todo.date =
                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                todo.time =
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                Navigator.pop(context, todo);
              },
              child: Text('Add'),
              style: ElevatedButton.styleFrom(
                primary: Palette.theme,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
