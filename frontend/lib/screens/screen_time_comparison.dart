import 'package:flutter/material.dart';

//Mock app usage for screen time insights - compare screen time between two days
class AppUsage{
  final String appName;
  final String category;
  final Duration usageTime;

  AppUsage({
    required this.appName,
    required this.category,
    required this.usageTime,
  });
}

  //Screen time for current day
  final List<AppUsage>mockYesterdayUsage = [
    AppUsage(appName:'Instagram', category:'Social Media', usageTime: Duration(hours: 1, minutes: 35)),
    AppUsage(appName:'TikTok', category:'Social Media', usageTime: Duration(hours: 0, minutes: 40)),
    AppUsage(appName:'YouTube', category:'Entertainment', usageTime: Duration(hours: 0, minutes: 52)),
    AppUsage(appName:'Facebook', category:'Social Media', usageTime: Duration(hours: 1, minutes: 23)),
  ];
  
  //Screen time for yesterday
  final List<AppUsage> mockTodayUsage = [
    AppUsage(appName:'Instagram', category:'Social Media', usageTime: Duration(hours: 0, minutes: 45)),
    AppUsage(appName:'TikTok', category:'Social Media', usageTime: Duration(hours: 1, minutes: 40)),
    AppUsage(appName:'YouTube', category:'Entertainment', usageTime: Duration(hours: 1, minutes: 31)),
    AppUsage(appName:'Facebook', category:'Social Media', usageTime: Duration(hours: 1, minutes: 33)),
  ];

  //Sum up the screen time for each category
  Map<String,Duration> sumofCategory(List<AppUsage> usageList){
    //Store the total screen time
    final Map<String,Duration> categoryTotal = {};
    
    for(var usage in usageList){
      if (categoryTotal.containsKey(usage.category)){ //check if current category exist in categoryTotals
        categoryTotal[usage.category] = categoryTotal[usage.category]! + usage.usageTime; //if true - add the time to exsiting total
      }
      else {
        categoryTotal[usage.category] = usage.usageTime;
      }
    }
    return categoryTotal;
  }

  //Calculate the usage differences between two days
  Map<String,double> calculateCategoryDifferences({
    required List<AppUsage> mockTodayUsage,
    required List<AppUsage> mockYesterdayUsage,
  }) {
    //Sum today's and yesterday usage by catergory
    final sumOfToday = sumofCategory(mockTodayUsage);
    final sumofYesterday = sumofCategory(mockYesterdayUsage);

    //Initialize a list to store all category names
    final List<String> allCategories = [];

    //Loop through today's usage
    for(var category in sumOfToday.keys){
      if(!allCategories.contains(category)){
        allCategories.add(category);
      }
    }

    //Loop through yesterday's usage
    for(var category in sumofYesterday.keys){
      if(!allCategories.contains(category)){
        allCategories.add(category);
      }
    }
    //Use map to store the percentage differences
  final Map<String, double> percentageDiff = {};

  //Loop through every categories
  for(var category in allCategories){
    //Convert duration into minutes for easier calculations
    final durationToday = sumOfToday[category]?.inMinutes ?? 0; //return 0 if null
    final durationYesterday = sumofYesterday[category]?.inMinutes ?? 0;

  //Calculation
  final diff = ((durationToday - durationYesterday) / durationYesterday) *100;
  percentageDiff  [category] = diff; 
  }
  return percentageDiff;
 }