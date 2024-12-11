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
              "Load Factor:",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "${((trainCardData.bookedBusiness + trainCardData.bookedEconomy) / (trainCardData.businessCapacity + trainCardData.economyCapacity) * 100).toStringAsFixed(2)}%",
              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
