import "package:flutter/material.dart";

import "package:railway_system/screens/passenger/book.dart";
import "package:railway_system/data/train_card_data.dart";
import "package:railway_system/utils.dart";

class SearchTripCard extends StatelessWidget {
  final TrainCardData trainCardData;
  final bool clickable;

  const SearchTripCard({super.key, required this.trainCardData, required this.clickable});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickable
          ? () {
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
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
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
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trainCardData.source,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(minutesToTime(trainCardData.sTime))
                            ],
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_right_alt_sharp, size: 50),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                trainCardData.destination,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(minutesToTime(trainCardData.fTime))
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text("Duration: "),
                          Text(minutesToDuration(trainCardData.fTime - trainCardData.sTime)),
                          const SizedBox(width: 15),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Remaining Eco Seats: "),
                              Text("Remaining Business Seats: "),
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              Text(trainCardData.remainingEconomy().toString()),
                              Text(trainCardData.remainingBusiness().toString()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
