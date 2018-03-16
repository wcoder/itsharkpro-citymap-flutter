import 'package:meta/meta.dart';

class City {
    static final db_id = "id";
    static final db_title = "title";
    static final db_description = "description";
    static final db_latitude = "latitude";
    static final db_longitude = "longitude";
    static final db_url = "url";

    String id, title, description, latitude, longitude, url;

    City({
        @required this.id,
        @required this.title,
        @required this.description,
        @required this.latitude,
        @required this.longitude,
        @required this.url
    });

    City.fromMap(Map<String, dynamic> map): this(
        id: map[db_id],
        title: map[db_title],
        description: map[db_description],
        latitude: map[db_latitude],
        longitude:map[db_longitude],
        url: map[db_url]
    );
}