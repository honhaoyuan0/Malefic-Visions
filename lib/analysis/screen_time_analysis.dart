import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenTimeAnalysis extends StatelessWidget {
  const ScreenTimeAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: TitleText('Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25, left: 18, right: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText('Screen Time'),
            const SizedBox(height: 25),
            DailyScreenTime(),
            const SizedBox(height: 27),
            TitleText(
              'App Usage',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const AppUsageChart(),
            const SizedBox(height: 25),
            TitleText('Insights',),
            const SizedBox(height: 15),
            SvgInBox(assetPath: 'assets/instagram-svgrepo-com.svg'),
            const SizedBox(height: 15),
            SvgInBox(assetPath: 'assets/note-svgrepo-com.svg'),
            const SizedBox(height: 15),
            SvgInBox(assetPath: 'assets/video-library-svgrepo-com.svg'),
          ],
          
        ),
      ),
    );
  }
}



// Title text widget
class TitleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const TitleText(this.text, {this.style,super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? 
      const TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Daily screen time widget
class DailyScreenTime extends StatelessWidget {
  const DailyScreenTime({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: timebox(
            title: 'Today',
            time: '2h 30m',
            change: '+20%',
            changeColor: Colors.green,
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: timebox(
            title: 'Yesterday',
            time: '2h 10m',
            change: '-10%',
            changeColor: Colors.red,
          ),
        ),
      ],
    );
  }
}

//Screen time box widget
Widget timebox({
  required String title,
  required String time,
  required String change,
  required Color changeColor,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    width: 200,
    height: 135,
    decoration: BoxDecoration(
      color: const Color(0xFF243347),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color.fromARGB(26, 241, 241, 241)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Color.fromARGB(179, 250, 250, 250)),
        ),
        const SizedBox(height: 14.0),
        Text(
          time,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (change.isNotEmpty) ...[
          const SizedBox(height: 5),
          Text(
            change,
            style: TextStyle(
              color: changeColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    ),
  );
}

//Bar chart widget for app usage
class AppUsageChart extends StatelessWidget {
  const AppUsageChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 10,
          barTouchData: BarTouchData(enabled: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  );
                  switch (value.toInt()) {
                    case 0:
                      return Text('Social\nMedia', style: style, textAlign: TextAlign.center);
                    case 1:
                      return Text('Video\nStreaming', style: style, textAlign: TextAlign.center);
                    case 2:
                      return Text('Productivity', style: style, textAlign: TextAlign.center);
                    case 3:
                      return Text('Other', style: style, textAlign: TextAlign.center);
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            buildBarGroup(0, 6.5), // Social Media
            buildBarGroup(1, 4.0), // Video Streaming
            buildBarGroup(2, 7.5), // Productivity
            buildBarGroup(3, 2.0), // Other
          ],
        ),
      ),
    );
  }
}

// Helper function to build bar groups
BarChartGroupData buildBarGroup(int x, double y) {
  return BarChartGroupData(
    x: x,
    barRods: [
      BarChartRodData(
        toY: y,
        width: 35,
        color: const Color(0xFF3B4D6A),
        borderRadius: BorderRadius.circular(4),
      ),
    ],
  );
}

class SvgInBox extends StatelessWidget{
  final String assetPath;
  const SvgInBox({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF3B4D6A),
        borderRadius: BorderRadius.circular(12),
      ),
        child: SvgPicture.asset(
          assetPath,
          width: 30,
          height: 30,
          color: Colors.white,
          fit:BoxFit.contain,
        ),
      );
  }
}