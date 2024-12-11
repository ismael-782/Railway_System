import "package:railway_system/data/train_card_data.dart";
import "package:flutter/material.dart";

class WaitlistedLoyaltyCard extends StatelessWidget {
  final String passengerID;
  final int milesTraveled;

  const WaitlistedLoyaltyCard({super.key, required this.passengerID, required this.milesTraveled});

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
            Text(
              passengerID,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(width: 10),
            Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                color: milesTraveled >= 100000
                    ? Colors.yellow[700] ?? Colors.yellow // Gold
                    : milesTraveled >= 50000
                        ? Colors.grey[400] ?? Colors.grey // Silver
                        : milesTraveled >= 10000
                            ? Colors.green[400] ?? Colors.green // Green
                            : Colors.red[400] ?? Colors.red, // Default color
                border: Border.all(
                  color: milesTraveled >= 100000
                      ? Colors.yellow[800] ?? Colors.yellow // Gold border
                      : milesTraveled >= 50000
                          ? Colors.grey[600] ?? Colors.grey // Silver border
                          : milesTraveled >= 10000
                              ? Colors.green[700] ?? Colors.green // Green border
                              : Colors.red, // Default border
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  milesTraveled >= 100000
                      ? "Gold"
                      : milesTraveled >= 50000
                          ? "Silver"
                          : milesTraveled >= 10000
                              ? "Green"
                              : "None", // Default text
                  style: TextStyle(
                    color: milesTraveled >= 100000
                        ? Colors.yellow[800] ?? Colors.yellow // Gold text
                        : milesTraveled >= 50000
                            ? Colors.grey[600] ?? Colors.grey // Silver text
                            : milesTraveled >= 10000
                                ? Colors.green[700] ?? Colors.green // Green text
                                : Colors.red, // Default text color
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
