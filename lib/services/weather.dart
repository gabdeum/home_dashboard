import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class FutureWeather {

  double lat;
  double lon;
  int gmt;

  FutureWeather({required this.lat, required this.lon, this.gmt = 0});

  String apiKey = '38f6f9718ff7894f7302be8b33cd3a22';
  Map weatherIcons = {
    '01d' : 'clear-day.svg',
    '01n' : 'clear-night.svg',
    '02d' : 'partly-cloudy-day.svg',
    '02n' : 'partly-cloudy-night.svg',
    '03d' : 'cloudy.svg',
    '03n' : 'cloudy.svg',
    '04d' : 'extreme.svg',
    '04n' : 'extreme.svg',
    '09d' : 'rain.svg',
    '09n' : 'rain.svg',
    '10d' : 'partly-cloudy-night-rain.svg',
    '10n' : 'partly-cloudy-night.svg',
    '11d' : 'thunderstorms-day.svg',
    '11n' : 'thunderstorms-night.svg',
    '13d' : 'snow.svg',
    '13n' : 'snow.svg',
    '50d' : 'mist.svg',
    '50n' : 'mist.svg'
  };

  Future getCurrentWeather() async {

    String _url = 'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly,alerts&units=metric&appid=$apiKey';
    Map weather = {};

    try {
      Response _response = await get(Uri.parse(_url));

      Map _data = const JsonDecoder().convert(_response.body);

      List _daily = [];
      List _dailyData = _data['daily'] as List;

      List _daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

      for (int i = 1; i < _dailyData.length; i++){

        String _day = _daysOfWeek[DateTime.fromMillisecondsSinceEpoch(_dailyData[i]['dt'] * 1000).toUtc().weekday - 1];

        Map _dailyWeather = {
          'day' : _day,
          'icon' : 'assets/${weatherIcons['${_dailyData[i]['weather'][0]['icon']}']}',
          'min' : (_dailyData[i]['temp']['min'] as double).round().toString(),
          'max' : (_dailyData[i]['temp']['max'] as double).round().toString()
        };

        _daily.add(_dailyWeather);

      }

      final DateFormat dtFormat = DateFormat.jm();

      String _sunrise = dtFormat.format(DateTime.fromMillisecondsSinceEpoch(_data['current']['sunrise'] * 1000).toUtc().add(Duration(hours: gmt)));
      String _sunset = dtFormat.format(DateTime.fromMillisecondsSinceEpoch(_data['current']['sunset'] * 1000).toUtc().add(Duration(hours: gmt)));

      weather = {
        'main' : convertToTitleCase(_data['current']['weather'][0]['main'].toString()),
        'description' : convertToTitleCase(_data['current']['weather'][0]['description'].toString()),
        'currentTemp' : (_data['current']['temp'] as double).round().toString(),
        'min' : (_data['daily'][0]['temp']['min'] as double).round().toString(),
        'max' : (_data['daily'][0]['temp']['max'] as double).round().toString(),
        'icon' : 'assets/${weatherIcons['${_data['current']['weather'][0]['icon']}']}',
        'sunrise' : _sunrise,
        'sunset' : _sunset,
        'daily' : _daily,
      };
    }

    catch (e){
      print(e);
    }

    return weather;

  }

}


String? convertToTitleCase(String? text) {
  if (text == null) {
    return null;
  }

  if (text.length <= 1) {
    return text.toUpperCase();
  }

  // Split string into multiple words
  final List<String> words = text.split(' ');

  // Capitalize first letter of each words
  final capitalizedWords = words.map((word) {
    if (word.trim().isNotEmpty) {
      final String firstLetter = word.trim().substring(0, 1).toUpperCase();
      final String remainingLetters = word.trim().substring(1);

      return '$firstLetter$remainingLetters';
    }
    return '';
  });

  // Join/Merge all words back to one String
  return capitalizedWords.join(' ');
}