import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_dashboard/pages/settings.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:home_dashboard/services/schedule.dart';
import 'package:home_dashboard/services/weather.dart';
import 'package:home_dashboard/services/customCards.dart';

//ignore: must_be_immutable
class Home extends StatelessWidget {

  Map? settingsData;

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Schedule newSchedule = Schedule(lineDetails: [{'type': 'metros', 'code': '13', 'stationCode': 'Guy+Moquet', 'station': 'Guy Moquet', 'way': 'A'}]);
    final FutureWeather newWeather = FutureWeather(lat: 48.8909971, lon: 2.3281126, gmt: 1);
    
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
                              print('new: $value - current: $settingsData');
                              settingsData = value as Map;
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