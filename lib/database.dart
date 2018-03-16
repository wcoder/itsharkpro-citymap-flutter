import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile_citymap_flutter/model/City.dart';


class CityDatabase {
    static final CityDatabase _cityDatabase = new CityDatabase._internal();

    final String tableName = "Cities";

    Database db;

    static CityDatabase get() {
        return _cityDatabase;
    }

    CityDatabase._internal();


    Future init() async {
        // Get a location using path_provider
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String path = join(documentsDirectory.path, "cities.db");
        db = await openDatabase(path, version: 1,
            onCreate: (Database db, int version) async {
                // When creating the db, create the table
                await db.execute(
                    "CREATE TABLE $tableName ("
                        "${City.db_id} STRING PRIMARY KEY,"
                        "${City.db_title} TEXT,"
                        "${City.db_description} TEXT,"
                        "${City.db_latitude} TEXT,"
                        "${City.db_longitude} TEXT"
                        "${City.db_url} TEXT"
                        ")");
            });


    }

    /// Get a city by its id, if there is not entry for that ID, returns null.
    Future<City> getCity(String id) async{
        var result = await db.rawQuery('SELECT * FROM $tableName WHERE ${City.db_id} = "$id"');
        if(result.length == 0)return null;
        return new City.fromMap(result[0]);
    }


    /// Inserts or replaces the city.
    Future updateCity(City city) async {
        await db.inTransaction(() async {
            await db.rawInsert(
                'INSERT OR REPLACE INTO '
                    '$tableName(${City.db_id}, ${City.db_title}, ${City.db_description}, ${City.db_latitude}, ${City.db_longitude}, ${City.db_url})'
                    ' VALUES("${city.id}", "${city.title}", "${city.description}", ${city.latitude}, "${city.longitude}", "${city.url}")');
        });
    }

    Future close() async {
        return db.close();
    }

}