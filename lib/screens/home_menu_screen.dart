import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'analytics/market_overview_screen.dart';
import 'analytics/tech_specs_screen.dart';
import 'analytics/summary_insights_screen.dart';
import '../data/mock_data.dart';
import 'analytics/geo_condition_screen.dart';
import 'analytics/trends_ratings_screen.dart';

class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MockData.getCarListings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Центр Аналітики AutoRia'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Оберіть категорію аналізу:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    title: "Ринок та Ціни",
                    icon: Icons.trending_up,
                    color: Colors.blue,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MarketOverviewScreen(data: data))),
                  ),
                  _buildMenuCard(
                    context,
                    title: "Тех. Характеристики",
                    icon: Icons.speed,
                    color: Colors.orange,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TechSpecsScreen(data: data))),
                  ),
                  _buildMenuCard(
                    context,
                    title: "Тренди та Рейтинги",
                    icon: Icons.bar_chart,
                    color: Colors.indigo,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TrendsRatingsScreen(data: data))),
                  ),
                  _buildMenuCard(
                    context,
                    title: "Підсумки та ТОП",
                    icon: Icons.star,
                    color: Colors.purple,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SummaryInsightsScreen(data: data))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}