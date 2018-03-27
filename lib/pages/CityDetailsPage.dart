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

    Widget _getImage() {
        return new Hero(
            child: new CachedNetworkImage(
                imageUrl: widget.city.url,
                fit: BoxFit.cover,
            ),
            tag: widget.city.id
        );
    }

    Widget _getDescription() {
        return new Padding(
            padding: new EdgeInsets.all(8.0),
            child: new Text(
                widget.city.description.length > 0
                    ? widget.city.description
                    : 'No data 😢'
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text(widget.city.title)
            ),
            body: new SingleChildScrollView(
                child: new Column(
                    children: <Widget>[
                        _getImage(),
                        _getDescription(),
                    ],
                ),
            ),
        );
    }
}