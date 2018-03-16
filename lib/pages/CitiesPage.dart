import 'package:flutter/material.dart';
import 'package:mobile_citymap_flutter/model/City.dart';
import 'package:mobile_citymap_flutter/data/CityRepository.dart';
import 'package:mobile_citymap_flutter/widgets/CityCard.dart';


class CitiesPage extends StatefulWidget {
    CitiesPage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _CitiesPageState createState() => new _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {

    List<City> _items = new List();

    bool _isLoading = false;

    GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();


    void _loadData() {
        setState((){_isLoading = true;});
        _clearList();
        CityRepository.get()
            .getCities()
            .then((cities){
                setState(() {
                    _isLoading = false;
                    if(cities.isOk()) {
                        _items = cities.body;
                    } else {
                        scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Something went wrong, check your internet connection")));
                    }
                });
            });
    }

    void _clearList() {
        setState(() {
            _items.clear();
        });
    }

    @override
    void initState() {
        super.initState();

        _loadData();
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            key: scaffoldKey,
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

