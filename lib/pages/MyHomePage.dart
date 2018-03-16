import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile_citymap_flutter/model/City.dart';
import 'package:mobile_citymap_flutter/database.dart';


class MyHomePage extends StatefulWidget {
    MyHomePage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

    List<City> _items = new List();
    bool _isLoading = false;

    void _loadData() {
        setState((){_isLoading = true;});
        _clearList();
        http.get('https://api.myjson.com/bins/7ybe5')
            .then((response) => response.body)
            .then(JSON.decode)
            .then((map) => map['photos'])
            .then((list) {
                list.forEach(_addCity);
            })
            .catchError(_onError)
            .then((e){
                setState((){ _isLoading = false; });
            });
    }

    void _addCity(dynamic city) {
        setState(() {
            _items.add(new City(
                id:          city['id'],
                title:       city['title'],
                description: city['description'],
                latitude:    city['latitude'],
                longitude:   city['longitude'],
                url:         city['url']));
        });
    }

    void _clearList() {
        setState(() {
            _items.clear();
        });
    }

    void _onError(dynamic d) {
        setState(() {
            _isLoading = false;
        });
    }

    @override
    void initState() {
        super.initState();
        CityDatabase.get().init();
        _loadData();
    }

    @override
    void dispose() {
        CityDatabase.get().close();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text(widget.title),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        _isLoading? new CircularProgressIndicator(): new Container(),
                        new Expanded(
                            child: new ListView.builder(
                                padding: new EdgeInsets.all(8.0),
                                itemCount: _items.length,
                                itemBuilder: (BuildContext context, int index) {
                                    return new CityCard(_items[index]);
                                },
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}

class CityCard extends StatefulWidget {

    CityCard(this.city);

    final City city;

    @override
    State<StatefulWidget> createState() => new _CityCardState();

}

class _CityCardState extends State<CityCard> {

    City city;


    @override
    void initState() {
        super.initState();
        city = widget.city;
        CityDatabase.get()
            .getCity(widget.city.id)
            .then((cityObj){
                if (cityObj == null) return;
                setState((){
                    city = cityObj;
                });
            });

    }

    @override
    Widget build(BuildContext context) {
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
                    height: 200.0,
                    child: new Padding(
                        padding: new EdgeInsets.all(8.0),
                        child: new Row(
                            children: <Widget>[
                                city.url != null?
                                new Hero(
                                    child: new Image.network(city.url, width: 100.0, height: 100.0),
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