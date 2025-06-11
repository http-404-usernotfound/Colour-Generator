import 'package:flutter/material.dart';
import 'package:colour_generator/screens/colour.dart';
import 'package:colour_generator/screens/colour_widget.dart';

class SavedColours extends StatefulWidget {
  const SavedColours({super.key});

  @override
  State<SavedColours> createState() => _SavedColoursState();
}

class _SavedColoursState extends State<SavedColours> {
  List<Map>? colourList;
  ColourDb colourDb = ColourDb('');
  bool selected = false;
  List selectedColours = [];
  int delColours = 0;

  @override
  Widget build(BuildContext context) {
    String collectionName =
        ModalRoute.of(context)!.settings.arguments as String;

    colourDb.changeSchema(collectionName);
    colourDb.create().then((val) {
      colourDb.listColours().then((list) {
        setState(() {
          colourList = list;
        });
      });
    });

    if (colourList == null) {
      return Scaffold(
        backgroundColor: Color(0xFF282a2b),
        appBar: AppBar(
          title: Text(
            "Colours",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromARGB(255, 73, 105, 192),
          shadowColor: Colors.black38,
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color(0xFF282a2b),
        appBar: AppBar(
          elevation: 1.0,
          actions: [
            TextButton(
                onPressed: () {
                  colourDb.export();
                },
                child: Text('Export')),
            TextButton(
                onPressed: () {
                  colourDb.import().then((val) {
                    if (val == true) {}
                    colourDb.listColours().then((list) {
                      setState(() {
                        colourList = list;
                      });
                    });
                  });
                },
                child: Text('Import')),
            //IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
            Visibility(
                visible: selected,
                child: IconButton(
                    onPressed: () async => showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text(
                              '$delColours colours will be permanently deleted',
                              style: TextStyle(
                                color: Colors.blueGrey[200],
                              ),
                            ),
                            backgroundColor: Color(0xFF57595a),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                            actionsPadding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                            actions: [
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateColor.fromMap({
                                  WidgetState.any: Colors.blueGrey,
                                })),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Color(0xFF1f3f4a),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateColor.fromMap({
                                  WidgetState.any: Colors.blueGrey,
                                })),
                                onPressed: () {
                                  colourDb
                                      .removeList(selectedColours)
                                      .then((v) {
                                    colourDb.listColours().then((list) {
                                      setState(() {
                                        selected = false;
                                        colourList = list;
                                        Navigator.of(context).pop();
                                      });
                                    });
                                  });
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Color(0xFF1f3f4a),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    icon: Icon(Icons.delete)))
          ],
          title: Text(
            "Colours",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromARGB(255, 73, 105, 192),
          shadowColor: Colors.black38,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: colourList!
                  .map(
                    (colour) => ColourWidget(
                        colour: colour,
                        selected: selected,
                        setSelected: (String hexcode) async {
                          setState(() {
                            delColours += 1;
                            selectedColours.add(hexcode);
                            selected = true;
                          });
                        },
                        showSnack: (String hex) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Copied $hex!'),
                            duration: Duration(milliseconds: 1618),
                          ));
                        },
                        newSelect: (String hexcode, bool select) {
                          if (select) {
                            selectedColours.add(hexcode);
                            delColours += 1;
                          } else {
                            selectedColours.remove(hexcode);
                            delColours -= 1;
                            if (delColours == 0) {
                              setState(() {
                                selected = false;
                              });
                            }
                          }
                          print(selectedColours);
                        }),
                  )
                  .toList(),
            )),
      );
    }
  }
}
