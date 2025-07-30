import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'screen_utils.dart';
import 'package:malefic_visions/screens/screen_time.dart';
import 'package:malefic_visions/screens/bar_chart.dart';

class ScreenTimeAnalysis extends StatelessWidget {
  const ScreenTimeAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);
        return Padding(
          // Adjust padding based on screen size - to prevent overflow issues
          padding: EdgeInsets.only(
            top: screen.topPadding,
            bottom: screen.bottomPadding,
            left: screen.width * 0.05,
            right: screen.width * 0.05,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
          
                //Screen Time
                const TitleText('Screen Time'),
                SizedBox(height: screen.height * 0.03),
                Center(child: ScreenTime()),
          
                //App Usage Chart
                SizedBox(height: screen.height * 0.03),
                const TitleText('App Usage'),
      
                //Bar chart placeholder
                CategoryBarChart(),
                
                //Insights
                const TitleText('Insights'),
                SizedBox(height: screen.height * 0.03),
                SvgPicture.asset(
                  'assets/instagram-svgrepo-com.svg',
                  width: 50,
                  height: 50,
                ),
              ],
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
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}









