import 'package:colour_generator/screens/colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColourWidget extends StatefulWidget {
  late final String hexcode;
  late final int r;
  late final int g;
  late final int b;
  final Function setSelected;
  final Function newSelect;
  final Function showSnack;

  bool selected;

  ColourWidget(
      {super.key,
      required Map colour,
      required this.showSnack,
      required this.selected,
      required this.setSelected,
      required this.newSelect}) {
    hexcode = colour['hexcode'] as String;
    r = colour['r'] as int;
    g = colour['g'] as int;
    b = colour['b'] as int;
  }

  @override
  State<ColourWidget> createState() => _ColourWidgetState();
}

class _ColourWidgetState extends State<ColourWidget> {
  bool thisSelected = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.selected) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        padding: EdgeInsets.symmetric(horizontal: 3.0),
        decoration: BoxDecoration(
          color: Color(0xFF57595a),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: <BoxShadow>[],
        ),
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(
                context, '/colourList/savedColours/colourPalette',
                arguments:
                    Colour(widget.hexcode, widget.r, widget.g, widget.b));
          },
          onLongPress: () {
            thisSelected = true;
            widget.setSelected(widget.hexcode);
          },
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6.0, 25, 0, 25),
                  child: Text(
                    widget.hexcode,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.blueGrey[200],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'R: ${widget.r}\nG: ${widget.g}\nB: ${widget.b}',
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Color.fromARGB(120, 255, 255, 255)),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: IconButton(
                      style: ButtonStyle(
                        foregroundColor: WidgetStateColor.fromMap({
                          WidgetState.any: Color.fromARGB(120, 255, 255, 255)
                        }),
                      ),
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: widget.hexcode));
                        widget.showSnack(widget.hexcode);
                      },
                      icon: Icon(Icons.copy))),
              Expanded(
                flex: 2,
                child: SizedBox.square(
                  // Colour Background.
                  dimension: 67.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(0xFF, widget.r, widget.g, widget.b),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Checkbox(
                value: thisSelected,
                onChanged: (newVal) {
                  setState(() {
                    thisSelected = newVal!;
                    widget.newSelect(widget.hexcode, newVal);
                  });
                }),
          ),
          Expanded(
            flex: 8,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              padding: EdgeInsets.symmetric(horizontal: 3.0),
              decoration: BoxDecoration(
                color: Color(0xFF57595a),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                boxShadow: <BoxShadow>[],
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    thisSelected = !thisSelected;
                    widget.newSelect(widget.hexcode, thisSelected);
                  });
                },
                onLongPress: () {
                  setState(() {
                    thisSelected = !thisSelected;
                    widget.newSelect(widget.hexcode, thisSelected);
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6.0, 25, 0, 25),
                        child: Text(
                          widget.hexcode,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.blueGrey[200],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'R: ${widget.r}\nG: ${widget.g}\nB: ${widget.b}',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Color.fromARGB(120, 255, 255, 255)),
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                            style: ButtonStyle(
                              foregroundColor: WidgetStateColor.fromMap({
                                WidgetState.any:
                                    Color.fromARGB(120, 255, 255, 255)
                              }),
                            ),
                            onPressed: () async {
                              await Clipboard.setData(
                                  ClipboardData(text: widget.hexcode));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Copied!'),
                                duration: Duration(milliseconds: 1618),
                              ));
                            },
                            icon: Icon(Icons.copy))),
                    Expanded(
                      flex: 2,
                      child: SizedBox.square(
                        // Colour Background.
                        dimension: 67.0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(
                                0xFF, widget.r, widget.g, widget.b),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
