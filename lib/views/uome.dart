import 'package:flutter/material.dart';
import 'package:projectx/utils/handle_table.dart';
import 'package:projectx/values/app_colors.dart';
import 'package:projectx/views/home_screen.dart';

class Uome extends StatefulWidget {
  static bool tableExists = false;
  static int count = 0;
  static late List<Map<String, Object?>> rows;
  const Uome({super.key});

  @override
  State<Uome> createState() => _OumeState();
}

class _OumeState extends State<Uome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: getFloatingButton(0),
        backgroundColor: AppColors.appBackgroundColor,
        body: Center(
            child: Uome.tableExists == false
                ? getAnimationSection('People that owe you')
                : HandleTable().getListContainer('UOMe')));
  }
}
