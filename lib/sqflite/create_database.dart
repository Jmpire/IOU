import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openMyDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'iou.db');
  final database = await openDatabase(
    path,
    version: 1,
    onOpen: (db) {
    },
  );
  return database;
}