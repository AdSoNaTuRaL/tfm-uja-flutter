import 'package:sqflite/sqflite.dart';
import 'LinksModel.dart';

class LinksDBWorker {

  static final LinksDBWorker db = LinksDBWorker._();

  static const String DB_NAME = 'links.db';
  static const String TBL_NAME = 'links';
  static const String KEY_ID = 'id';
  static const String KEY_DESCRIPTION = 'description';
  static const String KEY_ACT_LINK = 'actLink';

  Database _db;

  LinksDBWorker._();

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
                  "$KEY_ACT_LINK TEXT"
                  ")"
          );
        }
    );
  }

  Future<int> create(Link link) async {
    Database db = await database;
    return await db.rawInsert(
        "INSERT INTO $TBL_NAME ($KEY_DESCRIPTION, $KEY_ACT_LINK) "
            "VALUES (?, ?, ?)",
        [link.description, link.actLink]
    );
  }

  Future<void> delete(int id) async {
    Database db = await database;
    await db.delete(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
  }

  Future<Link> get(int id) async {
    Database db = await database;
    var values = await db.query(TBL_NAME, where: "$KEY_ID = ?", whereArgs: [id]);
    return values.isEmpty ? null : _linkFromMap(values.first);
  }

  Future<List<Link>> getAll() async {
    Database db = await database;
    var values = await db.query(TBL_NAME);
    return values.isNotEmpty ? values.map((m) => _linkFromMap(m)).toList() : [];
  }

  Future<void> update(Link link) async {
    Database db = await database;
    await db.update(TBL_NAME, _linkToMap(link),
        where: "$KEY_ID = ?", whereArgs: [link.id]);
  }

  Link _linkFromMap(Map<String, dynamic> map) {
    return Link()
      ..id = map[KEY_ID]
      ..description = map[KEY_DESCRIPTION]
      ..actLink = map[KEY_ACT_LINK];
  }

  Map<String, dynamic> _linkToMap(Link link) {
    return Map<String, dynamic>()
      ..[KEY_ID] = link.id
      ..[KEY_DESCRIPTION] = link.description
      ..[KEY_ACT_LINK] = link.actLink;
  }
}