import 'package:flutter/material.dart';
import 'package:home_dashboard/services/customCards.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void getSharedPreferences() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final double lat = prefs.getDouble('lat') ?? 0.0;
    final double lon = prefs.getDouble('lon') ?? 0.0;
    final List<String> scheduleDataStr = prefs.getStringList('scheduleData') ?? [];

    List<Map> scheduleData = [];

    for (var element in scheduleDataStr){
      Map _scheduleData = {};

      try{
        _scheduleData = json.decode(element);
      }

      catch(e){
        print(e);
      }

      scheduleData.add(_scheduleData);

    }

    print('lat: $lat - lon: $lon - scheduleData: $scheduleData');

    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'lat' : lat,
      'lon' : lon,
      'scheduleData' : scheduleData
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    getSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                child: CustomCard(title: 'Schedules', child: Container(),)
              ),
              const SizedBox(height: 2.5,),
              Flexible(
                flex: 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: CustomCard(title: 'Weather', child: Container(),)),
                    const SizedBox(width: 2.5,),
                    Expanded(child: CustomCard(title: 'Clock', child: Container(),)),
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
