import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sportapp/start.dart';
import 'package:wave_image/wave_image.dart';

void main() {
  runApp(SportApp());
}

class SportApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: ThemeData(
            // appBarTheme: AppBarTheme(color: color),
            scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255)),
        home: const StartScren());
  }
}
