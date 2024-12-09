import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/settings/train_card.dart";

class SettingsPage {
  static TrainCard trainCardExample1 = TrainCard(sourceName: "Riyadh", destinationName: "Dammam", startTime: "09:45", endTime: "10:50", durationTime: "1h 05m", trainName: "Train #1", className: "VIP", status: 1);
  static TrainCard trainCardExample2 = TrainCard(sourceName: "Riyadh", destinationName: "Qassim", startTime: "12:45", endTime: "15:50", durationTime: "3h 05m", trainName: "Train #3", className: "Ecconamy", status: 0);
  static TrainCard trainCardExample3 = TrainCard(sourceName: "Dammam", destinationName: "Jeddah", startTime: "09:45", endTime: "10:50", durationTime: "1h 05m", trainName: "Train #1", className: "VIP", status: -1);
  static Widget to_Settings(BuildContext context) {
    return SingleChildScrollView(
      // This scrolls the overall content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 8, 0, 8),
            child: Text(
              "My Coming Trips",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      costumSizedBox(),
                      trainCardWidget(context, trainCardExample1),
                      costumSizedBox(),
                      trainCardWidget(context, trainCardExample2),
                      costumSizedBox(),
                      trainCardWidget(context, trainCardExample3),
                      costumSizedBox(),
                      trainCardWidget(context, trainCardExample1),
                      costumSizedBox(),
                      trainCardWidget(context, trainCardExample2),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildOptionsSection(String title, IconData icon, BuildContext context) {
    return ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
        onTap: () {});
  }

  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners
      ),
      elevation: 5, // Shadow effect
      margin: const EdgeInsets.all(10), // Margin around the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Colors.blueAccent, // Title background color
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: const Text(
              "title",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(), // Content (you can pass any widget here)
          ),
        ],
      ),
    );
  }

  static Widget trainCardWidget(BuildContext context, TrainCard trainCard) {
    return (Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            offset: const Offset(5, 5), // Shadow position (x, y)
            blurRadius: 10, // Blur radius
            spreadRadius: 2, // Spread radius
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Adjust the radius for a smoother curve
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                trainCard.trainIcon,
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          trainCard.sourceName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Icon(
                          Icons.arrow_right_alt_rounded,
                          size: 80,
                        ),
                        Text(
                          trainCard.destinationName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                    Row(
                      children: [Text(trainCard.startTime), const Icon(Icons.arrow_right_alt_rounded), Text(trainCard.endTime)],
                    ),
                    Row(
                      children: [const Text("Duration:"), Text(trainCard.durationTime)],
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(trainCard.trainName),
                Text(trainCard.className),
                trainCard.getStatus(),
                const Text(
                  "80\nSAR",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }

  static Widget costumSizedBox() {
    return const SizedBox(
      height: 15,
    );
  }
}
