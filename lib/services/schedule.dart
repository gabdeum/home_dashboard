import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Schedule {

  //List of Map with:
  //    type (metros, rers, tramways, buses or noctiliens)
  //    code (e.g. 8)
  //    station (e.g. Guy Moquet)
  //    way (Available values: A, R, A+R)
  List<Map> lineDetails;
  List<Map> stations = [];
  Map directions = {};
  Timer? timer;
  Stream? stream;

  // final String url;
  Schedule({required this.lineDetails});

  Stream getScheduleStream() {

    final _controller = StreamController<List>();

    getSchedule() async {

      List _schedules = [];

      for (var lineDetail in lineDetails) {

        if(lineDetail['code'] != null || lineDetail['stationCode'] != null || lineDetail['way'] != null){

          String _url = 'https://api-ratp.pierre-grimaud.fr/v4/schedules/${lineDetail['type']}/'
              '${lineDetail['code']}/${lineDetail['stationCode']}/${lineDetail['way']}';

          try{

            Response _response = await get(Uri.parse(_url));
            Map _data = const JsonDecoder().convert(_response.body);

            List _dataList = List.castFrom(_data['result']['schedules']);

            for (var element in _dataList) {

              Map _schedule = {
                'line' : lineDetail['code'],
                'time' : 0,
                'destination' : ''
              };
              _schedule['destination'] = element['destination'].toString();

              String message = element['message'].toString().replaceFirst(' mn', '');

              if (int.tryParse(message) != null){
                int intSchedule = int.tryParse(message)! - 1;
                _schedule['time'] = intSchedule;
              }
              else if (message == "Train a l'approche"){
                int intSchedule = -1;
                _schedule['time'] = intSchedule;
              }
              else if(message == "Train a quai"){
                int intSchedule = -2;
                _schedule['time'] = intSchedule;
              }

              _schedules.add(_schedule);

            }
          }

          catch (e){

            _schedules.add({
              'line' : lineDetail['code'],
              'time' : -10,
              'destination' : 'No Data'
            });
            print('Request URL: $_url\nERROR: $e');
          }

        }
      }

      _schedules.sort((a, b) => (a['time']).compareTo(b['time']));
      _controller.sink.add(_schedules);
    }

    getSchedule();
    timer = Timer.periodic(const Duration(seconds: 30), (t) {
      getSchedule();
    });

    stream = _controller.stream;
    return _controller.stream;

  }

  Future getStations() async {

    List<Map> _destination = [];

    for (var lineDetail in lineDetails) {

      String _url = 'https://api-ratp.pierre-grimaud.fr/v4/stations/${lineDetail['type']}/'
          '${lineDetail['code']}';
      Response _response = await get(Uri.parse(_url));
      Map _data = const JsonDecoder().convert(_response.body);

      try{
        List _dataList = List.castFrom(_data['result']['stations']);

        for (var element in _dataList) {
          _destination.add({
            'name' : element['name'].toString(),
            'slug' : element['slug'].toString()
          });
        }
      }

      catch(e){
        _destination = [{'name' : 'No station to display'}];
        print(e);
      }

      stations = _destination;
      return _destination;

    }
  }

  getDirections() async {

    Map _directions = {};

    for (var lineDetail in lineDetails) {

      String _url = 'https://api-ratp.pierre-grimaud.fr/v4/lines/${lineDetail['type']}/'
          '${lineDetail['code']}';
      Response _response = await get(Uri.parse(_url));
      Map _data = const JsonDecoder().convert(_response.body);

      try{
        List<String> _dataList = _data['result']['directions'].toString().split(' / ');
        _directions = {
          'A' : _dataList[0].toString(),
          'R' : _dataList[1].toString()
        };
      }

      catch(e){
        print(e);
      }

      directions = _directions;
      return _directions;

    }

  }

}