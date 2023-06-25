import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute("""CREATE TABLE "item" (
	"id"	INTEGER NOT NULL UNIQUE,
	"title"	TEXT,
	"name"	TEXT,
  "aadhar"	TEXT,
	"address"	TEXT,
  PRIMARY KEY("id")
);
 """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(join(await sql.getDatabasesPath(), 'item.db'),
        version: 1, onCreate: (sql.Database database, int version) async {
      await createTable(database);
    });
  }

  static Future<int> createItem(
      String title, String? name, String? aadhar, String? address) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'name': name,
      'aadhar': aadhar,
      'address': address,
    };
    final id = await db.insert('item', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('item', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('item', where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(int id, String title, String? name,
      String? aadhar, String? address) async {
    final db = await SQLHelper.db();
    final data = {
      'title': title,
      'name': name,
      'aadhar': aadhar,
      'address': address
    };
    final result = db.update('item', data, where: 'id=?', whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("item", where: "id=?", whereArgs: [id]);
    } catch (e) {
      print("Someting went W while deleting:$e");
    }
  }
}
