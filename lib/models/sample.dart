// @dart=2.9

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weather {
  final int max;
  final int min;
  final int current;
  final String name;
  final String day;
  final int wind;
  final int humidity;
  final int rainChance;
  final String image;
  final String time;
  final String location;

  Weather(
      {this.max,
      this.min,
      this.name,
      this.day,
      this.wind,
      this.humidity,
      this.rainChance,
      this.image,
      this.current,
      this.time,
      this.location});
}

String appId = "a088a02724c1946fb0baba3249b5e399";

Future<List> fetchData(String lat, String lon, String city) async {
  var url =
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId";
  var response = await http.get(Uri.parse(url));
  DateTime date = DateTime.now();
  if (response.statusCode == 200) {
    var res = json.decode(response.body);

    //Temperature Now
    var current = res["current"];
    Weather temperatureNow = Weather(
        current: current["temp"]?.round() ?? 0,
        name: current["weather"][0]["main"].toString(),
        day: DateFormat("EEEE dd MMMM").format(date),
        wind: current["wind_speed"]?.round() ?? 0,
        humidity: current["humidity"]?.round() ?? 0,
        rainChance: current["uvi"]?.round() ?? 0,
        location: city,
        image: findIcon(current["weather"][0]["main"].toString(), true));

    //Weather Today
    List<Weather> todayWeather = [];
    int hour = int.parse(DateFormat("hh").format(date));
    for (var i = 0; i < 4; i++) {
      var temp = res["hourly"];
      var hourly = Weather(
          current: temp[i]["temp"]?.round() ?? 0,
          image: findIcon(temp[i]["weather"][0]["main"].toString(), false),
          time: Duration(hours: hour + i + 1).toString().split(":")[0] + ":00");
      todayWeather.add(hourly);
    }

    //Weather Tomorrow
    var daily = res["daily"][0];
    Weather temperatureTomorrow = Weather(
        max: daily["temp"]["max"]?.round() ?? 0,
        min: daily["temp"]["min"]?.round() ?? 0,
        image: findIcon(daily["weather"][0]["main"].toString(), true),
        name: daily["weather"][0]["main"].toString(),
        wind: daily["wind_speed"]?.round() ?? 0,
        humidity: daily["rain"]?.round() ?? 0,
        rainChance: daily["uvi"]?.round() ?? 0);

    //Week's Weather
    List<Weather> weatherWeek = [];
    for (var i = 1; i < 8; i++) {
      String day = DateFormat("EEEE")
          .format(DateTime(date.year, date.month, date.day + i + 1))
          .substring(0, 3);
      var temp = res["daily"][i];
      var hourly = Weather(
          max: temp["temp"]["max"]?.round() ?? 0,
          min: temp["temp"]["min"]?.round() ?? 0,
          image: findIcon(temp["weather"][0]["main"].toString(), false),
          name: temp["weather"][0]["main"].toString(),
          day: day);
      weatherWeek.add(hourly);
    }
    return [temperatureNow, todayWeather, temperatureTomorrow, weatherWeek];
  }
  return [null, null, null, null];
}

//Icon Identifier
String findIcon(String name, bool type) {
  if (type) {
    switch (name) {
      case "Clouds":
        return "assets/cloudstate.png";
        break;
      case "Rain":
        return "assets/rainstate.png";
        break;
      case "Drizzle":
        return "assets/rainstate.png";
        break;
      case "Thunderstorm":
        return "assets/storm.png";
        break;
      case "Snow":
        return "assets/snowstate.png";
        break;
      default:
        return "assets/cloudstate.png";
    }
  } else {
    switch (name) {
      case "Clouds":
        return "assets/cloudstate_extended.png";
        break;
      case "Rain":
        return "assets/rainstate_extended.png";
        break;
      case "Drizzle":
        return "assets/rainstate_extended.png";
        break;
      case "Thunderstorm":
        return "assets/storm_extended.png";
        break;
      case "Snow":
        return "assets/snowstate_extended.png";
        break;
      default:
        return "assets/cloudstate_extended.png";
    }
  }
}

class CityModel {
  final String name;
  final String lat;
  final String lon;
  CityModel({this.name, this.lat, this.lon});
}

var cityJSON;

Future<CityModel> fetchCity(String cityName) async {
  if (cityJSON == null) {
    String link =
        "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json";
    var response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      cityJSON = json.decode(response.body);
    }
  }
  for (var i = 0; i < cityJSON.length; i++) {
    if (cityJSON[i]["name"].toString().toLowerCase() ==
        cityName.toLowerCase()) {
      return CityModel(
          name: cityJSON[i]["name"].toString(),
          lat: cityJSON[i]["latitude"].toString(),
          lon: cityJSON[i]["longitude"].toString());
    }
  }
  return null;
}
