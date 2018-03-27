import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mobile_citymap_flutter/model/City.dart';


class CityMapPage extends StatefulWidget  {

    CityMapPage(this.cities);

    final List<City> cities;

    @override
    State<StatefulWidget> createState() => new _CityMapPageState();
}

class _CityMapPageState extends State<CityMapPage> {

    Marker _buildCityMarker(City city) {
        return new Marker(
            width: 30.0,
            height: 30.0,
            point: new LatLng(
            double.parse(city.latitude),
            double.parse(city.longitude)),
            builder: (ctx) => new Container(
                child: new Icon(Icons.room, color: Colors.red,)
            ),
        );
    }

    List<Marker> _buildCitiesMarkers() {
        return widget.cities.map(_buildCityMarker).toList();
    }

    Widget _getMap() {
        return new FlutterMap(
            options: new MapOptions(
                zoom: 3.0,
            ),
            layers: [
                new TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']
                ),
                new MarkerLayerOptions(markers: _buildCitiesMarkers()),
            ],
        );
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text("Global map")
            ),
            body: _getMap(),
        );
    }
}