import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/car_listing.dart';
import '../../utils/analytics_engine.dart';

class TrendsRatingsScreen extends StatelessWidget {
  final List<CarListing> data;

  const TrendsRatingsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final engine = AnalyticsEngine(data);
    final yearCounts = engine.getCountByAttribute((c) => c.year);
    final top10 = engine.getTop10Models();

    return Scaffold(
      appBar: AppBar(title: const Text("Тренди та Рейтинги")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Популярність за роком випуску", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            SizedBox(
              height: 300,
              child: _buildYearChart(yearCounts),
            ),
            const SizedBox(height: 12),
            Text(engine.getYearTrendInsight(), style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic)),

            const SizedBox(height: 40),

            const Text("ТОП-10 Найпопулярніших Авто Сезону", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Гортайте таблицю вправо ->", style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            _buildTop10Table(top10),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildYearChart(Map<int, int> data) {
    var sorted = data.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    if (sorted.isEmpty) return const Center(child: Text("Немає даних"));

    double maxY = sorted.map((e) => e.value).reduce((a, b) => a > b ? a : b).toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY * 1.1,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(tooltipBgColor: Colors.blueAccent),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  angle: -45,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: maxY > 20 ? 10 : 5),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 20 ? 10 : 5,
          getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[300], strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        barGroups: sorted.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(toY: entry.value.toDouble(), color: Colors.indigo, width: 12, borderRadius: BorderRadius.circular(2))
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTop10Table(List<CarModelStats> stats) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.indigo[50]!),
            dataRowMinHeight: 40,
            columnSpacing: 24,
            columns: const [
              DataColumn(label: Text('Бренд', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Модель', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Ціна', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('КПП', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Двигун', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Паливо', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Роки', style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Продажі', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: stats.map((item) {
              return DataRow(cells: [
                DataCell(Text(item.make, style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text(item.model)),
                DataCell(Text('\$${item.avgPrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                DataCell(Text(item.commonTrans)),
                DataCell(Text('${item.avgEngineVol.toStringAsFixed(1)} л')),
                DataCell(Text(item.commonFuel)),
                DataCell(Text('${item.minYear}-${item.maxYear}')),
                DataCell(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(4)),
                  child: Text('${item.count}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                )),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}