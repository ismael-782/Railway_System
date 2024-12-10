import 'package:flutter/material.dart';
import 'package:railway_system/data/booking_card_data.dart';
import 'package:railway_system/data/train_card_data.dart';
import 'package:railway_system/utils.dart';

class TrainStationReportCard extends StatelessWidget {
  final TrainCardData trainCardData;

  const TrainStationReportCard({super.key, required this.trainCardData});

  @override
  Widget build(BuildContext context) {
    // Sample data for the train path (replace with your query result from the database)
    List<String> trainPath = [
      "Station 1",
      "Station 2",
      "Station 3",
      "Station 4",
      "Station 5",
      "Station 6",
      "Station 7",
      "Station 8",
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/railway.png",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  "Train #${trainCardData.trainID}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(width: 10), // Add spacing between image and path
            Expanded(
              child: Column(
                children: [
                  Container(
                    child: Wrap(
                      spacing: 8.0, // Horizontal space between items
                      runSpacing: 4.0, // Vertical space between lines
                      children: _buildTrainPathWithArrows(trainPath),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the list of stations with arrows in between
  List<Widget> _buildTrainPathWithArrows(List<String> trainPath) {
    List<Widget> pathWidgets = [];
    for (int i = 0; i < trainPath.length; i++) {
      pathWidgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(trainPath[i]),
              backgroundColor: Colors.blue,
            ),
            if (i < trainPath.length - 1) // Add arrow if it's not the last station
              const Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.blue, // Customize arrow color
              ),
          ],
        ),
      );
    }
    return pathWidgets;
  }
}
