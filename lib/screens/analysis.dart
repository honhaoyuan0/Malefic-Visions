import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenTimeAnalysis extends StatelessWidget {
  const ScreenTimeAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.only(top: 25, left: 18, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
              //Screen Time
              const TitleText('Screen Time'),
              const SizedBox(height: 25),
              const DailyScreenTime(),
      
              //App Usage Chart
              const SizedBox(height: 27),
              const TitleText('App Usage'),
              const SizedBox(height: 10),
              const TitleText(
                'Here is the bar chart of your app usage',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16.0,
                ),
              ),
      
              //Bar chart placeholder
              const SizedBox(height: 200),
      
              //Insights
              const TitleText('Insights'),
              const SizedBox(height: 15),
              SvgPicture.asset(
                'assets/instagram-svgrepo-com.svg',
                width: 50,
                height: 50,
              ),
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
        color: Color.fromARGB(255, 0, 0, 0),
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
          ),
        ),
      ],
    );
  }
}

//Screen time box widget
Widget timebox({
  required String title,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    width: 200,
    height: 135,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 0, 0, 0),
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
        ],
    ),
  );
}





