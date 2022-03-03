import 'package:http/http.dart';
import 'dart:convert';

class GeoLoc {

  List<Map> location = [];
  final String address;
  final String key = 'AIzaSyCBsCjKGavUAdWN6hTCVQWBH81ARmNqBUI';

  GeoLoc({required this.address});

  getLoc() async {

    String _address = address.replaceAll(' ', '%20');
    String _url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$_address&key=$key';
    Response _response = await get(Uri.parse(_url));

    final Map _data = const JsonDecoder().convert(_response.body);
    final List _dataList =  _data['results'] as List;

    for (var _element in _dataList){

      location.add({
        'fullName' : _element['formatted_address'],
        'lat' : _element['geometry']['location']['lat'],
        'lon' : _element['geometry']['location']['lng']
      });
    }

    return location;

  }
}