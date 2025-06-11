import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Colour {
  final String hexcode;
  final String? ral;
  final String? name;
  final int r;
  final int g;
  final int b;
  Colour(this.hexcode, this.r, this.g, this.b, [this.ral, this.name]);
  Color getColor() => Color.fromARGB(255, r, g, b);
}

class ColourDb {
  String schemaName;
  Database? db;

  ColourDb(this.schemaName);

  Future create() async {
    if (db == null || !db!.isOpen) {
      var dbPath = await getDatabasesPath();
      db = await openDatabase("$dbPath/Colours.db");
      await db?.execute(
          'create table if not exists ColourCollections (Collection char)');
    }

    if (schemaName != '') {
      await db?.execute(
          'create table if not exists "$schemaName" (hexcode int primary key, r int, g, int, b int)');

      Future<List>? condition = db?.query(
        'ColourCollections',
        columns: ['Collection'],
        where: 'Collection = "$schemaName"',
      );

      condition?.then((cond) {
        if (cond.isEmpty) {
          db?.execute('insert into ColourCollections values("$schemaName")');
        }
      });
    }
  }

  void changeSchema(String schemaName) {
    this.schemaName = schemaName;
  }

  Future? renameSchema(String newName) async {
    Future? done;
    db?.execute('alter table "$schemaName" rename to "$newName"');
    done = db?.execute(
        'update ColourCollections set Collection="$newName" where Collection="$schemaName"');
    done?.then((val) {
      schemaName = newName;
    });

    return done;
  }

  void add(Colour col) async {
    await db?.rawInsert(
        'insert into "$schemaName" (hexcode, r, g, b) values("${col.hexcode}", ${col.r}, ${col.g}, ${col.b})');
  }

  Future remove(Colour col) {
    return db!
        .execute('delete from "$schemaName" where hexcode="${col.hexcode}"');
  }

  Future removeList(List colours) {
    return db!.execute(
        'delete from "$schemaName" where hexcode in ${colours.map((col) => '"$col"')}');
  }

  Future<List<Map>> listColours() async {
    var colourList = await db!.query(
      '"$schemaName"',
      columns: ['hexcode', 'r', 'g', 'b'],
    );

    return colourList;
  }

  Future<List<Map>> listTables() async {
    var tableList = await db!.query(
      'ColourCollections',
      columns: ['Collection'],
    );

    return tableList;
  }

  Future export() async {
    final exportFile =
        File('/storage/emulated/0/Documents/Colours/Export/$schemaName.csv');

    if (!exportFile.existsSync()) {
      exportFile.createSync(recursive: true);
    }

    final exportStream = exportFile.openWrite();

    var colourList = await db!.query(
      '"$schemaName"',
      columns: ['hexcode', 'r', 'g', 'b'],
    );

    exportStream.writeln('Hexcode,R,G,B');
    for (var colour in colourList) {
      var line =
          '"${colour["hexcode"]}",${colour["r"]},${colour["g"]},${colour["b"]}';
      exportStream.writeln(line);
    }
    exportStream.close();
  }

  Future import() async {
    final importFile =
        File('/storage/emulated/0/Documents/Colours/Import/$schemaName.csv');

    bool filePresent = importFile.existsSync();
    if (!filePresent) return filePresent;

    List<List<String>> importList =
        importFile.readAsLinesSync().map((line) => line.split(',')).toList();

    importList.removeAt(0);

    for (var record in importList) {
      await db?.execute(
          'insert into "$schemaName" (hexcode, r, g, b) values(${record[0]}, ${record[1]}, ${record[2]}, ${record[3]})');
    }
  }

  Future? deleteSchema(String name) {
    db?.execute('drop table "$name"');
    return db
        ?.execute('delete from ColourCollections where Collection="$name"');
  }
}
