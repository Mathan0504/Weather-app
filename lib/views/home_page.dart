// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:weather_app/models/sample.dart';
import 'package:weather_app/models/weather_detail.dart';
import 'package:weather_app/views/weather_view.dart';

Weather temperatureNow;
Weather temperatureTomorrow;
List<Weather> weatherToday;
List<Weather> weatherWeek;
String lat = "6.93106260";
String lon = "79.97944220";
String city = "Kaduwela";

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  getData() async {
    fetchData(lat, lon, city).then((value) {
      temperatureNow = value[0];
      weatherToday = value[1];
      temperatureTomorrow = value[2];
      weatherWeek = value[3];
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: temperatureNow == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [WeatherNow(getData), WeatherToday()],
            ),
    );
  }
}

class WeatherNow extends StatefulWidget {
  final Function() updateData;
  WeatherNow(this.updateData);

  @override
  State<WeatherNow> createState() => _WeatherNowState();
}

class _WeatherNowState extends State<WeatherNow> {
  bool searchBar = false;
  bool updating = false;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (searchBar)
          setState(() {
            searchBar = false;
          });
      },
      child: GlowContainer(
        height: MediaQuery.of(context).size.height - 250,
        margin: EdgeInsets.all(1),
        padding: EdgeInsets.only(top: 50, left: 35, right: 35),
        glowColor: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.1),
            bottomRight: Radius.circular(0.1)),
        color: Colors.black,
        spreadRadius: 5,
        child: Column(
          children: [
            Container(
              child: searchBar
                  ? TextField(
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: Colors.black,
                        filled: true,
                        hintText: 'Search a City',
                        hintStyle: TextStyle(color: Colors.white54),
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) async {
                        CityModel temp = await fetchCity(value);
                        if (temp == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  title: Text("The City is not available"),
                                  content: Text("Please try again"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Okay"))
                                  ],
                                );
                              });
                          searchBar = false;
                          return;
                        }
                        city = temp.name;
                        lat = temp.lat;
                        lon = temp.lon;
                        updating = true;
                        setState(() {});
                        widget.updateData();
                        searchBar = false;
                        updating = false;
                        setState(() {});
                      },
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.expand_more_rounded,
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            Icon(CupertinoIcons.map_pin_ellipse,
                                color: Colors.white),
                            GestureDetector(
                              onTap: () {
                                searchBar = true;
                                setState(() {});
                                focusNode.requestFocus();
                              },
                              child: Text(
                                " " + city,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.expand_more_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
            ),
            Container(
              height: 385,
              child: Stack(
                children: [
                  Image(
                    image: AssetImage(temperatureNow.image),
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Column(
                        children: [
                          GlowText(
                            temperatureNow.current.toString(),
                            style: TextStyle(
                                height: 1.0,
                                fontSize: 120,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            temperatureNow.name,
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                          Text(
                            temperatureNow.day,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              height: 35,
            ),
            SizedBox(
              height: 2,
            ),
            WeatherDetail(temperatureNow)
          ],
        ),
      ),
    );
  }
}

class WeatherToday extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weather Today",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return WeatherView(temperatureTomorrow, weatherWeek);
                  }));
                },
                child: Row(
                  children: [
                    Text(
                      "+ 7 Days",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.grey,
                      size: 15,
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.only(
              bottom: 30,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherWidget(weatherToday[0]),
                  WeatherWidget(weatherToday[1]),
                  WeatherWidget(weatherToday[2]),
                  WeatherWidget(weatherToday[3]),
                ]),
          )
        ],
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  final Weather weather;

  WeatherWidget(this.weather);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
          border: Border.all(width: 0.3, color: Colors.white),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          Text(
            weather.current.toString() + "\u00B0",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 6,
          ),
          Image(
            image: AssetImage(weather.image),
            width: 50,
            height: 50,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            weather.time,
            style: TextStyle(fontSize: 17, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
