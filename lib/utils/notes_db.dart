import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';
import 'notes_db_var.dart';

/*
import 'dart:async';
import 'package:path_provider/path_provider.dart';
 */
class NotesDb {
  static NotesDb _notesDb;
  static Database _database;

  NotesDb._createInstance();

  factory NotesDb() {
    if (_notesDb == null) _notesDb = NotesDb._createInstance();
    return _notesDb;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE ${NotesDbVar.table}('
        '${NotesDbVar.id} INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${NotesDbVar.title} TEXT, '
        '${NotesDbVar.description} TEXT, '
        '${NotesDbVar.priority} TEXT, '
        '${NotesDbVar.date} TEXT)');
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, NotesDbVar.db);
    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<Database> get database async {
    if (_database == null) _database = await initializeDatabase();
    return _database;
  }

  Future<List<Map<String, dynamic>>> getNotesMap() async {
    Database db = await this.database;
    return await db.query(NotesDbVar.table,
        orderBy: '${NotesDbVar.priority} ASC');
  }

  Future<int> insert(Note note) async {
    Database db = await this.database;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    return await db.insert(NotesDbVar.table, note.toMap());
  }

  Future<int> update(Note note) async {
    Database db = await this.database;
    return await db.update(NotesDbVar.table, note.toMap(),
        where: '${NotesDbVar.id} = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    Database db = await this.database;
    return await db.delete(NotesDbVar.table,
        where: '${NotesDbVar.id} = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    Database db = await this.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT (*) from ${NotesDbVar.table}'));
  }

  Future<List<Note>> getNotes() async {
    var notes = await getNotesMap();
    return notes.map((n) => Note.fromMapObject(n)).toList();
  }
}
