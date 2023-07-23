import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/sample.dart';

class WeatherDetail extends StatelessWidget {
  final Weather temp;
  WeatherDetail(this.temp);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Icon(
              CupertinoIcons.wind,
              color: Colors.white,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              temp.humidity.toString() + " km/h ",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Wind",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            )
          ],
        ),
        Column(
          children: [
            Icon(
              CupertinoIcons.drop,
              color: Colors.white,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              temp.humidity.toString() + " %",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              "Humidity",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            )
          ],
        ),
        Column(
          children: [
            Icon(
              CupertinoIcons.cloud_heavyrain,
              color: Colors.white,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              temp.rainChance.toString() + " %",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Rain",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            )
          ],
        )
      ],
    );
  }
}
