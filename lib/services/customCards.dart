import 'package:flutter/foundation.dart';
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
                  ),
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

//ignore: must_be_immutable
class CustomScheduleCard extends StatefulWidget {

  Schedule? newSchedule;
  CustomScheduleCard({Key? key, required this.newSchedule}) : super(key: key);

  @override
  State<CustomScheduleCard> createState() => _CustomScheduleCardState();
}

class _CustomScheduleCardState extends State<CustomScheduleCard> {

  @override
  void dispose() {
    // TODO: implement dispose
    widget.newSchedule?.timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CustomCard(
      title: 'Schedules',
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
        child: StreamBuilder(
            stream: widget.newSchedule?.stream,
            builder: (context, data){
              if(data.connectionState == ConnectionState.active){
                List newStreamList = data.data as List;
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount:newStreamList.length,
                    itemBuilder: (context, index){
                      String _message = '';
                      if(newStreamList[index]['time'] >= 0){_message = '${newStreamList[index]['time'].toString()} min';}
                      else if(newStreamList[index]['time'] == -1){_message = "Train a l'approche";}
                      else if(newStreamList[index]['time'] == -2){_message = 'Train a quai';}
                      else if(newStreamList[index]['time'] == -10){_message = 'No Data';}
                      return ListTile(
                        leading: SvgPicture.asset('assets/m${newStreamList[index]['line'].toString()}.svg', width: 40.0, height: 40.0,),
                        title: Text(newStreamList[index]['destination'].toString(), style: MyTextStyle().large,),
                        trailing: Text(_message, style: MyTextStyle().large),
                      );
                    });
              }
              else{
                return Center(child: CircularProgressIndicator(color: MyColors().darkColor1,));
              }
            }),
      ),);
  }
}

class CustomWeatherCard extends StatelessWidget {
  const CustomWeatherCard({
    Key? key,
    required this.newWeather,
  }) : super(key: key);

