import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueChart extends StatelessWidget {
  final Map<String, dynamic>? metrics;

  const RevenueChart({super.key, this.metrics});

  @override
  Widget build(BuildContext context) {
    // Mocked data to match mockup 2 visual style
    final data = [
      _BarData(0, 1500),
      _BarData(1, 2400),
      _BarData(2, 1200),
      _BarData(3, 3100),
      _BarData(4, 4500), // Peak
      _BarData(5, 3400),
      _BarData(6, 4100),
    ];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 5000,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => const Color(0xFF1E293B),
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
              return BarTooltipItem(
                '${days[group.x]}\n',
                const TextStyle(color: Colors.white70, fontSize: 10),
                children: [
                  TextSpan(
                    text: 'Revenue: \$${rod.toY.toInt()}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() >= days.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    days[value.toInt()],
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                );
              },
              reservedSize: 24,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: data.map((d) => BarChartGroupData(
          x: d.x,
          barRods: [
            BarChartRodData(
              toY: d.y,
              gradient: const LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFFA855F7)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              width: 14,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: 5000,
                color: const Color(0xFFF1F5F9),
              ),
            ),
          ],
        )).toList(),
      ),
    );
  }
}

class _BarData {
  final int x;
  final double y;
  _BarData(this.x, this.y);
}
