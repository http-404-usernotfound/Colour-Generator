import 'package:flutter/material.dart';
import 'package:colour_generator/screens/colour.dart';
import 'package:colour_generator/screens/collection_widget.dart';

class ColourList extends StatefulWidget {
  const ColourList({super.key});

  @override
  State<ColourList> createState() => _ColourListState();
}

class _ColourListState extends State<ColourList> {
  List<Map>? collectionList;
  ColourDb colourDb = ColourDb('');
  int newCounter = 1;

  @override
  void initState() {
    super.initState();

    colourDb.create().then((db) {
      colourDb.listTables().then((list) {
        setState(() {
          collectionList = list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (collectionList == null) {
      return Scaffold(
        backgroundColor: Color(0xFF282a2b),
        appBar: AppBar(
          title: Text(
            "Collections",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromARGB(255, 73, 105, 192),
          shadowColor: Colors.black38,
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Color(0xFF282a2b),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              for (Map name in collectionList!) {
                if (name['Collection'] == 'Collection $newCounter') {
                  newCounter++;
                }
              }
              colourDb.changeSchema('Collection $newCounter');
              colourDb.create().then((db) {
                colourDb.listTables().then((list) {
                  setState(() {
                    collectionList = list;
                  });
                });
              });
            },
            icon: Icon(Icons.add_card),
            label: Text('New Collection')),
        appBar: AppBar(
          elevation: 1.0,
          title: Text(
            "Collections",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromARGB(255, 73, 105, 192),
          shadowColor: Colors.black38,
        ),
        body: ListView(
            children: collectionList!
                .map((collection) => CollectionWidget(
                    collection: collection,
                    colourDb: colourDb,
                    setParentState: () {
                      colourDb.listTables().then((list) {
                        setState(() {
                          collectionList = list;
                        });
                      });
                    }))
                .toList()),
      );
    }
  }
}
