import 'package:flutter/material.dart';
import 'package:home_dashboard/services/geoLocator.dart';
import 'package:home_dashboard/services/formatClasses.dart';

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
    print(_newLoc);
    return Scaffold(
      backgroundColor: MyColors().bgColor,
      appBar: AppBar(
        title: Text('Settings', style: MyTextStyle().large,),
        centerTitle: true,
        backgroundColor: MyColors().color1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
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
                  Container(
                    constraints: const BoxConstraints(maxWidth: 400),
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
                          labelText: 'Address',
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
                  const SizedBox(height: 15.0,),
                  _newLoc.isEmpty ? Container(width: 0,) : ListTile(
                    leading: Icon(Icons.check_circle, color: MyColors().darkColor1,),
                    title: Text(_newLoc['fullName'], style: MyTextStyle().mediumDark,),
                    subtitle: Text('Lat: ${(_newLoc['lat'] as double).toStringAsFixed(2)}, Lon: ${(_newLoc['lon'] as double).toStringAsFixed(2)}', style: MyTextStyle().smallDark),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


