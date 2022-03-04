import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'customCards.dart';
import 'formatClasses.dart';

class Schedule {

  final String type; // The type of transport (metros, rers, tramways, buses or noctiliens)
  final String code; //The code of transport line (e.g. 8)
  final String station; //Slug of the station name (e.g. Guy Moquet)
  final String way; //Way of the line (Available values: A, R, A+R)

  // final String url;
  Schedule({required this.type, required this.code, required this.station, required this.way});

  Stream getScheduleStream() {

    final _controller = StreamController<List>();

    getSchedule() async {

      List _destination = []; //Direction name
      List _schedules = []; //When are the next schedules

      String _stationCode = station.replaceAll(' ', '+');
      String _url = 'https://api-ratp.pierre-grimaud.fr/v4/schedules/$type/$code/$_stationCode/$way';

      Response _response = await get(Uri.parse(_url));
      Map data = const JsonDecoder().convert(_response.body);

      try{
        List _dataList = List.castFrom(data['result']['schedules']);

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
      _controller.sink.add([_schedules, _destination]);
    }

    getSchedule();
    Timer.periodic(const Duration(seconds: 30), (t) {
      getSchedule();
    });

    return _controller.stream;

  }

  // getStations() async {
  //
  //   List<Map> _destination = [];
  //
  //   String _url = 'https://api-ratp.pierre-grimaud.fr/v4/stations/$type/$code';
  //   Response _response = await get(Uri.parse(_url));
  //   Map data = const JsonDecoder().convert(_response.body);
  //
  //   try{
  //     List _dataList = List.castFrom(data['result']['stations']);
  //
  //     for (var element in _dataList) {
  //
  //       _destination.add({
  //         'name' : element['name'],
  //         'slug' : element['slug']
  //       });
  //
  //     }
  //   }
  //
  //   catch(e){
  //     _destination = [{'name' : 'No station to display'}];
  //     print(e);
  //   }
  //
  // }

}

// class WeatherCard extends StatelessWidget {
//   const WeatherCard({
//     Key? key,
//     required this.newSchedule,
//   }) : super(key: key);
//
//   final ScheduleStream newSchedule;
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       flex: 3,
//       child: CustomCard(
//         title: 'Station ${newSchedule.station}',
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
//           child: StreamBuilder(
//               stream: newSchedule.stream,
//               builder: (context, data){
//                 if(data.connectionState == ConnectionState.active){
//                   List newStreamList = [];
//                   newStreamList = data.data as List;
//                   return ListView.builder(
//                       shrinkWrap: true,
//                       scrollDirection: Axis.vertical,
//                       itemCount:newStreamList[0].length,
//                       itemBuilder: (context, index){
//                         return ListTile(
//                           leading: SvgPicture.asset('assets/m${newSchedule.code}.svg', width: 40.0, height: 40.0,),
//                           title: Text(newStreamList[1][index].toString(), style: MyTextStyle().large,),
//                           trailing: Text(newStreamList[0][index].toString(), style: MyTextStyle().large),
//                         );
//                       });
//                 }
//                 else{
//                   return Center(child: CircularProgressIndicator(color: MyColors().darkColor1,));
//                 }
//               }),
//         ),),
//     );
//   }
// }