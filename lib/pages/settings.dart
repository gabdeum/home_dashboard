import 'package:flutter/material.dart';
import 'package:home_dashboard/services/customCards.dart';
import 'package:home_dashboard/services/geoLocator.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

//ignore: must_be_immutable
class Settings extends StatefulWidget {

  Map settingsData;

  Settings({this.settingsData = const {}, Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final _addressController = TextEditingController();
  Map _newLoc = {};
  Map settingsData = {};
  dynamic _iconSearchLocation = Icon(Icons.location_searching, color: MyColors().textColor,);

  List<Widget> scheduleSettingCards = [];

  void setSharedPreferences(double lat, double lon, List<Map> scheduleData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('lat', lat);
    prefs.setDouble('lon', lon);

    List<String> scheduleDataStr = [];
    for (var element in scheduleData){
      scheduleDataStr.add(json.encode(element));
    }

    prefs.setStringList('scheduleData', scheduleDataStr);
  }

  initializeLocation() async {
    _newLoc = await GeoLoc(latitude: widget.settingsData['lat'], longitude: widget.settingsData['lon']).getLocFromLatLong();
    setState(() {});
  }

  @override
  void initState() {
    if(widget.settingsData['scheduleData'] is List){
      List<Map> scheduleData = widget.settingsData['scheduleData'];
      for (var element in scheduleData) {
        scheduleSettingCards.add(const SizedBox(height: 20.0,),);
        scheduleSettingCards.add(CustomScheduleSettingCard(scheduleData: element,));
      }
    }
    else {
      scheduleSettingCards = [CustomScheduleSettingCard(scheduleData: {'type' : 'metros', 'code' : null, 'station' : null, 'stationCode' : null, 'way' : null})];
    }
    scheduleSettingCards.add(const SizedBox(height: 10.0,));
    scheduleSettingCards.add(
      Center(child: FloatingActionButton(
        elevation: 0.0,
        onPressed: (){
          setState(() {
            scheduleSettingCards.insertAll(scheduleSettingCards.length-2, [
              const SizedBox(height: 20.0,),
              CustomScheduleSettingCard(scheduleData: {'type' : 'metros', 'code' : null, 'station' : null, 'stationCode' : null, 'way' : null})
            ]);
          });
        },
        child: const Icon(Icons.add),
        backgroundColor: MyColors().color1,
      )),
    );

    initializeLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        List<Map> _scheduleData = [];
        for (var element in scheduleSettingCards) {
          if (element is CustomScheduleSettingCard){
            _scheduleData.add(element.scheduleData);
          }
        }
        Map _settingsData = {
          "lat" : _newLoc['lat'] ?? 0.0,
          "lon" : _newLoc['lon'] ?? 0.0,
          "scheduleData" : _scheduleData
        };
        setSharedPreferences(_newLoc['lat'] ?? 0.0, _newLoc['lon'] ?? 0.0, _scheduleData);

        Navigator.pop(context, _settingsData);
        return true;
      },
      child: Scaffold(
        backgroundColor: MyColors().bgColor,
        appBar: AppBar(
          title: Text('Settings', style: MyTextStyle().large,),
          centerTitle: true,
          backgroundColor: MyColors().color1,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Transport schedules', style: MyTextStyle().largeDark,),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: scheduleSettingCards.length,
                        itemBuilder: (context, index){
                          return Stack(
                            children: [
                              (index == 1 || scheduleSettingCards[index] is !CustomScheduleSettingCard) ? Container(height: 0.0,) :
                              Positioned(top: 1.0, right: 1.0, child: SizedBox(
                                height: 33.0,
                                width: 33.0,
                                child: TextButton(
                                  onPressed: (){setState(() {scheduleSettingCards.removeAt(index);});},
                                  child: Center(child: Icon(Icons.clear,size: 17, color: MyColors().darkColor1,)),
                                  style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        side: BorderSide(color: MyColors().darkColor1, width: 2.0),
                                      ),
                                  ),
                                ),
                              )),
                              scheduleSettingCards[index],
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30.0,),
              Expanded(
                child: SingleChildScrollView(
                  physics: const  ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Weather & Clock', style: MyTextStyle().largeDark,),
                      const SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40.0),
                                      borderSide: BorderSide(color: MyColors().darkColor1, width: 2.0)
                                  ),
                                  hintText: '125 rue Lamarck, Paris',
                                  hintStyle: MyTextStyle().mediumDark,
                                  labelText: 'Enter address manually',
                                  labelStyle: MyTextStyle().mediumDark,
                                  prefixIcon: Icon(Icons.location_pin, color: MyColors().darkColor1,),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.close, color: MyColors().darkColor1,),
                                    onPressed: () {
                                      _addressController.clear();
                                      _newLoc = {};
                                      setState(() {});
                                    },
                                  )
                              ),
                              keyboardType: TextInputType.streetAddress,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (address) async {
                                _newLoc = await GeoLoc(address: address.toString()).getLoc();
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 10.0,),
                          FloatingActionButton(
                            heroTag: 'hero2',
                            onPressed: () async {
                              setState(() {
                                _iconSearchLocation = SizedBox(
                                  child: CircularProgressIndicator(color: MyColors().textColor, strokeWidth: 2.0,),
                                  width: 18.0,
                                  height: 18.0,
                                );
                              });
                              Position newPosition = await _determinePosition();
                              _newLoc = await GeoLoc(latitude: newPosition.latitude, longitude: newPosition.longitude).getLocFromLatLong();
                              setState(() {_iconSearchLocation = Icon(Icons.location_searching, color: MyColors().textColor,);});
                            },
                            child: _iconSearchLocation,
                            backgroundColor: MyColors().color1,
                            elevation: 0.0,
                          )
                        ],
                      ),
                      const SizedBox(height: 15.0,),
                      _newLoc.isEmpty ? Container(width: 0,) : ListTile(
                        leading: Icon(_newLoc['leading'], color: MyColors().darkColor1,),
                        title: Text(_newLoc['fullName'], style: MyTextStyle().mediumDark,),
                        subtitle: _newLoc['lat'] is double ? Text('Lat: ${(_newLoc['lat'] as double).toStringAsFixed(2)}, Lon: ${(_newLoc['lon'] as double).toStringAsFixed(2)}', style: MyTextStyle().smallDark) : null,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  /// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
