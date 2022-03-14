// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo/config/pallete.dart';

import '../models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  const TodoTile({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w,),
        child: Row(
          children: [
            todo.status
                ? Image.asset(
                    'assets/images/check.png',
                    width: 20.w,
                    height: 20.w,
                  )
                : Image.asset('assets/images/uncheck.png',
                    width: 20.w, height: 20.w),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.w,),
                  Text(
                    todo.title,
                    style: TextStyle(color: Colors.black, fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Palette.grey, size: 12.w,),
                      SizedBox(width: 10.w,),
                      Text(
                        todo.date + ' ' + todo.time,
                        style: TextStyle(color: Palette.grey, fontSize: 12.sp),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.w,
                  ),
                  Divider(
                    thickness: 0.5.w,
                    height: 0.w,
                    color: Palette.div,
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
