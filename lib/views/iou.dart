import 'package:flutter/material.dart';
import 'package:projectx/utils/handle_table.dart';
import 'package:projectx/values/app_colors.dart';

import '../main.dart';
class Iou extends StatefulWidget {
  static bool tableExists = false;
  static int count = 0;
  static late List<Map<String, Object?>> rows;
  const Iou({super.key});

  @override
  State<Iou> createState() => _IouState();
}

class _IouState extends State<Iou> {
  

  // sets the state
  void setStateAndRefresh() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: getFloatingButton(1),
        backgroundColor: AppColors.appBackgroundColor,
        body: Center(
            child: Iou.tableExists == false
                ? getAnimationSection('People that you owe')
                : HandleTable().getListContainer('IOU')));
  }

  
}
