import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'screens.dart';
import 'dart:math';

class AppInsights extends StatefulWidget {
  const AppInsights({super.key});

  @override
  State<AppInsights> createState() => _AppInsightState();
}

// Optimized insight row widget
Widget buildInsightRow({
  required BuildContext context,
  required String svgPath,
  required String message,
}) {
  final screen = ScreenUtils(context);
  
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: screen.width * 0.04,
      //vertical: screen.height * 0.01,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: screen.width * 0.08,
          height: screen.width * 0.08, // Use width for both to maintain aspect ratio
          child: SvgPicture.asset(
            svgPath,
            fit: BoxFit.contain,
            // Add caching and error handling
            placeholderBuilder: (context) => Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.apps,
                size: screen.width * 0.08,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        SizedBox(width: screen.width * 0.04), // Reduced spacing
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
            //Ensure the top of the text is aligned with svg
            //Removes built-in padding for text
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            maxLines: 3, //next row for text if its too long
          ),
        ),
      ],
    ),
  );
}

class _AppInsightState extends State<AppInsights> {

  //Map Categories to their respective icons
  final Map<String,String> categoryIcons = {
    'Social Media': 'assets/instagram-svgrepo-com.svg',
    'Entertainment': 'assets/video-library-svgrepo-com.svg',
    'Productivity': 'assets/note-svgrepo-com.svg',
  };


  //Generate insights based on mock data
  List<Map<String, String>> generateInsights(){
    final differences = calculateCategoryDifferences(
      mockTodayUsage: mockTodayUsage, 
      mockYesterdayUsage: mockYesterdayUsage
      );
     
      //Empty lists to store insights messages 
      final insights = <Map<String,String>>[];
      final random = Random(); //Randomly chooses among categories
     
      //Shuffle the categories
      final categoryList = differences.entries.toList();//Convert to list
      categoryList.shuffle(random); 

      //Show 1-2 insights only
      final maxInsights = random.nextInt(2) + 1;
      var count = 0;

      for (var entry in categoryList){
        if(count >= maxInsights) break;

        final category = entry.key;
        final percentage = entry.value;

        if(percentage.abs() > 0){ //Only show changes >10%
          final isIncrease = percentage > 0;
          final changes = isIncrease ? 'increased' : 'decreased';
          final absPercentage = percentage.abs().toStringAsFixed(0); //Make percentage absolute

          insights.add({
            'category': category,
            'message': 'Your usage on $category $changes by $absPercentage%.',
            'icon': categoryIcons[category]!,
          });
          count++;
        }
      }
       return insights;
      }
      
  
  @override
  Widget build(BuildContext context) {
    final insights = generateInsights();
      return Column(
        mainAxisSize: MainAxisSize.min,
          children: insights.map((insight) => buildInsightRow(
            context: context,
            svgPath: insight['icon']!,
            message: insight['message']!,
          )).toList(),
      );
   }
}