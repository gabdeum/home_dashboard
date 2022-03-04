import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:home_dashboard/services/schedule.dart';
import 'package:home_dashboard/services/weather.dart';
import 'package:home_dashboard/services/customCards.dart';

class Home extends StatelessWidget {

  const Home({Key? key}) : super(key: key);

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
              CustomScheduleCard(newSchedule: newSchedule),
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