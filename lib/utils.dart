import "package:flutter/material.dart";

void showSnackBar(BuildContext context, String message) {
  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
  ));
}

String minutesToTime(int minutes) {
  var hours = (minutes / 60).floor();
  var mins = minutes % 60;

  return "${hours.toString().padLeft(2, "0")}:${mins.toString().padLeft(2, "0")}";
}

String minutesToDuration(int minutes) {
  var hours = (minutes / 60).floor();
  var mins = minutes % 60;

  return "${hours}h ${mins}m";
}
