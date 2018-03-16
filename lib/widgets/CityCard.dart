import 'package:flutter/material.dart';
import 'package:mobile_citymap_flutter/model/City.dart';


class CityCard extends StatefulWidget {

    CityCard(this.city);

    final City city;

    @override
    State<StatefulWidget> createState() => new _CityCardState();

}

class _CityCardState extends State<CityCard> {

    @override
    Widget build(BuildContext context) {

        City city = widget.city;

        return new GestureDetector(
            onTap: (){
//                Navigator.of(context).push(
//                    new FadeRoute(
//                        builder: (BuildContext context) => new BookNotesPage(bookState),
//                        settings: new RouteSettings(name: '/notes', isInitialRoute: false),
//                    ));
            },
            child: new Card(
                child: new Container(
                    height: 150.0,
                    child: new Padding(
                        padding: new EdgeInsets.all(8.0),
                        child: new Row(
                            children: <Widget>[
                                city.url != null?
                                new Hero(
                                    child: new Image.network(city.url, width: 150.0),
                                    tag: city.id,
                                ):
                                new Container(),
                                new Expanded(
                                    child: new Stack(
                                        children: <Widget>[
                                            new Align(
                                                child: new Padding(
                                                    child: new Text(city.title, maxLines: 10),
                                                    padding: new EdgeInsets.all(8.0),
                                                ),
                                                alignment: Alignment.center,
                                            ),
                                        ],
                                    ),
                                ),

                            ],
                        )
                    ),
                )
            ),
        );
    }

}