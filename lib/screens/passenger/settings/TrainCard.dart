import 'package:flutter/material.dart';

class TrainCard {
  String sourceName;
  String destinationName;
  String startTime;
  String endTime;
  String durationTime;
  String trainName;
  String className;
  Icon trainIcon;
  int status;

  TrainCard(
      {required this.sourceName,
      required this.destinationName,
      required this.startTime,
      required this.endTime,
      required this.durationTime,
      required this.trainName,
      required this.className,
      this.trainIcon = const Icon(Icons.train, size: 50),
      required this.status});

  Text getStatus() {
    String statusText;
    Color color;
    if (status > 0) {
      statusText = "";
      color = Colors.green;
    } else if (status < 0) {
      statusText = "";
      color = Colors.brown;
    } else {
      statusText = "";
      color = Colors.purple;
    }

    return Text(statusText, style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: color
    ),);
  }
}
