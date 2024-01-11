import 'package:flutter/material.dart';
import 'package:sportapp/home.dart';

class StartScren extends StatefulWidget {
  const StartScren({super.key});

  @override
  State<StartScren> createState() => _StartScrenState();
}

class _StartScrenState extends State<StartScren> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Revitalize your existence',
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/Simage.png',
                  height: 800,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Revitalize your existence',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'To thrive in life, Embrace wellness and be sublime.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
