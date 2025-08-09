import 'package:flutter/material.dart';
import '../global_utilities/screen_utils.dart';
import 'screens.dart';

class ScreenTimeAnalysis extends StatefulWidget {
  const ScreenTimeAnalysis({super.key});

  @override
  State<ScreenTimeAnalysis> createState() => _ScreenTimeAnalysisState();
}

class _ScreenTimeAnalysisState extends State<ScreenTimeAnalysis> {
  @override
  Widget build(BuildContext context) {
    final screen = ScreenUtils(context);
    return Scaffold(
      body: SafeArea(
        // Adjust padding based on screen size - to prevent overflow issues
        child: Padding(
          padding: EdgeInsets.only(
            left: screen.width * 0.05,
            right: screen.width * 0.03,
          ),
          //Wrap with ListView to show blocked contents
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Screen Time
              Text(
                'Screen Time',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: screen.height * 0.03),
              Center(child: ScreenTime()),

              //App Usage Chart
              SizedBox(height: screen.height * 0.03),
              Text(
                'App Usage',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: screen.height * 0.01),

              //Bar chart placeholder
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: screen.height * 0.01),
                  child: CategoryBarChart(),
                ),
              ),

              //Insights
              Text(
                'Insights',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: screen.height * 0.03),
              _buildGlassmorphicCard(child: AppInsights(), screen: screen),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicCard({
    required Widget child,
    required ScreenUtils screen,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(screen.width * 0.05),
          child: child,
        ),
      ),
    );
  }
}
