import 'package:permission_handler/permission_handler.dart';

class OverlayService {
  static Future<bool> requestOverlayPermission() async {
    // Check if overlay permission is granted
    if (await Permission.systemAlertWindow.isGranted) {
      return true;
    }

    // If permission is not granted we request for permisiion
    final status = await Permission.systemAlertWindow.request();
    return status == PermissionStatus.granted;
  }

  // Check if we have the overlay permission
  static Future<bool> hasOverlayPermission() async {
    return await Permission.systemAlertWindow.isGranted;
  }
}