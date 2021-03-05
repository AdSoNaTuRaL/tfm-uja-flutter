import 'NotesModel.dart';
import 'package:sqflite/sqflite.dart';

abstract class NotesDBWorker {
  static final NotesDBWorker db = _SqfliteNotesDBWorker._();

  Future<int> create(Note note);
  Future<void> update(Note note);
  Future<void> delete(int id);
  Future<Note> get(int id);
  Future<List<Note>> getAll();
}

class _SqfliteNotesDBWorker implements NotesDBWorker {

  static const String DB_NAME = 'notes.db';
  static const String TBL_NAME = 'notes';
  static const String KEY_ID = '_id';
  static const String KEY_TITLE = 'title';
  static const String KEY_CONTENT = 'content';
  static const String KEY_COLOR = 'color';

  Database _db;

  _SqfliteNotesDBWorker._();

  Future<Database> get database async => _db ??= await _init();

  @override
  Future<int> create(Note note) async {
    Database db = await database;
    int id = await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_TITLE, $KEY_CONTENT, $KEY_COLOR) "
        "VALUES (?, ?, ?)",
        [note.title, note.content, note.color]);
    return id;
  }

  @override
  Future<void> update(Note note) async {
    Database db = await database;
    await db.update(TBL_NAME, _noteToMap(note),
        where: "$KEY_ID = ?", whereArgs: [note.id]);
  }

  @override
  Future<void> delete(int id) async {
    Database db = await database;
    return await db.delete("notes", where: "$KEY_ID = ?", whereArgs: [id]);
  }

  @override
  Future<Note> get(int id) async {
    Database db = await database;
    var values = await db.query("notes", where: "$KEY_ID = ?", whereArgs: [id]);
    return values.isEmpty ? null : _noteFromMap(values.first);
  }

  @override
  Future<List<Note>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _noteFromMap(m)).toList() : [];
  }

  Future<Database> _init() async {
    return await openDatabase(DB_NAME, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE IF NOT EXISTS $TBL_NAME ("
          "$KEY_ID INTEGER PRIMARY KEY,"
          "$KEY_TITLE TEXT,"
          "$KEY_CONTENT TEXT,"
          "$KEY_COLOR TEXT"
          ")");
    });
  }

  Map<String, dynamic> _noteToMap(Note note) {
    return Map<String, dynamic>()
      ..[KEY_ID] = note.id
      ..[KEY_TITLE] = note.title
      ..[KEY_CONTENT] = note.content
      ..[KEY_COLOR] = note.color;
  }

  Note _noteFromMap(Map map) {
    return Note()
      ..id = map[KEY_ID]
      ..title = map[KEY_TITLE]
      ..content = map[KEY_CONTENT]
      ..color = map[KEY_COLOR];
  }
}
