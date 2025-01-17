import 'dart:convert';

import 'package:news/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

final newsDbProvider = NewsDbProvider();

class NewsDbProvider implements Source, Cache {
  late Database db;

  NewsDbProvider() {
    init();
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");
    db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database newDb, int version) {
          newDb.execute("""
           CREATE TABLE Items
           (
             id INTEGER PRIMARY KEY,
             type TEXT,
             by TEXT,
             time INTEGER,
             text TEXT,
             parent INTEGER,
             kids BLOB,
             dead INTEGER,
             deleted INTEGER,
             url TEXT,
             score INTEGER,
             title TEXT,
             descendants INTEGER
           )
           """
          );
        },
        onUpgrade: (Database db, int oldVersion, int newVersion) async {
          if (oldVersion < 2) {
            // Perform migration logic (e.g., add columns)
            await db.execute('ALTER TABLE Items ADD COLUMN parent INTEGER');
          }
        },
    );
  }

   @override
  Future<ItemModel?> fetchItem(int id) async {
     final maps = await db.query(
       "Items",
       columns: null,
       where: "id = ?",
       whereArgs: [id],
     );
     if (maps.isNotEmpty) {
       return ItemModel.fromDb(maps.first);
     }
     return null;
  }

  @override
  Future<int> addItem(ItemModel item) {
    return db.insert(
        "Items",
        item.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.ignore
    );
  }

  @override
  Future<List<int>> fetchTopIds() {
    return Future.value([1, 2]);
  }

  @override
  Future<int> clear() {
    return db.delete("Items");
  }
}