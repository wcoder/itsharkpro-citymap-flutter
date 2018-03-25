import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_citymap_flutter/model/City.dart';
import 'package:mobile_citymap_flutter/data/CityRepository.dart';


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

    // Function to be called on click
    void _onTileClicked(int index){
        debugPrint("You tapped on item $index");

//  Navigator.of(context).push(
//                    new FadeRoute(
//                        builder: (BuildContext context) => new BookNotesPage(bookState),
//                        settings: new RouteSettings(name: '/notes', isInitialRoute: false),
//                    ));
    }

    // Get grid tiles
    List<Widget> _getTiles(List<City> citiesList) {
        final List<Widget> tiles = <Widget>[];
        for (int i = 0; i < citiesList.length; i++) {
            tiles.add(new GridTile(
                child: new InkResponse(
                    enableFeedback: true,
                    child: new CachedNetworkImage(
                        imageUrl: citiesList[i].url,
                        fit: BoxFit.cover,
                    ),
                    onTap: () => _onTileClicked(i),
                )));
        }
        return tiles;
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
                        new Expanded(
                            child: _isLoading
                                ? new Center(child: new CircularProgressIndicator())
                                : _items.length == 0
                                    ? new Center(child: new Text('No data!'))
                                    : new GridView.count(
                                        crossAxisCount: 3,
                                        childAspectRatio: 1.0,
                                        padding: const EdgeInsets.all(4.0),
                                        mainAxisSpacing: 4.0,
                                        crossAxisSpacing: 4.0,
                                        children: _getTiles(_items),
                                    ),
                        ),
                    ],
                ),
            ),
        );
    }
}

