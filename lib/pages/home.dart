import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_dashboard/pages/settings.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:home_dashboard/services/schedule.dart';
import 'package:home_dashboard/services/weather.dart';
import 'package:home_dashboard/services/customCards.dart';

//ignore: must_be_immutable
class Home extends StatefulWidget {

  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map settingsData = {
    'lat' : 48.89,
    'lon' : 2.33,
    'scheduleData' : [{'type': 'metros', 'code': '13', 'stationCode': 'Guy+Moquet', 'station': 'Guy Moquet', 'way': 'A'}],
    'weather' : FutureWeather(lat: 48.89, lon: 2.33, gmt: 1),
    'schedules' : Schedule(lineDetails: [{'type': 'metros', 'code': '13', 'stationCode': 'Guy+Moquet', 'station': 'Guy Moquet', 'way': 'A'}])
  };

  Schedule? newSchedule;
  FutureWeather? newWeather;

  @override
  void initState() {
    // TODO: implement initState
    newSchedule = Schedule(lineDetails: settingsData['scheduleData']);
    newWeather = FutureWeather(lat: settingsData['lat'], lon: settingsData['lon'], gmt: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    newSchedule?.lineDetails = settingsData['scheduleData'];
    newWeather?.lat = settingsData['lat'];
    newWeather?.lon = settingsData['lon'];

    return SafeArea(
      child: Container(
        color: MyColors().bgColor,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 3,
                child: Stack(
                  children: [
                    CustomScheduleCard(newSchedule: newSchedule),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: FloatingActionButton(
                          heroTag: 'hero0',
                          mini: true,
                          onPressed: (){
                            Navigator.of(context).push(createRoute()).then((value){
                              if (value != settingsData){
                                print('Changing data');
                                settingsData = value as Map;
                                setState((){});
                              }
                            });
                          },
                          child: const Icon(Icons.settings,),
                          backgroundColor: MyColors().darkColor1,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 2.5,),
              Flexible(
                flex: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomWeatherCard(newWeather: newWeather),
                    const SizedBox(width: 2.5,),
                    CustomClockCard(newWeather: newWeather),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Route createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const Settings(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}