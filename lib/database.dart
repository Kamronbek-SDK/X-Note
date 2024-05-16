import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

import 'class.dart';

class Database {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(
      '''
      CREATE TABLE note (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT NOT NULL,
      desc TEXT NOT NULL,
      time TEXT NOT NULL,
      color_id INTEGER NOT NULL,
      )
      '''
    );
  }
  static Future<sql.Database> dataB() async {
    return sql.openDatabase('note.dataB', version: 1, onCreate: (database, version) async {
      return createTable(database);
    });
  }

  static Future<void> saveNote(Note note) async {
    final db = await dataB();
    await db.insert('note.db', note.toJson(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }
  static Future<List<Note>> allNotes() async {
    final db = await dataB();
    final List<Note> notes = [];
    final maps = await db.query('note', orderBy: 'id');
    for(var k in maps) {
      notes.add(Note.fromJson(k));
    }
    return notes;
  }
  static Future<void> delete(int id) async {
    final db = await dataB();
    await db.delete('note', where: 'id = ?', whereArgs: [id]);
  }
}