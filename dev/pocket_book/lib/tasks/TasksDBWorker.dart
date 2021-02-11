import 'package:sqflite/sqflite.dart';
import 'TasksModel.dart';

class TasksDBWorker {

  static final TasksDBWorker db = TasksDBWorker._();

  static const String DB_NAME = 'tasks.db';
  static const String TBL_NAME = 'tasks';
  static const String KEY_ID = 'id';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_DUE_DATE = 'dueDate';
  static const String KEY_COMPLETED = 'completed';

  Database _db;

  TasksDBWorker._();

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_DESCRIPTION TEXT,"
                  "$KEY_DUE_DATE TEXT,"
                  "$KEY_COMPLETED INTEGER"
              ")"
          );
        }
    );
  }

  Future<int> create(Task task) async {
    Database db = await database;
    return await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_DESCRIPTION, $KEY_DUE_DATE, $KEY_COMPLETED) "
            "VALUES (?, ?, ?)",
      [task.description, task.dueDate, task.completed ? 1 : 0]
    );
  }

  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  Future<Task> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return values.isEmpty ? null : _taskFromMap(values.first);
  }

  Future<List<Task>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _taskFromMap(m)).toList() : [];
  }

  Future<void> update(Task task) async {
    Database db = await database;
    await db.update(TBL_NAME, _taskToMap(task),
        where: "$KEY_ID = ?", whereArgs: [task.id]);
  }

  Task _taskFromMap(Map<String, dynamic> map) {
    return Task()
      ..id = map[KEY_ID]
      ..description = map[KEY_DESCRIPTION]
      ..dueDate = map[KEY_DUE_DATE]
      ..completed = map[KEY_COMPLETED] != 0;
  }

  Map<String, dynamic> _taskToMap(Task task) {
    return Map<String, dynamic>()
      ..[KEY_ID] = task.id
      ..[KEY_DESCRIPTION] = task.description
      ..[KEY_DUE_DATE] = task.dueDate
      ..[KEY_COMPLETED] = task.completed ?  1 : 0;
  }
}