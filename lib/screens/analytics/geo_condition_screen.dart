import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/car_listing.dart';
import '../../utils/analytics_engine.dart';
import '../../theme/app_theme.dart';

class GeoConditionScreen extends StatelessWidget {
  final List<CarListing> data;

  const GeoConditionScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final engine = AnalyticsEngine(data);
    final regionCounts = engine.getCountByAttribute((c) => c.region);
    final conditionCounts = engine.getCountByAttribute((c) => c.condition);

    return Scaffold(
      appBar: AppBar(title: const Text("Географія та Стан")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Регіональна Статистика"),
            const SizedBox(height: 16),
            _buildRegionList(regionCounts),
            const SizedBox(height: 16),
            _buildInsightCard(engine.getRegionInsight()),

            const SizedBox(height: 32),
            _buildSectionTitle("Стан Автомобілів"),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: _getPieSections(conditionCounts),
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(conditionCounts),
            const SizedBox(height: 16),
            _buildInsightCard(engine.getConditionInsight()),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryColor));
  }

  Widget _buildInsightCard(String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.green),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic))),
        ],
      ),
    );
  }

  Widget _buildRegionList(Map<String, int> data) {
    var sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    int maxVal = sorted.first.value;

    return Column(
      children: sorted.map((e) {
        double percent = e.value / maxVal;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              SizedBox(width: 100, child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600))),
              Expanded(
                child: Stack(
                  children: [
                    Container(height: 20, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10))),
                    FractionallySizedBox(
                      widthFactor: percent,
                      child: Container(height: 20, decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(e.value.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<PieChartSectionData> _getPieSections(Map<String, int> data) {
    final colors = [Colors.green, Colors.orange, Colors.red, Colors.grey];
    var entries = data.entries.toList();
    return entries.asMap().entries.map((e) {
      return PieChartSectionData(
        value: e.value.value.toDouble(),
        title: "${((e.value.value / data.values.fold(0, (a,b)=>a+b)) * 100).toStringAsFixed(0)}%",
        radius: 100,
        color: colors[e.key % colors.length],
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, int> data) {
    final colors = [Colors.green, Colors.orange, Colors.red, Colors.grey];
    var entries = data.entries.toList();
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: entries.asMap().entries.map((e) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 12, color: colors[e.key % colors.length]),
            const SizedBox(width: 8),
            Text(e.value.key),
          ],
        );
      }).toList(),
    );
  }
}