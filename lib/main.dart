import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:colour_generator/screens/home_screen.dart';
import 'package:colour_generator/screens/colour_list.dart';
import 'package:colour_generator/screens/collection_list.dart';
import 'package:colour_generator/screens/colour_palette.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(ColGen());
}

class ColGen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => HomeScreen(),
        '/colourList': (context) => ColourList(),
        '/colourList/savedColours': (context) => SavedColours(),
        '/colourList/savedColours/colourPalette': (context) => ColourDetails(),
      },
    );
  }
}
