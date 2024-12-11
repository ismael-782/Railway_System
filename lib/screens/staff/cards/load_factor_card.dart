import "package:railway_system/data/train_card_data.dart";
import "package:flutter/material.dart";

class LoadFactorCard extends StatelessWidget {
  final TrainCardData trainCardData;
  final bool clickable;

  const LoadFactorCard({super.key, required this.trainCardData, required this.clickable});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Load Factor in this Train Is:",
              style: TextStyle(color: Colors.black, fontSize: 10),
              
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${(trainCardData.bookedBusiness + trainCardData.bookedEconomy) / (trainCardData.businessCapacity + trainCardData.economyCapacity)}",
              style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset(
  //                 "assets/images/railway.png",
  //                 height: 100,
  //                 width: 100,
  //               ),
  //               const SizedBox(height: 10),
  //               Text(
  //                 "Train #${trainCardData.trainID}",
  //                 style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 20), // Add spacing between the header and the path
  //           Wrap(
  //             spacing: 8.0, // Horizontal space between items
  //             runSpacing: 4.0, // Vertical space between lines
  //             alignment: WrapAlignment.center, // Align the stations to the center
  //             children: _buildTrainPathWithArrows(trainPath),
  //           ),
  //         ],
  //       ),

  // Function to build the list of stations with arrows in between
  List<Widget> _buildTrainPathWithArrows(List<String> trainPath) {
    List<Widget> pathWidgets = [];
    for (int i = 0; i < trainPath.length; i++) {
      pathWidgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(
                trainPath[i],
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            ),
            if (i < trainPath.length - 1) // Add arrow if it's not the last station
              const Icon(
                Icons.arrow_forward,
                size: 14,
                color: Color.fromARGB(255, 0, 0, 0), // Customize arrow color
              ),
          ],
        ),
      );
    }
    return pathWidgets;
  }
}
