import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_dashboard/services/formatClasses.dart';

class Clock extends StatefulWidget {
  const Clock({Key? key}) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {

  MinuteHourTwoDigits? nowFormated;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final DateTime _now = DateTime.now();
    nowFormated = MinuteHourTwoDigits(_now);

    Timer.periodic(const Duration(seconds: 5), (t) {
      final DateTime _now = DateTime.now();
      if (nowFormated?.minute != MinuteHourTwoDigits(_now).minute){
        setState(() {
          nowFormated = MinuteHourTwoDigits(_now);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${nowFormated?.hour}:${nowFormated?.minute}', style: MyTextStyle().clock,),
            RotatedBox(child: Text('${nowFormated?.period}', style: MyTextStyle().large,), quarterTurns: 3,)
          ],
        ),
    );
  }
}

class MinuteHourTwoDigits {

  DateTime now;
  String? minute;
  String? hour;
  String? period;

  MinuteHourTwoDigits(this.now){

    if(now.minute.toString().length <= 1) {
      minute = '0${now.minute.toString()}';
    }
    else {
      minute = now.minute.toString();
    }
    if(now.hour >= 12) {
      period = 'PM';
      if(now.hour >= 13){
        hour = (now.hour - 12).toString();
      }
      else{
        hour = now.hour.toString();
      }
    }
    else {
      period = 'AM';
      hour = now.hour.toString();
    }
  }
}