import 'package:colour_generator/screens/colour.dart';
import 'package:flutter/material.dart';

class CollectionWidget extends StatefulWidget {
  final Map collection;
  final ColourDb colourDb;
  final Function setParentState;
  const CollectionWidget(
      {super.key,
      required this.collection,
      required this.colourDb,
      required this.setParentState});

  @override
  State<CollectionWidget> createState() => _CollectionWidgetState();
}

class _CollectionWidgetState extends State<CollectionWidget> {
  @override
  Widget build(BuildContext context) {
    String currentName = widget.collection['Collection'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      decoration: BoxDecoration(
          color: Color(0xFF57595a),
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/colourList/savedColours',
              arguments: currentName);
        },
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  currentName,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.blueGrey[200],
                  ),
                ),
              ),
            ),
            TextButton.icon(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                label: Text(''),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Tap and Hold to Delete!'),
                    duration: Duration(milliseconds: 1618),
                  ));
                },
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                            '"${widget.collection['Collection']}" will be permanently deleted',
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
                                widget.colourDb.deleteSchema(currentName);
                                widget.setParentState();
                                Navigator.of(context).pop();
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
                      });
                }),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String newName = "";
                      return AlertDialog(
                        backgroundColor: Color(0xFF57595a),
                        title: Text(
                          'Rename',
                          style: TextStyle(
                            color: Colors.blueGrey[200],
                          ),
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                        actionsPadding: EdgeInsets.fromLTRB(0, 15, 10, 10),
                        content: TextField(
                          decoration: InputDecoration(
                              helperText: currentName,
                              helperStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintText: 'New Collection Name',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(100, 255, 255, 255))),
                          onChanged: (input) {
                            newName = input;
                          },
                        ),
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
                              widget.colourDb.changeSchema(currentName);
                              widget.colourDb.renameSchema(newName)?.then((tp) {
                                widget.setParentState();
                              });
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Rename',
                              style: TextStyle(
                                color: Color(0xFF1f3f4a),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.edit_square),
              style: ButtonStyle(
                foregroundColor: WidgetStateColor.fromMap({
                  WidgetState.any: Colors.white,
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
