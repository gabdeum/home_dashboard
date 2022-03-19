import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_dashboard/pages/settings.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:home_dashboard/services/schedule.dart';
import 'package:home_dashboard/services/weather.dart';
import 'package:home_dashboard/services/customCards.dart';

//ignore: must_be_immutable
class Home extends StatefulWidget {

  Map settingsData;
  Home({this.settingsData = const {}, Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Schedule? newSchedule;
  FutureWeather? newWeather;

  @override
  void initState() {
    newSchedule = Schedule(lineDetails: widget.settingsData['scheduleData']);
    newSchedule?.getScheduleStream();
    newWeather = FutureWeather(lat: widget.settingsData['lat'], lon: widget.settingsData['lon'], gmt: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    newSchedule?.timer?.cancel();
    newSchedule?.lineDetails = widget.settingsData['scheduleData'];
    newSchedule?.getScheduleStream();
    newWeather?.lat = widget.settingsData['lat'];
    newWeather?.lon = widget.settingsData['lon'];

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
                          onPressed: (){Navigator.of(context).push(createRoute(widget.settingsData)).then((value){
                            setState((){widget.settingsData = value;});
                          });},
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

Route createRoute(Map settingsData) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Settings(settingsData: settingsData,),
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