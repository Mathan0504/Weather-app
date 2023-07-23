import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:weather_app/models/sample.dart';
import 'package:weather_app/models/weather_detail.dart';

class WeatherView extends StatelessWidget {
  final Weather temperatureTomorrow;
  final List<Weather> weatherWeek;

  WeatherView(this.temperatureTomorrow, this.weatherWeek);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [WeatherTomorrow(temperatureTomorrow), Week(weatherWeek)],
      ),
    );
  }
}

class WeatherTomorrow extends StatelessWidget {
  final Weather temperatureTomorrow;
  WeatherTomorrow(this.temperatureTomorrow);

  @override
  Widget build(BuildContext context) {
    return GlowContainer(
      color: Colors.black,
      glowColor: Colors.white,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.1), bottomRight: Radius.circular(0.1)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 50, right: 30, left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    Text(
                      " This Week", //Weather this week text
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.white,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.3,
                  height: MediaQuery.of(context).size.width / 2.3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(temperatureTomorrow.image))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Tomorrow:",
                      style: TextStyle(fontSize: 25, height: 0.1),
                    ),
                    Container(
                      height: 105,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GlowText(
                            temperatureTomorrow.max.toString(),
                            style: TextStyle(
                                fontSize: 100, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "/" + temperatureTomorrow.min.toString() + "\u00B0",
                            style: TextStyle(
                                color: Colors.white70.withOpacity(0.3),
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      " " + temperatureTomorrow.name,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 20,
              right: 50,
              left: 50,
            ),
            child: Column(
              children: [
                Divider(
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                WeatherDetail(temperatureTomorrow)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Week extends StatelessWidget {
  List<Weather> weatherWeek;
  Week(this.weatherWeek);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: weatherWeek.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      weatherWeek[index].day,
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      width: 135,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image(
                            image: AssetImage(weatherWeek[index].image),
                            width: 40,
                          ),
                          SizedBox(width: 15),
                          Text(
                            weatherWeek[index].name,
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "+" + weatherWeek[index].max.toString() + "\u00B0",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "+" + weatherWeek[index].min.toString() + "\u00B0",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ));
          }),
    );
  }
}
