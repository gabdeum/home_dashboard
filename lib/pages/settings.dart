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

  @override
  Widget build(BuildContext context) {
    GeoLoc newGeoLoc = GeoLoc(address: '125 rue Lamarck, Paris');
    newGeoLoc.getLoc();
    return Scaffold(
      backgroundColor: MyColors().bgColor,
      appBar: AppBar(
        title: Text('Settings', style: MyTextStyle().large,),
        centerTitle: true,
        backgroundColor: MyColors().color1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Weather & Clock', style: MyTextStyle().largeDark,),
            const SizedBox(height: 20.0,),
            Row(
              children: [
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
                        onPressed: () => addressController.clear(),
                      )
                    ),
                    keyboardType: TextInputType.streetAddress,
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(width: 10,),
                OutlinedButton(
                  child: Text('Enter', style: MyTextStyle().mediumDark,),
                  onPressed: (){},
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    primary: MyColors().darkColor1,
                    fixedSize: Size(100, 55)
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


