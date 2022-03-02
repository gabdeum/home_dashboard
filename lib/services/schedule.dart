import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'customCards.dart';
import 'formatClasses.dart';

class ScheduleStream {

  final String type; // The type of transport (metros, rers, tramways, buses or noctiliens)
  final String code; //The code of transport line (e.g. 8)
  final String station; //Slug of the station name (e.g. Guy Moquet)
  final String way; //Way of the line (Available values: A, R, A+R)

  final _controller = StreamController<List>();

  // final String url;
  ScheduleStream({required this.type, required this.code, required this.station, required this.way}) {
    getSchedule();
    Timer.periodic(const Duration(seconds: 30), (t) {
      getSchedule();
    });
  }

  getSchedule() async {

    List _destination = []; //Direction name
    List _schedules = []; //When are the next schedules

    String stationCode = station.replaceAll(' ', '+');
    String url = 'https://api-ratp.pierre-grimaud.fr/v4/schedules/' + type + '/' + code
        + '/' + stationCode + '/' + way;

    Response response = await get(Uri.parse(url));
    Map data = const JsonDecoder().convert(response.body);

    List dataList = List.castFrom(data['result']['schedules']);

    for (var element in dataList) {
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

    _controller.sink.add([_schedules, _destination]);
  }

  Stream<List> get stream => _controller.stream;

}

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    Key? key,
    required this.newSchedule,
  }) : super(key: key);

  final ScheduleStream newSchedule;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 3,
      child: CustomCard(
        title: 'Station ${newSchedule.station}',
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
          child: StreamBuilder(
              stream: newSchedule.stream,
              builder: (context, data){
                if(data.connectionState == ConnectionState.active){
                  List newStreamList = [];
                  newStreamList = data.data as List;
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount:newStreamList[0].length,
                      itemBuilder: (context, index){
                        return ListTile(
                          leading: SvgPicture.asset('assets/m${newSchedule.code}.svg', width: 40.0, height: 40.0,),
                          title: Text(newStreamList[1][index].toString(), style: MyTextStyle().large,),
                          trailing: Text(newStreamList[0][index].toString(), style: MyTextStyle().large),
                        );
                      });
                }
                else{
                  return Center(child: CircularProgressIndicator(color: MyColors().darkColor1,));
                }
              }),
        ),),
    );
  }
}