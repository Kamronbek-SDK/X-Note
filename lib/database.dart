import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

import 'class.dart';

class Database {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(
        """
      CREATE TABLE note(
         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
         title TEXT NOT NULL,
         desc TEXT NOT NULL,
         time TEXT NOT NULL,
         color_id INTEGER NOT NULL
      )
      """
    );
  }
  static Future<sql.Database> db() async {
    return sql.openDatabase(
        "note.db",
        version: 1,
        onCreate: (database, version) async {
          return createTable(database);
        }
    );
  }
  static Future<void> saveNote(Note note) async {
    final database = await db();
    await database.insert('note', note.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
  }
  static Future<List<Note>> allNotes() async {
    final database = await db();
    final List<Note> notes = [];
    final maps = await database.query("note", orderBy: "id");
    for(var s in maps) {
      notes.add(Note.fromJson(s));
    }
    return notes;
  }
  static Future<void> delete(int? id)async {
    final database = await db();
    await database.delete('note',where: "id = ?", whereArgs: [id]);
  }
}