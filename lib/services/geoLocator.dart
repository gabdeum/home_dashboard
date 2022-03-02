import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class GeoLoc {

  double? lat;
  double? lon;
  final String address;
  final String key = 'AIzaSyCBsCjKGavUAdWN6hTCVQWBH81ARmNqBUI';

  GeoLoc({required this.address});

  getLatLon() async {

    String _address = address.replaceAll(' ', '%20');
    String _url = 'https://maps.googleapis.com/maps/api/geocode/json?address=$_address&key=$key';
    Response _response = await get(Uri.parse(_url));

    Map _data = const JsonDecoder().convert(_response.body);

    print(_data['results'][0]['geometry']['location']);

  }

}