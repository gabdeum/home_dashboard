import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class GeoLoc {

  Map location = {};
  final String? address;
  final double? latitude;
  final double? longitude;
  final String key = 'AIzaSyCBsCjKGavUAdWN6hTCVQWBH81ARmNqBUI';

  GeoLoc({this.address, this.latitude, this.longitude});

  Future<Map> getLoc() async {

    String? _address = address?.replaceAll(' ', '%20');
    String _url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$_address&key=$key';
    Response _response = await get(Uri.parse(_url));

    final Map _data = const JsonDecoder().convert(_response.body);
    final List _dataList =  _data['results'] as List;

    location = {
      'leading' : _dataList.isEmpty ? Icons.not_listed_location : Icons.check_circle,
      'fullName' : _dataList.isEmpty ? "Couldn't find exact location, please precise" : _dataList[0]['formatted_address'],
      'lat' : _dataList.isEmpty ? '' : _dataList[0]['geometry']['location']['lat'],
      'lon' : _dataList.isEmpty ? '' : _dataList[0]['geometry']['location']['lng']
    };

    return location;

  }

  Future<Map> getLocFromLatLong() async {

    String _url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$key';
    Response _response = await get(Uri.parse(_url));
    final Map _data = const JsonDecoder().convert(_response.body);
    final List _dataList =  _data['results'] as List;

    location = {
      'leading' : _dataList.isEmpty ? Icons.not_listed_location : Icons.check_circle,
      'fullName' : _dataList.isEmpty ? "Couldn't find exact location, please precise" : _dataList[0]['formatted_address'],
      'lat' : _dataList.isEmpty ? '' : _dataList[0]['geometry']['location']['lat'],
      'lon' : _dataList.isEmpty ? '' : _dataList[0]['geometry']['location']['lng']
    };

    return location;

  }

}