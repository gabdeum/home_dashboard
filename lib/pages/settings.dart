import 'package:flutter/material.dart';
import 'package:home_dashboard/services/geoLocator.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeoLoc newGeoLoc = GeoLoc(address: '125 rue Lamarck, Paris');
    newGeoLoc.getLatLon();
    return Container();
  }
}