  final FutureWeather? newWeather;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomCard(
        title: 'Weather',
        child: FutureBuilder(
          future: newWeather?.getCurrentWeather(),
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
                            Expanded(child: SvgPicture.asset(weather['icon'].toString())),
                            Text(weather['main'].toString(), textAlign: TextAlign.center, style: MyTextStyle().large),
                            const SizedBox(height: 10.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('${weather['currentTemp'].toString()}°', textAlign: TextAlign.center, style: MyTextStyle().large),
                                const SizedBox(width: 10,),
                                Text('${weather['min'].toString()}°\n${weather['max'].toString()}°', textAlign: TextAlign.center, style: MyTextStyle().small)
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
                      itemCount: weather['daily'] != null ? (weather['daily'] as List).length : 0,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 83.0, child: Text(weather['daily']?[index]['day'], style: MyTextStyle().small)),
                              Flexible(child: SvgPicture.asset(weather['daily']?[index]['icon'], width: 30,), fit: FlexFit.tight),
                              SizedBox(width: 25.0, child: Text('${weather['daily']?[index]['min']}°', textAlign: TextAlign.end, style: MyTextStyle().small)),
                              SizedBox(width: 35.0, child: Text('${weather['daily']?[index]['max']}°', textAlign: TextAlign.end, style: MyTextStyle().small)),
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

  final FutureWeather? newWeather;

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
                    future: newWeather?.getCurrentWeather(),
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

//ignore: must_be_immutable
class CustomScheduleSettingCard extends StatefulWidget {

  Map scheduleData;

  CustomScheduleSettingCard({required this.scheduleData, Key? key}) : super(key: key); //'type' : 'metros', 'code' : null, 'station' : null, 'stationCode' : null, 'way' : null

  @override
  _CustomScheduleSettingCardState createState() => _CustomScheduleSettingCardState();
}

class _CustomScheduleSettingCardState extends State<CustomScheduleSettingCard> {

  final List<int> _lineNumber = [1,2,3,4,5,6,7,8,9,10,11,12,13,14];

  int? _lineSelection;
  Map? _stationSelection;
  bool _directionA = false;
  bool _directionR = false;

  List _stations = [];
  Map _directions = {};

  initializeData() async {
    if (widget.scheduleData['code'] != null && widget.scheduleData['station'] != null && widget.scheduleData['way'] != null){
      _lineSelection = widget.scheduleData['code'];
      if(widget.scheduleData['way'] == 'A+R'){_directionA = true; _directionR = true;}
      else if(widget.scheduleData['way'] == 'A'){_directionA = true;}
      else if(widget.scheduleData['way'] == 'R'){_directionR = true;}
      Schedule _newSchedule = Schedule(lineDetails: [{
        'type' : 'metros',
        'code' : widget.scheduleData['code']
      }]);
      await _newSchedule.getStations().then((value){_stations = value as List;});
      await _newSchedule.getDirections().then((value){_directions = value as Map;});

      _stations.forEach((element) {if(element['slug'] == widget.scheduleData['stationCode']){_stationSelection = element;}});

      setState(() {});
    }
  }

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 55.0,
          width: 190.0,
          child: DropdownButtonFormField(
            isDense: true,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide(color: MyColors().darkColor1, width: 2.0)
              ),
              labelText: 'Subway line',
              labelStyle: MyTextStyle().mediumDark,
              prefixIcon: Icon(Icons.directions_subway, color: MyColors().darkColor1,),
            ),
            value: _lineSelection,
            items: _lineNumber.map<DropdownMenuItem<int>>((value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('Line $value'),
              );
            }).toList(),
            onChanged: (int? _newValue) async {
              if(_stationSelection != null || _stations.isNotEmpty){
                setState(() {
                  _stationSelection = null;
                  _stations = [];
                });
              }
              Schedule _newSchedule = Schedule(lineDetails: [{
                'type' : 'metros',
                'code' : _newValue
              }]);
              _stations = await _newSchedule.getStations() as List;
              _directions = await _newSchedule.getDirections() as Map;
              setState(() {
                _lineSelection = _newValue!;
                _directionA = false;
                _directionR = false;
              });
            },
          ),
        ),
        const SizedBox(height: 20.0,),
        (_lineSelection == null) ? Container(height: 0.0,) :
        SizedBox(
          height: 55.0,
          width: 370.0,
          child: DropdownButtonFormField(
            isDense: true,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40.0),
                  borderSide: BorderSide(color: MyColors().darkColor1, width: 2.0)
              ),
              labelText: 'Station',
              labelStyle: MyTextStyle().mediumDark,
              prefixIcon: Icon(Icons.directions, color: MyColors().darkColor1,),
            ),
            value: _stationSelection,
            items: _stations.map<DropdownMenuItem<Map>>((value) {
              return DropdownMenuItem<Map>(
                value: value,
                child: Text(_truncateWithEllipsis(28, value['name'])),
              );
            }).toList(),
            onChanged: (Map? _newValue) async {
              setState(() {
                _stationSelection = _newValue!;
                widget.scheduleData['code'] = _lineSelection;
                widget.scheduleData['station'] = _stationSelection?['name'];
                widget.scheduleData['stationCode'] = _stationSelection?['slug'];
              });
            },
          ),
        ),
        const SizedBox(height: 10.0,),
        (_lineSelection == null) ? Container(height: 0.0,) :
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                  activeColor: MyColors().color1,
                  title: Text(_directions['A'] ??= ''),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _directionA,
                  onChanged: (bool? value){
                    setState(() {
                      _directionA = value!;
                      if(_directionA && _directionR){widget.scheduleData['way'] = 'A+R';}
                      else if(_directionA && !_directionR){widget.scheduleData['way'] = 'A';}
                      else if(!_directionA && _directionR){widget.scheduleData['way'] = 'R';}
                      else {widget.scheduleData['way'] = '';}
                    });
                  }
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                  activeColor: MyColors().color1,
                  title: Text(_directions['R'] ??= ''),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _directionR,
                  onChanged: (bool? value){
                    setState(() {
                      _directionR = value!;
                      if(_directionA && _directionR){widget.scheduleData['way'] = 'A+R';}
                      else if(_directionA && !_directionR){widget.scheduleData['way'] = 'A';}
                      else if(!_directionA && _directionR){widget.scheduleData['way'] = 'R';}
                      else {widget.scheduleData['way'] = '';}
                    });
                  }
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Add '...' if String length >= value
String _truncateWithEllipsis(int cutoff, String myString) {

  return myString.length >= cutoff ? myString.replaceRange(cutoff, myString.length, '...') : myString;

}