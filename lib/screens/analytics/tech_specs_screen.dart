import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/car_listing.dart';
import '../../utils/analytics_engine.dart';

class TechSpecsScreen extends StatelessWidget {
  final List<CarListing> data;

  const TechSpecsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final engine = AnalyticsEngine(data);
    final fuelCounts = engine.getCountByAttribute((c) => c.fuelType);
    final transCounts = engine.getCountByAttribute((c) => c.transmission);
    final engineCounts = engine.getCountByAttribute((c) => c.engineVolume);

    return Scaffold(
      appBar: AppBar(title: const Text("Технічні Характеристики")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildChartSection(
            "Тип коробки передач",
            _buildBarChart(transCounts, Colors.blue),
            engine.getTransmissionInsight(),
          ),
          const SizedBox(height: 24),
          _buildChartSection(
            "Об'єм двигуна (літри)",
            _buildBarChart(engineCounts, Colors.orange, isDouble: true),
            engine.getEngineInsight(),
          ),
          const SizedBox(height: 24),
          _buildChartSection(
            "Тип палива",
            _buildBarChart(fuelCounts, Colors.green),
            engine.getFuelInsight(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(String title, Widget chart, String insight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          SizedBox(height: 220, child: chart),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
            child: Text(insight, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<dynamic, int> data, Color color, {bool isDouble = false}) {
    var sorted = data.entries.toList();

    if (isDouble) {
      sorted.sort((a, b) => (a.key as double).compareTo(b.key as double));
      if (sorted.length > 8) sorted = sorted.where((e) => e.value > 10).toList();
    } else {
      sorted.sort((a, b) => b.value.compareTo(a.value));
    }

    double maxY = 100;
    if (sorted.isNotEmpty) {
      maxY = sorted.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY * 1.15,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toInt()} авто',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                );
              }
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < sorted.length) {
                  String text = sorted[index].key.toString();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: maxY > 100 ? 50 : 20,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.grey));
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: sorted.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.value.toDouble(),
                color: color,
                width: isDouble ? 12 : 20,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxY * 1.15, color: Colors.grey[100]),
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}