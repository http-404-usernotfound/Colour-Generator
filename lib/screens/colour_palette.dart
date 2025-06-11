import 'dart:io';
import 'package:flutter/material.dart';
import 'package:colour_generator/screens/colour.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

Future<List<Colour>> getRal(Colour col, Database db) async {
  List smallrgb = [];
  List bigrgb = [];
  Colour col1, col2;

  List<List<int>> rgbList = [];

  await db.rawQuery('select r, g, b from rals').then((list) {
    rgbList = list
        .map((rgbMap) =>
            [rgbMap['r'] as int, rgbMap['g'] as int, rgbMap['b'] as int])
        .toList();
  });

  int minDiff = 255 + 255 + 255;
  int diff;
  for (var rgb in rgbList) {
    diff = (rgb[0] - col.r).abs() +
        (rgb[1] - col.g).abs() +
        (rgb[2] - col.b).abs();

    if (diff <= minDiff) {
      bigrgb = smallrgb;
      smallrgb = rgb;
      minDiff = diff;
    }
  }

  col1 = await db
      .rawQuery(
          'select hexcode, ralcode, name from rals where r=${smallrgb[0]} and g=${smallrgb[1]} and b=${smallrgb[2]}')
      .then((colMap) {
    return Colour(
        colMap[0]['hexcode'] as String,
        smallrgb[0],
        smallrgb[1],
        smallrgb[2],
        colMap[0]['ralcode'] as String,
        colMap[0]['name'] as String);
  });

  col2 = await db
      .rawQuery(
          'select hexcode, ralcode, name from rals where r=${bigrgb[0]} and g=${bigrgb[1]} and b=${bigrgb[2]}')
      .then((colMap) {
    return Colour(colMap[0]['hexcode'] as String, bigrgb[0], bigrgb[1],
        bigrgb[2], colMap[0]['ralcode'] as String, colMap[0]['name'] as String);
  });
  return [col1, col2];
}

class ColourDetails extends StatefulWidget {
  @override
  State<ColourDetails> createState() => _ColourDetailsState();
}

class _ColourDetailsState extends State<ColourDetails> {
  Colour? altColour1, altColour2;
  Database? ralDb;
  bool ralObtained = false;

  @override
  void initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((docDir) {
      String dbPath = join(docDir.path, 'ral.db');
      if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
        rootBundle.load(join('databases', 'HexToRal.sqlite')).then((data) {
          List<int> bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
          File(dbPath).createSync(recursive: true);
          File(dbPath).writeAsBytesSync(bytes);
          openDatabase(dbPath).then((db) {
            setState(() {
              ralDb = db;
            });
          });
        });
      } else {
        openDatabase(dbPath).then((db) {
          setState(() {
            ralDb = db;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ralDb == null) {
      return Container();
    }

    final Colour colour = ModalRoute.of(context)!.settings.arguments as Colour;

    getRal(colour, ralDb!).then((list) {
      altColour1 = list[0];
      setState(() {
        altColour2 = list[1];
        ralObtained = true;
      });
    });

    if (ralObtained) {
      return Scaffold(
        backgroundColor: Color(0xFF282a2b),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Container(
                // Colour Background.
                margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                decoration: BoxDecoration(
                  color: colour.getColor(),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30), bottom: Radius.circular(20)),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 10, 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30), top: Radius.circular(20)),
                  color: Color(0xFF57595a),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Center(
                              child: Column(
                                children: [
                                  Text('Alternative 1:',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13)),
                                  Text(
                                      '${altColour1!.ral} | ${altColour1!.name}\n',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11)),
                                  Text(
                                      '${altColour1!.hexcode}      ${altColour1!.r}, ${altColour1!.g}, ${altColour1!.b}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 11)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              // Colour Background.
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              decoration: BoxDecoration(
                                color: altColour1!.getColor(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Center(
                              child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text('Alternative 2:',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13)),
                                Text(
                                    '${altColour2!.ral} | ${altColour2!.name}\n',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11)),
                                Text(
                                    '${altColour2!.hexcode}      ${altColour2!.r}, ${altColour2!.g}, ${altColour2!.b}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 11)),
                              ],
                            ),
                          )),
                          Expanded(
                            child: Container(
                              // Colour Background.
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              decoration: BoxDecoration(
                                color: altColour2!.getColor(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
