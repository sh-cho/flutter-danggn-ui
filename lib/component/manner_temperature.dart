import 'package:flutter/material.dart';

class MannerTemperature extends StatelessWidget {
  final double temperature;
  final List<Color> temperatureColors = const [
    Color(0xff072038),
    Color(0xff0d3a65),
    Color(0xff186ec0),
    Color(0xff37b24d),
    Color(0xffffad13),
    Color(0xfff76707),
  ];

  const MannerTemperature(this.temperature, {Key? key}) : super(key: key);

  int get level {
    if (temperature <= 20) {
      return 0;
    } else if (temperature <= 32) {
      return 1;
    } else if (temperature <= 36.5) {
      return 2;
    } else if (temperature <= 40) {
      return 3;
    } else if (temperature <= 50) {
      return 4;
    }

    return 5;
  }

  Widget _temperatureLabelAndBar() {
    return Container(
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$temperature℃",
            style: TextStyle(
              color: temperatureColors[level],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 6,
              color: Colors.black.withOpacity(0.2),
              child: Row(
                children: [
                  Container(
                    height: 6,
                    width: 60 / 99 * temperature,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _temperatureLabelAndBar(),
            Container(
              margin: const EdgeInsets.only(left: 7),
              width: 30,
              height: 30,
              child: Image.asset("assets/images/level-${level}.jpg"),
            ),
          ],
        ),
        Text(
          "매너 온도",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            decoration: TextDecoration.underline,
          ),
        )
      ],
    );
  }
}
