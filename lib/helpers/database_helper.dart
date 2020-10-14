import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../modals/note_modal.dart';

class DatabaseHelper {

	static DatabaseHelper _databaseHelper;
	static Database _database;

	String tableNoteKeeper = 'notekeeper';
	String colId = 'id';
	String colTitle = 'title';
	String colDescription = 'description';
	String colDate = 'date';

	DatabaseHelper._createInstance();

	factory DatabaseHelper() {
		if (_databaseHelper == null) {
			_databaseHelper = DatabaseHelper._createInstance();
		}
		return _databaseHelper;
	}

	Future<Database> get database async {
		if (_database == null)
			_database = await initializeDatabase();
		return _database;
	}

	Future<Database> initializeDatabase() async {
		Directory directory = await getApplicationDocumentsDirectory();
		String path = directory.path + 'notekeeper.db';

		var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
		return notesDatabase;
	}

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
		Database db = await this.database;
		var result = await db.rawQuery('SELECT * FROM $tableNoteKeeper');
		return result;
	}

  Future<int> getCount() async {
		Database db = await this.database;
		List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $tableNoteKeeper');
		int result = Sqflite.firstIntValue(x);
		return result;
	}

	Future<List<Note>> getNoteList() async {
		var noteMapList = await getNoteMapList();
		int count = noteMapList.length;

		List<Note> noteList = List<Note>();
		for (int i = 0; i < count; i++)
			noteList.add(Note.fromMapObject(noteMapList[i]));
		return noteList;
	}

	void _createDb(Database db, int newVersion) async {
		await db.execute('CREATE TABLE $tableNoteKeeper($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
				'$colDescription TEXT, $colDate TEXT)');
	}

	Future<int> insertNote(Note note) async {
    if(note.description == '' || note.description == null) note.description = 'No description is provided';
		Database db = await this.database;
		var result = await db.insert(tableNoteKeeper, note.toMap());
		return result;
	}

	Future<int> updateNote(Note note) async {
		var db = await this.database;
		var result = await db.update(tableNoteKeeper, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
		return result;
	}

	Future<int> deleteNote(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $tableNoteKeeper WHERE $colId = $id');
		return result;
	}
}