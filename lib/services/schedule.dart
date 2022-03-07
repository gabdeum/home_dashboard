import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';

class Schedule {

  //List of Map with:
  //    type (metros, rers, tramways, buses or noctiliens)
  //    code (e.g. 8)
  //    station (e.g. Guy Moquet)
  //    way (Available values: A, R, A+R)
  final List<Map> lineDetails;
  List<Map> stations = [];
  Map directions = {};

  // final String url;
  Schedule({required this.lineDetails});

  Stream getScheduleStream() {

    final _controller = StreamController<List>();

    getSchedule() async {

      List<Map> _schedule = [];
      List _destination = []; //Direction name
      List _schedules = []; //When are the next schedules

      for (var lineDetail in lineDetails) {

        String _url = 'https://api-ratp.pierre-grimaud.fr/v4/schedules/${lineDetail['type']}/'
            '${lineDetail['code']}/${lineDetail['stationCode']}/${lineDetail['way']}';
        Response _response = await get(Uri.parse(_url));
        Map _data = const JsonDecoder().convert(_response.body);

        try{
          List _dataList = List.castFrom(_data['result']['schedules']);

          for (var element in _dataList) {
            _destination.add(element['destination'].toString());

            String message = element['message'].toString().replaceFirst(' mn', '');
            bool isInt = int.tryParse(message) != null;

            if(isInt == true){
              String intSchedule = int.tryParse(message) != 0 ? '${(int.tryParse(message)! - 1).toString()} min' : "Train a l'approche";
              _schedules.add(intSchedule);
            }
            else{
              _schedules.add(message);
            }
          }
        }

        catch (e){
          _destination = ['No data found'];
          _schedules = ['-'];
          print(e);
        }

      }
      _controller.sink.add([_schedules, _destination]);
    }

    getSchedule();
    Timer.periodic(const Duration(seconds: 30), (t) {
      getSchedule();
    });

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
            'name' : element['name'],
            'slug' : element['slug']
          });
        }
      }

      catch(e){
        _destination = [{'name' : 'No station to display'}];
        print(e);
      }

      print(_destination);
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

      print(_directions);
      directions = _directions;
      return _directions;

    }

  }

}