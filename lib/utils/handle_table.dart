import 'package:flutter/material.dart';
import 'package:projectx/main.dart';
import 'package:projectx/sqflite/create_database.dart';
import 'package:projectx/sqflite/handler.dart';
import 'package:projectx/values/app_colors.dart';
import 'package:projectx/views/dashboard.dart';
import 'package:projectx/views/iou.dart';
import 'package:projectx/views/uome.dart';

class HandleTable {
  // retrieves the different contents of the tables
  checkTable(String table) async {
    final db = await openMyDatabase();

    try {
      var checkExist = await db.rawQuery("SELECT * FROM $table");
      // table exist
      if (checkExist.isNotEmpty) {
        int count = checkExist.length;
        table == 'IOU'
            ? Iou.rows = await db.query('IOU')
            : Uome.rows = await db.query('UOMe');
        table == 'IOU'
            ? Iou.count = checkExist.length
            : Uome.count = checkExist.length;
        table == 'IOU' ? Iou.tableExists = true : Uome.tableExists = true;
        if (table == 'IOU') {
          Dashboard.iouHasData = true;
          Dashboard.debtRows = Iou.rows;
          Dashboard.debt = 0;

          for (var i = 0; i < count; i++) {
            Dashboard.debt += double.parse(
                Dashboard.debtRows[i]['amount'].toString()); // calc total debt
          }
        } else {
          Dashboard.uomeHasData = true;
          Dashboard.creditRows = Uome.rows;
          Dashboard.credit = 0;
          for (var i = 0; i < count; i++) {
            Dashboard.credit += double.parse(Dashboard.creditRows[i]['amount']
                .toString()); // calc total debt
          }
        }
        Dashboard.netBalance = Dashboard.credit - Dashboard.debt;
      } else {
        //Table isn't existent
        table == 'IOU' ? Iou.tableExists = false : Uome.tableExists = false;
      }
    } catch (e) {
      // 
    }
  }

  // returns the list container
  Widget getListContainer(String table) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(color: AppColors.blackText, fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Text('Remaining', style: TextStyle(color: Colors.grey),)
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(
                '${MainApp.selectedAppCurrency} ${table == 'IOU' ? Dashboard.debt.toStringAsFixed(2) : Dashboard.credit.toStringAsFixed(2)}',
                style: TextStyle(color: AppColors.blackText, fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const Text(
                '0.00',
                style: TextStyle(color: Colors.red),
              )
            ])
          ]),
          Expanded(child: getList(table))
        ]));
  }

  // returns a list matching the corresponding tables
  Widget getList(String table) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        return Container(
          //height: 100.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppColors.divider,
              border: Border.all(color: AppColors.divider)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(360.0),
                            color: Colors.green,
                          )),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(table == 'IOU'
                              ? Iou.rows[index]['name'].toString()
                              : Uome.rows[index]['name'].toString(), style: TextStyle(color: AppColors.blackText),),
                          Text(
                            table == 'IOU'
                                ? Iou.rows[index]['description'].toString()
                                : Uome.rows[index]['description'].toString(),
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text('No deadline', style: TextStyle(color: AppColors.blackText),)
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                insetPadding: const EdgeInsets.all(0),
                                contentPadding: const EdgeInsets.all(0),
                                actionsPadding: const EdgeInsets.only(
                                    right: 20, bottom: 0, top: 0),
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.transparent,
                                title: const Text(
                                  'Are you sure?',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('CANCEL',
                                          style: TextStyle(
                                              color: Colors.black,
                                              letterSpacing: 2))),
                                  TextButton(
                                      onPressed: () async {
                                        delete(
                                            table,
                                            table == 'IOU'
                                                ? Iou.rows[index]['_id']
                                                    .toString()
                                                : Uome.rows[index]['_id']
                                                    .toString());
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('REMOVE',
                                          style: TextStyle(
                                              color: Colors.red,
                                              letterSpacing: 2)))
                                ]);
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red,
                        size: 22.0,
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          '${MainApp.selectedAppCurrency} ${table == 'IOU' ? Iou.rows[index]['amount'] : Uome.rows[index]['amount']}',
                          style: TextStyle(color: AppColors.blackText, fontSize: 17, fontWeight: FontWeight.bold)),
                      Text('${MainApp.selectedAppCurrency} 0.00',
                          style: const TextStyle(color: Colors.red))
                    ],
                  )
                ],
              )
            ],
          ),
        );
      }),
      itemCount: table == 'IOU' ? Iou.count : Uome.count,
    );
  }
}
