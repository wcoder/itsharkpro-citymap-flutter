import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_citymap_flutter/data/CityDatabase.dart';
import 'package:mobile_citymap_flutter/model/City.dart';


/// A class similar to http.Response but instead of a String describing the body
/// it already contains the parsed Dart-Object
class ParsedResponse<T> {
    ParsedResponse(this.statusCode, this.body);
    final int statusCode;
    final T body;

    bool isOk() {
        return statusCode >= 200 && statusCode < 300;
    }
}


final int NO_INTERNET = 404;

class CityRepository {

    static final CityRepository _repo = new CityRepository._internal();

    CityDatabase database;

    static CityRepository get() {
        return _repo;
    }

    CityRepository._internal() {
        database = CityDatabase.get();
    }


    /// Fetches the books from the Google Books Api with the query parameter being input.
    /// If a book also exists in the local storage (eg. a book with notes/ stars) that version of the book will be used instead
    Future<ParsedResponse<List<City>>> getCities() async {
        //http request, catching error like no internet connection.
        //If no internet is available for example response is
        http.Response response = await http.get("https://api.myjson.com/bins/7ybe5")
            .catchError((resp) {});

        if(response == null) {
            return new ParsedResponse(NO_INTERNET, []);
        }

        //If there was an error return an empty list
        if(response.statusCode < 200 || response.statusCode >= 300) {
            return new ParsedResponse(response.statusCode, []);
        }
        // Decode and go to the items part where the necessary book information is
        List<dynamic> list = JSON.decode(response.body)['photos'];

        Map<String, City> networkBooks = {};

        for(dynamic jsonCity in list) {
            City book = new City(
                id: jsonCity['id'].toString(),
                title: jsonCity['title'],
                description: jsonCity['description'],
                latitude: jsonCity['latitude'].toString(),
                longitude: jsonCity['longitude'].toString(),
                url: jsonCity['url'],
            );

            networkBooks[book.id] = book;
        }

        List<City> databaseBook = await database.getCities([]..addAll(networkBooks.keys));
        for(City book in databaseBook) {
            networkBooks[book.id] = book;
        }

        return new ParsedResponse(response.statusCode, []..addAll(networkBooks.values));
    }

    Future updateBook(City book) async {
        database.updateCity(book);
    }

    Future close() async {
        return database.close();
    }

}