import 'package:flutter/material.dart';
import '../../models/car_listing.dart';
import '../../utils/analytics_engine.dart';

class SummaryInsightsScreen extends StatelessWidget {
  final List<CarListing> data;

  const SummaryInsightsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final engine = AnalyticsEngine(data);

    return Scaffold(
      appBar: AppBar(title: const Text("Підсумки Аналізу")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader("Ключові висновки 2024"),
          const SizedBox(height: 10),
          _buildSummaryCard(engine.getPriceTrendInsight(), Icons.trending_up, Colors.blue),
          _buildSummaryCard(engine.getYearTrendInsight(), Icons.calendar_today, Colors.purple),
          _buildSummaryCard(engine.getTransmissionInsight(), Icons.settings, Colors.orange),
          _buildSummaryCard(engine.getEngineInsight(), Icons.speed, Colors.red),
          _buildSummaryCard(engine.getFuelInsight(), Icons.local_gas_station, Colors.green),
        ],
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold));
  }

  Widget _buildSummaryCard(String text, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 16, height: 1.4)),
          ),
        ],
      ),
    );
  }
}