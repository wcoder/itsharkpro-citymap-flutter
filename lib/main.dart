import 'package:flutter/material.dart';
import 'package:mobile_citymap_flutter/pages/MyHomePage.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return new MaterialApp(
            title: 'City Map',
            theme: new ThemeData(
                primarySwatch: Colors.blue,
            ),
            routes: {
                '/': (BuildContext context) => new MyHomePage(title: 'City Map'),
            },
        );
    }
}


