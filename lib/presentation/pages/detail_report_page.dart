import 'package:flutter/material.dart';
import 'package:city_care/domain/entities/report.dart';

class DetailReportPage extends StatelessWidget {
  final Report report;

  const DetailReportPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(report.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text("Status: ${report.status}", style: TextStyle(color: report.status == 'resolved' ? Colors.green : Colors.orange)),
            const SizedBox(height: 16),
            const Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(report.description),
            const SizedBox(height: 16),
            if (report.aiSuggestion != null) ...[
              const Text("AI Analysis:", style: TextStyle(fontWeight: FontWeight.bold)),
              Container(
                 padding: const EdgeInsets.all(8),
                 color: Colors.grey[200],
                 child: Text(report.aiSuggestion!),
              ),
              const SizedBox(height: 16),
            ],
            const Text("Location:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Lat: ${report.latitude}, Long: ${report.longitude}"),
            const SizedBox(height: 16),
            Text("Created: ${report.createdAt.toLocal()}"),
          ],
        ),
      ),
    );
  }
}
