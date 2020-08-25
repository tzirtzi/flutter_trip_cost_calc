import 'package:flutter/material.dart';
import 'package:trip_cost_calculator/fuelform.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip cost calculator',
      home: new FuelForm(),
    );
  }
}

