import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:home_dashboard/services/schedule.dart';
import 'package:home_dashboard/services/weather.dart';
import 'package:home_dashboard/services/customCard.dart';
import 'package:home_dashboard/services/clock.dart';

class Home extends StatelessWidget {

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final ScheduleStream newSchedule = ScheduleStream(type: 'metros', code: '13', station: 'Guy Moquet', way: 'A');
    final FutureWeather newWeather = FutureWeather(lat: 48.8909971, lon: 2.3281126, gmt: 1);

    newSchedule.stream;
    newWeather.getCurrentWeather();
    
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
                    Expanded(
                      child: CustomCard(
                        title: 'Clock',
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Clock(),
                              const SizedBox(height: 20.0,),
                              FutureBuilder(
                                future: newWeather.getCurrentWeather(),
                                builder: (context, data){
                                  if (data.connectionState == ConnectionState.done && data.data != null){
                                    Map weather = data.data as Map;
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset('assets/sunrise.svg', height: 60.0,),
                                            Text('${weather['sunrise']}', textAlign: TextAlign.center,style: MyTextStyle().medium,)
                                          ],
                                        ),
                                        // const SizedBox(width: 40.0,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset('assets/sunset.svg', height: 60.0,),
                                            Text('${weather['sunset']}', textAlign: TextAlign.center,style: MyTextStyle().medium,)
                                          ],
                                        )
                                      ],
                                    );
                                  }
                                  else {
                                    return Center(child: CircularProgressIndicator(color: MyColors().darkColor1,));
                                  }
                                }
                              )
                            ],
                          )
                        ),
                      ),
                    ),
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