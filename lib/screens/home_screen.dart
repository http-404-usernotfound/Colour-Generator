import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:colour_generator/screens/colour.dart';
import 'package:snackbar/snackbar.dart';
import 'dart:math';

String intToHexString(int r, int g, int b) {
  var hexDigits = <String>[
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
  ];
  List<String> hexList = ["#"];

  hexList.insert(1, hexDigits[r % 16]);
  r = (r / 16).floor();
  hexList.insert(1, hexDigits[r]);

  hexList.insert(3, hexDigits[g % 16]);
  g = (g / 16).floor();
  hexList.insert(3, hexDigits[g]);

  hexList.insert(5, hexDigits[b % 16]);
  b = (b / 16).floor();
  hexList.insert(5, hexDigits[b]);

  String hexString = "";
  for (int i = 0; i < hexList.length; i++) {
    hexString += hexList[i];
  }

  return hexString;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  int red = 0;
  int green = 0;
  int blue = 0;

  String hexCode = '#000000';
  Color currColour = Colors.black;
  Color prevColour = Colors.white;

  String currentSchema = "";
  bool saved = false;

  ColourDb colourDb = ColourDb('');

  @override
  void initState() {
    super.initState();
    colourDb.create().then((tp) {
      colourDb.listTables().then((list) {
        setState(() {
          currentSchema = list[0]['Collection'];
          colourDb.changeSchema(currentSchema);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282a2b),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              // Colour Background.
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: currColour,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Current Collection:\n- $currentSchema',
                  style: TextStyle(
                      color: const Color.fromARGB(120, 255, 255, 255),
                      fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateColor.fromMap({
                      WidgetState.any: Colors.blueGrey,
                    })),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog.fullscreen(
                              backgroundColor: Color(0xFF282a2b),
                              child: CollectionList(
                                db: colourDb,
                                selectCollection: (String collection) {
                                  setState(() {
                                    currentSchema = collection;
                                    colourDb.changeSchema(currentSchema);
                                  });
                                },
                              ),
                            );
                          });
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                      child: Center(
                        child: Text(
                          'Change Collection',
                          style: TextStyle(
                            color: Color(0xFF1f3f4a),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(children: [
              Expanded(
                  child: Container(
                // Displays Hexcode and RGB values
                margin: EdgeInsets.fromLTRB(10.0, 5.0, 2.5, 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(20)),
                  color: Color(0xFF57595a),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(Icons.copy),
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: hexCode));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('Copied $hexCode!'),
                                  duration: Duration(milliseconds: 1618),
                                ));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.save),
                              onPressed: () async {
                                if (!saved) {
                                  colourDb
                                      .add(Colour(hexCode, red, green, blue));

                                  saved = true;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Saved!'),
                                          duration:
                                              Duration(milliseconds: 1618)));
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          "RGB: $red, $green, $blue\n\nHexcode: $hexCode",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.blueGrey[200],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStateColor.fromMap({
                              WidgetState.any: Colors.blueGrey,
                            })),
                            onPressed: () {
                              Navigator.pushNamed(context, '/colourList',
                                  arguments: colourDb);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                              child: Text(
                                'View Colours',
                                style: TextStyle(
                                  color: Color(0xFF1f3f4a),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
              )),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 15.0),
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          color: Colors.blueGrey,
                        ),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                prevColour = currColour;
                                red = Random().nextInt(255);
                                green = Random().nextInt(255);
                                blue = Random().nextInt(255);
                                hexCode = intToHexString(red, green, blue);
                                saved = false;

                                currColour =
                                    Color.fromARGB(0xFF, red, green, blue);
                              });
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(color: Color(0xFF1f3f4a)),
                            )),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            color: Colors.blueGrey,
                          ),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  saved = false;
                                  currColour = prevColour;
                                  red = currColour.red;
                                  green = currColour.green;
                                  blue = currColour.blue;
                                  hexCode = intToHexString(red, green, blue);
                                });
                              },
                              child: Text(
                                "Previous",
                                style: TextStyle(color: Color(0xFF1f3f4a)),
                              )))
                    ]),
              ),
            ]),
          )
        ],
      ),
    );
  }
}

class CollectionList extends StatefulWidget {
  final ColourDb db;
  final Function selectCollection;
  const CollectionList(
      {super.key, required this.db, required this.selectCollection});

  @override
  State<CollectionList> createState() => _CollectionState();
}

class _CollectionState extends State<CollectionList> {
  List? tableList;
  @override
  Widget build(BuildContext context) {
    widget.db.listTables().then((tableMap) {
      var tbList = tableMap.map((table) => table['Collection']).toList();
      setState(() {
        tableList = tbList;
      });
    });

    if (tableList != null) {
      return ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: tableList!
                .map((table) => TextButton(
                    onPressed: () {
                      widget.selectCollection(table);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      table,
                      style: TextStyle(
                        color: Colors.blueGrey[200],
                        fontSize: 12,
                      ),
                    )))
                .toList(),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
