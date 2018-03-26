import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_citymap_flutter/model/City.dart';


class CityDetailsPage extends StatefulWidget  {

    CityDetailsPage(this.city);

    final City city;

    @override
    State<StatefulWidget> createState() => new _CityDetailsPageState();
}


class _CityDetailsPageState extends State<CityDetailsPage> {

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text(widget.city.title)
            ),
            body: new Container(
                child: new Column(
                    children: <Widget>[
                        new Hero(
                            child: new CachedNetworkImage(
                                imageUrl: widget.city.url,
                                fit: BoxFit.cover,
                            ),
                            tag: widget.city.id
                        ),
                        new Expanded(
                            child: new Padding(
                                padding: new EdgeInsets.all(8.0),
                                child: new Text(widget.city.description),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}