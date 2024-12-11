import "package:railway_system/data/train_card_data.dart";
import "package:flutter/material.dart";

class WaitlistedLoyaltyCard extends StatelessWidget {
  final String passengerID;
  final int milesTraveled;

  const WaitlistedLoyaltyCard({super.key, required this.passengerID, required this.milesTraveled});

  @override
  Widget build(BuildContext context) {
    var passengerLoyaltyLevel;

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
            Text(
              passengerID,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(width: 10),
            Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                  color: passengerLoyaltyLevel == "Temp"
                      ? Colors.blue[100]
                      : passengerLoyaltyLevel == "Paid"
                          ? Colors.green[100]
                          : passengerLoyaltyLevel == "Waitlisted"
                              ? Colors.orange[100]
                              : Colors.red[100],
                  border: Border.all(
                      color: passengerLoyaltyLevel == "Temp"
                          ? Colors.blue
                          : passengerLoyaltyLevel == "Paid"
                              ? Colors.green
                              : passengerLoyaltyLevel == "Waitlisted"
                                  ? Colors.orange
                                  : Colors.red),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(passengerLoyaltyLevel, textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}
