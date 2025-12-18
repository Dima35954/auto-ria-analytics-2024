import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/car_listing.dart';
import '../../utils/analytics_engine.dart';
import '../../theme/app_theme.dart';

class MarketOverviewScreen extends StatelessWidget {
  final List<CarListing> data;

  const MarketOverviewScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final engine = AnalyticsEngine(data);
    final brandCounts = engine.getCountByAttribute((c) => c.make);
    final priceTrend = engine.getMonthlyPriceTrend();

    return Scaffold(
      appBar: AppBar(title: const Text("Огляд Ринку")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Розподіл за Брендами"),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: _getSections(brandCounts),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildLegend(brandCounts),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightCard(engine.getMostPopularMakeInsight()),

            const SizedBox(height: 32),
            _buildSectionTitle("Динаміка середньої ціни (2024)"),
            const SizedBox(height: 20),

            // --- ЛІНІЙНИЙ ГРАФІК (ОНОВЛЕНИЙ) ---
            Container(
              height: 300, // Збільшили висоту
              padding: const EdgeInsets.only(right: 16, left: 0, top: 10),
              child: LineChart(
                LineChartData(
                  // СІТКА: Робимо її видимою
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    verticalInterval: 1,
                    // Робимо горизонтальні лінії частішими (кожні 2000$)
                    horizontalInterval: 2000,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[300], strokeWidth: 1),
                    getDrawingVerticalLine: (value) => FlLine(color: Colors.grey[200], strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45, // Більше місця для тексту "20k"
                        interval: 2000,   // Крок осі Y - 2000 (було 5000)
                        getTitlesWidget: (value, meta) {
                          // Форматуємо: 10000 -> 10k
                          if (value == 0) return const SizedBox();
                          return Text('${(value / 1000).toStringAsFixed(0)}k', style: const TextStyle(fontSize: 10, color: Colors.grey));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const months = ['', 'Січ', 'Лют', 'Бер', 'Кві', 'Тра', 'Чер', 'Лип', 'Сер', 'Вер', 'Жов', 'Лис', 'Гру'];
                          if (value >= 1 && value <= 12) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(months[value.toInt()], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!), left: BorderSide(color: Colors.grey[300]!)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: priceTrend.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                      isCurved: true,
                      color: AppTheme.primaryColor,
                      barWidth: 3,
                      dotData: const FlDotData(show: true), // Показуємо точки
                      belowBarData: BarAreaData(show: true, color: AppTheme.primaryColor.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightCard(engine.getPriceTrendInsight()),
            const SizedBox(height: 40),
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
      decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic))),
        ],
      ),
    );
  }

  Widget _buildLegend(Map<String, int> data) {
    var sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: sorted.take(5).map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(width: 12, height: 12, color: Colors.primaries[sorted.indexOf(e) % Colors.primaries.length]),
              const SizedBox(width: 8),
              Text('${e.key} (${e.value})', style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<PieChartSectionData> _getSections(Map<String, int> data) {
    var sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(5).map((e) {
      final index = sorted.indexOf(e);
      return PieChartSectionData(
        value: e.value.toDouble(),
        title: '',
        color: Colors.primaries[index % Colors.primaries.length],
        radius: index == 0 ? 50 : 45,
      );
    }).toList();
  }
}