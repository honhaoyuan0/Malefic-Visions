import 'package:flutter/material.dart';
import '../global_utilities/screen_utils.dart';
import 'screens.dart';


// Placeholder widget using mock data for screen time.
// real screen time data will be integrated later.
class ScreenTime extends StatefulWidget {
  const ScreenTime({super.key});

  @override
  State<ScreenTime> createState() => _ScreenTimeState();
}

class _ScreenTimeState extends State<ScreenTime> {
  //Mock data for total screen time
  final String totalScreenTime = '4h 50m';

  @override
  Widget build(BuildContext context) {
     // Get the screen size using ScreenUtils
    final screen = ScreenUtils(context);

    //Screen time box
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
      // Tap the box to navigate to screen time breakdown
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScreenTimeBreakdown()),
        );
      },
      child: Ink(
      padding: EdgeInsets.all(screen.width * 0.06),
      decoration : BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(26, 85, 81, 81)),
      ),
      child: Container(
        constraints: BoxConstraints(
        maxWidth: screen.width*0.33,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, //Align text to the left 
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //Leave spaces between text and icon
            children: [
             Text('Today', style: Theme.of(context).textTheme.bodySmall),
              //Add an arrow - indicate that this is clickable
              Icon(
                Icons.arrow_forward_ios_rounded,
                size:16,
                color:Colors.grey[500],
              )
            ],
          ),

          // Mock screen time usage
          Padding(
            padding: EdgeInsets.only(top: screen.height*0.013),
            child: Text(totalScreenTime, style: Theme.of(context).textTheme.displayMedium),
            ),
          ],
        ),
      ),
    ),
  ),
); 
 }
}

