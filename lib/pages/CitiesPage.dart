import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_citymap_flutter/model/City.dart';
import 'package:mobile_citymap_flutter/data/CityRepository.dart';
import 'package:mobile_citymap_flutter/utils/FadeRoute.dart';
import 'package:mobile_citymap_flutter/pages/CityDetailsPage.dart';
import 'package:mobile_citymap_flutter/pages/CityMapPage.dart';


class CitiesPage extends StatefulWidget {
    CitiesPage({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _CitiesPageState createState() => new _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {

    final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

    List<City> _items = <City>[];

    bool _isLoading = false;


    void _loadData() {
        setState(() {
            _isLoading = true;
            _items.clear();
        });

        CityRepository.get()
            .getCities()
            .then((cities){
                setState(() {
                    _isLoading = false;
                    if (cities.isOk()) {
                        _items = cities.body;
                    } else {
                        scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: new Text("Something went wrong, check your internet connection")));
                    }
                });
            });
    }

    void _onMapBtnClicked() {
        Navigator.of(context).push(
            new FadeRoute(
                builder: (BuildContext context) => new CityMapPage(_items),
                settings: new RouteSettings(isInitialRoute: false),
            ));
    }

    void _onTileClicked(int index) {
        Navigator.of(context).push(
            new FadeRoute(
                builder: (BuildContext context) => new CityDetailsPage(_items[index]),
                settings: new RouteSettings(isInitialRoute: false),
            ));
    }

    Widget _getTile(City city, int index) {
        return new GridTile(
            child: new InkResponse(
                enableFeedback: true,
                child: new Hero(
                    child: new CachedNetworkImage(
                        imageUrl: city.url,
                        fit: BoxFit.cover,
                    ),
                    tag: city.id
                ),
                onTap: () => _onTileClicked(index),
            ));
    }

    List<Widget> _getTiles() {
        final List<Widget> tiles = <Widget>[];
        for (int i = 0; i < _items.length; i++) {
            tiles.add(_getTile(_items[i], i));
        }
        return tiles;
    }

    Widget _getGridView() {
        return new GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            padding: const EdgeInsets.all(4.0),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            children: _getTiles(),
        );
    }

    Widget _getMapBtn() {
        return new IconButton(
            icon: new Icon(Icons.map),
            tooltip: 'Map',
            onPressed: _onMapBtnClicked,
        );
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
                actions: <Widget>[_getMapBtn()],
            ),
            body: _isLoading
                ? new Center(child: new CircularProgressIndicator())
                : _items.length == 0
                    ? new Center(child: new Text('No data 😢'))
                    : _getGridView(),
        );
    }
}

