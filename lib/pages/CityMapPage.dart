import 'package:flutter/material.dart';
import 'package:mobile_citymap_flutter/model/City.dart';


class CityMapPage extends StatefulWidget  {

    CityMapPage(this.cities);

    final List<City> cities;

    @override
    State<StatefulWidget> createState() => new _CityMapPageState();
}


class _CityMapPageState extends State<CityMapPage> {

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Global map")
            ),
            body: new Container(
                child: new Column(
                    children: <Widget>[
                        new Expanded(
                            child: new Padding(
                                padding: new EdgeInsets.all(8.0),
                                child: new Text("..."),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}