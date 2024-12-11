import "package:flutter/material.dart";

class DependentReportCard extends StatelessWidget {
  final String dependeeId;
  final List<String> dependentsIDs;

  const DependentReportCard({super.key, required this.dependeeId, required this.dependentsIDs});

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
        child: Column(
          children: [
            Text(
              dependeeId,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            // List all dependents numbered from 1 to n and use Row for each entry to append a small SizedBox before the numbering
            for (int i = 0; i < dependentsIDs.length; i++)
              Row(
                children: [
                  const SizedBox(width: 10),
                  Text(
                    "${i + 1}. ${dependentsIDs[i]}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
