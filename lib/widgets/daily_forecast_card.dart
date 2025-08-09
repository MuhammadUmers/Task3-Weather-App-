import 'package:flutter/material.dart';

class DailyForecastCard extends StatelessWidget {
  final String day;
  final String iconUrl;
  final String maxTemp;
  final String minTemp;
  final String description;

  const DailyForecastCard({
    Key? key,
    required this.day,
    required this.iconUrl,
    required this.maxTemp,
    required this.minTemp,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                day,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            Image.network(
              iconUrl,
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.cloud,
                  size: 40,
                  color: Colors.grey,
                );
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '$maxTemp°/$minTemp°',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}