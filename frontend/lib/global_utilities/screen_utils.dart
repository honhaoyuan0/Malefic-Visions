import 'package:flutter/material.dart';

// A utility class for accessing screen dimensions and paddings - 
// - for more responsive layouts based on screen size
class ScreenUtils {
  // Store the screen dimensions and padding
  final BuildContext context;
  late final double width;
  late final double height;
  late final double topPadding;
  late final double bottomPadding;

  // Initialize the screen dimensions and padding using MediaQuery
  ScreenUtils(this.context){
    final mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    topPadding = mediaQuery.padding.top;
    bottomPadding = mediaQuery.padding.bottom;
  }
}