import 'package:flutter/material.dart';
import 'dart:async';

import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wave_image/wave_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   final player = AudioPlayer();
  PermissionStatus _locationStatus = PermissionStatus.denied;
  List<Position> _positions = [];
  double _distancesum = 0.0;
  int time = 0;
  List<double>? _userAccelerometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  int steps = 0;
  String statas = "Stop";
  bool flagspeed = false;
  double average = 0.0;
  bool isNear = false;
  Timer? timer;
  Timer? timer2;
  List<String>? userAccelerometer = ["0.0", "0.0", "0.0"];
    Color color = Color.fromARGB(234, 208, 236, 242);


  Future<void> detectObject() async {
    ProximitySensor.events.listen((int event) {
      if (event != 0) {
        isNear = true;
        soundEffect();
      } else {
        isNear = false;
      }
    });
  }

  void soundEffect() {
    player.play(AssetSource('sounds/near.wav'));
  }

  void _addPosition(Position position) {
    setState(() {
      _positions.add(position);
      if (_positions.length >= 2) {
        Position previousPosition = _positions[_positions.length - 2];
        double distanceInMeters = Geolocator.distanceBetween(
          previousPosition.latitude,
          previousPosition.longitude,
          position.latitude,
          position.longitude,
        );
        _distancesum += distanceInMeters;
      }
    });
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 5));
    _addPosition(position);
    // time += 5;
  }

  @override
  void initState() {
    super.initState();
    getLocationStatus();
    detectObject();
    stepsfun();
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  Future<PermissionStatus> getLocationStatus() async {
    // Request for permission
    // #4
    final status = await Permission.location.request();
    final status2 = await Permission.activityRecognition.request();
    // change the location status
    // #5
    _locationStatus = status;

    // notify listeners
    return status;
  }

  void stepsfun() {
    timer2 = Timer.periodic(Duration(milliseconds: 700), (timer) {
      double ass = userAccelerometer == null
          ? 0
          : sqrt(pow(double.parse(userAccelerometer![0]), 2) +
              pow(double.parse(userAccelerometer![1]), 2) +
              pow(double.parse(userAccelerometer![2]), 2));
      if (ass > 2.6 &&
          double.parse(userAccelerometer![1]) <
              double.parse(userAccelerometer![0]) +
                  double.parse(userAccelerometer![2])) {
        if (ass > 7) {
          statas = "Running";
        } else {
          statas = "Walking";
        }
        setState(() {
          steps++;
        });
      } else {
        if (double.parse(userAccelerometer![1]) >
            double.parse(userAccelerometer![0]) +
                double.parse(userAccelerometer![2])) {
          statas = "Jugging";
        } else {
          statas = "Stop";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // sleep(Duration(seconds: 1));

    userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.only(top: 30, left: 30, bottom: 20),
              child: Row(
                children: [
                  Text(
                    "Training",
                    style: TextStyle(
                        fontSize: 30,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              height: 220,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(204, 91, 152, 166),
                    Color.fromARGB(230, 208, 236, 242),
                  ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(80)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(5, 10),
                        blurRadius: 20,
                        color: Color.fromARGB(51, 0, 0, 0))
                  ]),
              child: Container(
                padding: EdgeInsets.only(left: 20, top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Avg. speed",
                      style: TextStyle(
                          fontSize: 24, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${average.toStringAsFixed(1)} m/s',
                        style: TextStyle(
                            fontSize: 48,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold)
                        // textAlign: TextAlign.center,
                        ),
                    SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        children: [
                          FloatingActionButton(
                              backgroundColor: color,
                              child: !flagspeed
                                  ? Icon(Icons.play_arrow)
                                  : Icon(Icons.stop),
                              onPressed: getlocation),
                          Container(
                            padding: EdgeInsets.only(left: 200),
                            child: Text(
                              time.toString() + " s",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 18,
              width: 10,
            ),
            Container(
              padding: EdgeInsets.only(top: 30, left: 30, bottom: 20),
              child: Row(
                children: [
                  Text(
                    "Activity",
                    style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.33,
              child: Card(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    borderSide:
                        BorderSide(color: Color.fromARGB(204, 160, 206, 217))),
                color: Color.fromARGB(204, 160, 206, 217),
                elevation: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(children: [
                        statas == "Stop"
                            ? Icon(Icons.person_2, size: 150)
                            : statas == "Walking"
                                ? Icon(Icons.directions_walk_outlined,
                                    size: 150)
                                : statas == "Jugging"
                                    ? Icon(Icons.airline_stops_rounded,
                                        size: 150)
                                    : Icon(Icons.directions_run, size: 150),
                        Text(
                          "Steps: ${steps}",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            statas,
                            style: TextStyle(
                                fontSize: 24,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getlocation() {
    setState(() {
      flagspeed = !flagspeed;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        time++;
      });
      if (flagspeed) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 5));
        _addPosition(position);
      } else {
        timer.cancel();
      }
      if (time == 31) {
        setState(() {
          average = _distancesum / 30;
          print(average);
          time = 0;
          _distancesum = 0;
        });
      }
    });
  }

}