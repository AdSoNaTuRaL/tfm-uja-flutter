import 'package:sqflite/sqflite.dart';
import 'AppointmentsModel.dart';

class AppointmentsDBWorker {

  static final AppointmentsDBWorker db = AppointmentsDBWorker._();

  static const String DB_NAME = 'appointments.db';
  static const String TBL_NAME = 'appointments';
  static const String KEY_ID = 'id';
  static const String KEY_TITLE = 'title';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_DATE = 'date';
  static const String KEY_TIME = 'time';

  Database _db;

  AppointmentsDBWorker._();

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    return await openDatabase(DB_NAME,
        version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS $TBL_NAME ("
                  "$KEY_ID INTEGER PRIMARY KEY,"
                  "$KEY_TITLE TEXT,"
                  "$KEY_DESCRIPTION TEXT,"
                  "$KEY_DATE TEXT,"
                  "$KEY_TIME TEXT"
              ")"
          );
        }
    );
  }

  Future<int> create(Appointment app) async {
    Database db = await database;
    return await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_TITLE, $KEY_DESCRIPTION, $KEY_DATE, $KEY_TIME) "
            "VALUES (?, ?, ?, ?)",
      [app.title, app.description, app.date, app.time]
    );
  }

  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  Future<Appointment> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return values.isEmpty ? null : _appFromMap(values.first);
  }

  Future<List<Appointment>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _appFromMap(m)).toList() : [];
  }

  Future<void> update(Appointment app) async {
    Database db = await database;
    await db.update(TBL_NAME, _appToMap(app),
        where: "$KEY_ID = ?", whereArgs: [ app.id ]);
  }

  Appointment _appFromMap(Map<String, dynamic> map) {
    return Appointment()
      ..id = map[KEY_ID]
      ..title = map[KEY_TITLE]
      ..description = map[KEY_DESCRIPTION]
      ..date = map[KEY_DATE]
      ..time = map[KEY_TIME];
  }

  Map<String, dynamic> _appToMap(Appointment app) {
    return Map<String, dynamic>()
      ..[KEY_ID] = app.id
      ..[KEY_TITLE] = app.title
      ..[KEY_DESCRIPTION] = app.description
      ..[KEY_DATE] = app.date
      ..[KEY_TIME] = app.time;
  }
}