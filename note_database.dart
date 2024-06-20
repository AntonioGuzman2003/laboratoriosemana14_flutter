import 'package:flutter_application_1/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EquipoFutbolDatabase {
  static final EquipoFutbolDatabase instance = EquipoFutbolDatabase._internal();

  static Database? _database;

  EquipoFutbolDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'equipos_futbol.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    return await db.execute('''
        CREATE TABLE ${EquipoFutbolFields.tableName} (
          ${EquipoFutbolFields.id} ${EquipoFutbolFields.idType},
          ${EquipoFutbolFields.name} ${EquipoFutbolFields.textType},
          ${EquipoFutbolFields.year} ${EquipoFutbolFields.intType},
          ${EquipoFutbolFields.dateTime} ${EquipoFutbolFields.textType}
        )
      ''');
  }

  Future<EquipoFutbolModel> create(EquipoFutbolModel equipo) async {
    final db = await instance.database;
    final id = await db.insert(EquipoFutbolFields.tableName, equipo.toJson());
    return equipo.copy(id: id);
  }

  Future<EquipoFutbolModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      EquipoFutbolFields.tableName,
      columns: EquipoFutbolFields.values,
      where: '${EquipoFutbolFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return EquipoFutbolModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<EquipoFutbolModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${EquipoFutbolFields.dateTime} DESC';
    final result = await db.query(EquipoFutbolFields.tableName, orderBy: orderBy);
    return result.map((json) => EquipoFutbolModel.fromJson(json)).toList();
  }

  Future<int> update(EquipoFutbolModel equipo) async {
    final db = await instance.database;
    return db.update(
      EquipoFutbolFields.tableName,
      equipo.toJson(),
      where: '${EquipoFutbolFields.id} = ?',
      whereArgs: [equipo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      EquipoFutbolFields.tableName,
      where: '${EquipoFutbolFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
