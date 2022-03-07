import 'package:flutter/material.dart';
import 'package:home_dashboard/services/geoLocator.dart';
import 'package:home_dashboard/services/formatClasses.dart';
import 'package:geolocator/geolocator.dart';

class Settings extends StatefulWidget {


  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final addressController = TextEditingController();
  Map _newLoc = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: MyColors().bgColor,
      appBar: AppBar(
        title: Text('Settings', style: MyTextStyle().large,),
        centerTitle: true,
        backgroundColor: MyColors().color1,
      ),
      body: SingleChildScrollView(
        physics: const  ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Transport schedules', style: MyTextStyle().largeDark,),
                    const SizedBox(height: 20.0,),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: TextField(
                        // controller: addressController,
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40.0),
                                borderSide: BorderSide(color: MyColors().darkColor1, width: 2.0)
                            ),
                            hintText: 'Line 13',
                            hintStyle: MyTextStyle().mediumDark,
                            labelText: 'Line number',
                            labelStyle: MyTextStyle().mediumDark,
                            prefixIcon: Icon(Icons.location_pin, color: MyColors().darkColor1,),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close, color: MyColors().darkColor1,),
                              onPressed: () {
                                // addressController.clear();
                                _newLoc = {};
                                setState(() {});
                              },
                            )
                        ),
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (address) async {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30.0,),
              Expanded(
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
                            controller: addressController,
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
                                    addressController.clear();
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
                          onPressed: () async {
                            Position newPosition = await _determinePosition();
                            _newLoc = await GeoLoc(latitude: newPosition.latitude, longitude: newPosition.longitude).getLocFromLatLong();
                            setState(() {});
                          },
                          child: Icon(Icons.location_searching, color: MyColors().textColor,),
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