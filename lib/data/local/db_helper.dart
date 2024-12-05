import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{

  //singleton
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  //table note
  static const String TABLE_NOTE = "note";
  static const String COLUMN_NOTE_SNO = "s_no";
  static const String COLUMN_NOTE_TITLE = "title";
  static const String COLUMN_NOTE_DESC = "desc";

  Database? myDB;

  // db Open(if path exists then open db otherwise create db)
  Future<Database> getDB() async{

    myDB = myDB ?? await openDB();
    return myDB!;
  }

  Future<Database> openDB() async{

    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "noteDB.db");
    return await openDatabase(dbPath,onCreate: (db,version){
      //create all your tables here
      db.execute("create table $TABLE_NOTE("
          "$COLUMN_NOTE_SNO integer primary key autoincrement , $COLUMN_NOTE_TITLE text , $COLUMN_NOTE_DESC text)");
    },version: 1);
  }

  //all queries
  //insert
  Future<bool> addNote({required String title, required String desc})async{
    var db = await getDB();
    int rowsAffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: title,
      COLUMN_NOTE_DESC: desc
    });
    return rowsAffected>0;
  }

  Future<List<Map<String,dynamic>>> getAllNotes() async{
    var db = await getDB();
    List<Map<String,dynamic>> data = await db.query(TABLE_NOTE);
    return data;
  }

}