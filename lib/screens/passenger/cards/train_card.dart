import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/book.dart";
import "package:railway_system/data/train_card_data.dart";
import "package:railway_system/utils.dart";

class TrainCard extends StatelessWidget {
  final TrainCardData trainCardData;

  const TrainCard({super.key, required this.trainCardData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 180,
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), border: Border.all(color: Colors.blue, width: 2)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Booking(
                trainID: trainCardData.trainID,
                source: trainCardData.source,
                destination: trainCardData.destination,
                date: trainCardData.date,
                trainCardData: trainCardData,
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    const Icon(Icons.train),
                    const SizedBox(width: 5),
                    Text("Train #${trainCardData.trainID}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                    const Spacer(),
                    Column(children: [Text(trainCardData.nameEN), Text(trainCardData.nameAR)]),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(minutesToTime(trainCardData.sTime)),
                    const SizedBox(width: 10),
                    const Text("- - - - - - - "),
                    const Icon(Icons.arrow_forward),
                    const Text("- - - - - - - "),
                    const SizedBox(width: 10),
                    Text(minutesToTime(trainCardData.fTime)),
                  ],
                ),
                const SizedBox(height: 15),
                Text(minutesToDuration(trainCardData.duration())),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Spacer(),
                    Text("Remaining Business: ${trainCardData.remainingBusiness()}"),
                    const SizedBox(width: 30),
                    Text("Remaining Economy: ${trainCardData.remainingEconomy()}"),
                    const Spacer(),
                  ],
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
