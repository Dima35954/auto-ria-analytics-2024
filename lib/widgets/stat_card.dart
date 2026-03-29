import 'package:flutter/material.dart';

/// Віджет для відображення ключової статистики у вигляді картки.
///
/// Використовується на інформаційних панелях для візуалізації 
/// окремого показника з відповідною іконкою, заголовком та числовим значенням.
class StatCard extends StatelessWidget {
  /// Текстовий заголовок або опис показника (наприклад, "Середня ціна").
  final String title;

  /// Значення показника для відображення (наприклад, "\$15,000").
  final String value;

  /// Іконка, що візуально представляє цей показник.
  final IconData icon;

  /// Основний колір для іконки та її напівпрозорого фону.
  final Color color;

  /// Створює нову картку статистики.
  ///
  /// Усі параметри [title], [value], [icon] та [color] є обов'язковими 
  /// для коректного відображення компонента.
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}