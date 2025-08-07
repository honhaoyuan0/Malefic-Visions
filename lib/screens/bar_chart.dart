import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'screens.dart';

class CategoryBarChart extends StatefulWidget {
  const CategoryBarChart({super.key});

  @override
  State<CategoryBarChart> createState() => _CategoryBarChartState();
}

class _CategoryBarChartState extends State<CategoryBarChart> {
  // Mock data for App Usage (Categorized)
  static const Map<String, double> screenTime = {
    'Social Media': 3.5,
    'Entertainment': 4.2,
    'Productivity': 1.3,
    'Others': 1.0,
  };


  late final List<String> _appCategories;
  late final List<double> _screenTimeValues;
  late final double _maxY;
  late final BarChartData _barChartData;

  @override
  void initState() {
    super.initState();
    _appCategories = screenTime.keys.toList();
    _screenTimeValues = screenTime.values.toList();
    
    // Calculate maxY dynamically to prevent overflow
    _maxY = _screenTimeValues.reduce((a, b) => a > b ? a : b) * 1.2;
    
    // Build chart data ONCE only to prevent overflow
    _barChartData = _buildBarChartData();
  }

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add constraints to prevent overflow
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screen.width * 0.9, 
                maxHeight: 300,
                minHeight: 200,
              ),
              child: AspectRatio(
                aspectRatio: 2.5, // Maintain consistent aspect ratio
                child: BarChart(_barChartData),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method for bar chart data
  BarChartData _buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: _maxY, // Use calculated maxY

      //Allows interaction with bar chart
      barTouchData: BarTouchData(
        enabled: true, // Enable touch to view screen time details
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            //Return the app categories and total hour when pressed
            return BarTooltipItem(
              '${_appCategories[group.x.toInt()]}\n${rod.toY.toStringAsFixed(1)}h',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),

      //Disable titles other than bottom titles 
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),

        //Enable bottom titles - display app categories
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40, // Reserve space for labels
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              //Return the app categories according to index
              if (index >= 0 && index < _appCategories.length) {
                return SideTitleWidget(
                  meta: meta,
                  space: 9,
                  child: Text(
                      _appCategories[index],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
              }
              return const SizedBox.shrink();
            },
        ),
      ),
    ),
      //Generate bar chart for each categories 
      barGroups: List.generate(
        _appCategories.length,
        (index) => BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: _screenTimeValues[index],
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlue,
                  const Color.fromARGB(255, 132, 172, 190),
                ],
              ),
              width: 25.0,
              borderRadius: BorderRadius.circular(6),

              //Background bar - to show the full length of the bar could reach
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: _maxY,
                color: Colors.grey.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}