import 'package:flutter/material.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:home_dashboard/services/schedule.dart';
import 'package:home_dashboard/services/weather.dart';
import 'clock.dart';

class CustomCard extends StatelessWidget {

  final Widget child;
  final String title;
  const CustomCard({required this.child, required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    height: 35,
                    width: title.length.toDouble() * 40,
                    decoration: BoxDecoration(
                        color: MyColors().lightColor1,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(title, style: MyTextStyle().title),
                  )
                ],
              ),
              Expanded(
                child: child,
              )
            ],
          ),
        ),
        color: MyColors().color1
    );
  }
}

class CustomScheduleCard extends StatelessWidget {
  const CustomScheduleCard({
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

class CustomWeatherCard extends StatelessWidget {
  const CustomWeatherCard({
    Key? key,
    required this.newWeather,
  }) : super(key: key);

  final FutureWeather newWeather;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomCard(
        title: 'Weather',
        child: FutureBuilder(
          future: newWeather.getCurrentWeather(),
          builder: (context, data){
            if (data.connectionState == ConnectionState.done && data.data != null){
              Map weather = data.data as Map;
              return Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: SvgPicture.asset(weather['icon'])),
                            Text(weather['main'], textAlign: TextAlign.center, style: MyTextStyle().large),
                            const SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('${weather['currentTemp']}°', textAlign: TextAlign.center, style: MyTextStyle().large),
                                const SizedBox(width: 10,),
                                Text('${weather['min']}°\n${weather['max']}°', textAlign: TextAlign.center, style: MyTextStyle().small)
                              ],
                            )
                          ],
                        ),
                      )
                  ),
                  const SizedBox(width: 10.0,),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: (weather['daily'] as List).length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 83.0, child: Text(weather['daily'][index]['day'], style: MyTextStyle().small)),
                              Flexible(child: SvgPicture.asset(weather['daily'][index]['icon'], width: 30,), fit: FlexFit.tight),
                              SizedBox(width: 25.0, child: Text('${weather['daily'][index]['min']}°', textAlign: TextAlign.end, style: MyTextStyle().small)),
                              SizedBox(width: 35.0, child: Text('${weather['daily'][index]['max']}°', textAlign: TextAlign.end, style: MyTextStyle().small)),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
            else {
              return Center(child: CircularProgressIndicator(color: MyColors().darkColor1,));
            }
          },
        ),
      ),
    );
  }
}

class CustomClockCard extends StatelessWidget {
  const CustomClockCard({
    Key? key,
    required this.newWeather,
  }) : super(key: key);

  final FutureWeather newWeather;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}