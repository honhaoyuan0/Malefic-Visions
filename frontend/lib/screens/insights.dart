import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math';
import '../global_utilities/screen_utils.dart';
import 'screens.dart';

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
    'Timer': 'assets/timer-svgrepo-com.svg',
  };

  List<Map<String,String>> insights = [];

  @override
  void initState(){
    super.initState();
    _loadInsights();
  }

  void _loadInsights() async {
    await Future.delayed(Duration.zero);
    setState((){
      insights = generateInsights();
    });
  }
  
  //Function to generate longest screen time app insights
  Map<String,String>? generateMostUsedApp(List<AppUsage> usageList) {
    if(usageList.isEmpty) return null;

    final AppUsage mostUsed = usageList.reduce(
      (a,b) => a.usageTime > b.usageTime ? a : b,
    );

    final List<String> messageType = ['mostUsed', 'reminder'];
    final random = Random();
    final selectedType = messageType[random.nextInt(messageType.length)];

    final String messageHint = getMostUsedAppHint(mostUsed, selectedType);
    
    return {
      'category': mostUsed.category,
      'message': messageHint,
      'icon': categoryIcons['Timer']!,
          };
    }

    String getMostUsedAppHint(AppUsage app, String type){
    //Change time into hours - minutes
    final int hours = app.usageTime.inHours;
    final int mins = app.usageTime.inMinutes.remainder(60);
    final String time = (hours > 0)
        ? '$hours hour${hours > 1 ? "s" : ""} ${mins} minutes'
        : '$mins minute${mins > 1 ? "s" : ""}';

    switch (type){
      case 'mostUsed':
       return 'Most used app of the day - ${app.appName} ($time)';
    
      case 'reminder':
        return 'Consider setting a 1-hour limit for ${app.appName} tommorrow.';

      default:
        return 'Most used app of the day - ${app.appName} ($time)'; 
    }
  }

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

      //Show 2-3 insights only
      final maxInsights = random.nextInt(2) + 2;
      var count = 0;

      for (var entry in categoryList){
        if(count >= maxInsights) break;

        final category = entry.key;
        final percentage = entry.value;

        if(percentage.abs() > 5){
          final isIncrease = percentage > 0;
          final changes = isIncrease ? 'increased' : 'decreased';
          final absPercentage = percentage.abs().toStringAsFixed(0); //Make percentage absolute
  
          final iconPath = categoryIcons[category] ?? categoryIcons['Timer']!;
      
          insights.add({
            'category': category,
            'message': '$category usage $changes by $absPercentage% today',
            'icon': iconPath,
          });
          count++;
        }
      }

      //Add most used app insight
      final mostUsedApp = generateMostUsedApp(mockTodayUsage); 
      if (mostUsedApp != null){
        insights.add(mostUsedApp);
      }
       return insights;
      }
      
  
  @override
  Widget build(BuildContext context) {
      return Column(
          children: insights.map((insight) => Padding(
            padding: EdgeInsets.only(bottom :7.0),
            child: buildInsightRow(
            context: context,
            svgPath: insight['icon']!,
            message: insight['message']!,
            ),
          )).toList(),
      );
   }
}
