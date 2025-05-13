import 'package:location/location.dart';

Location location = Location();

Future<bool> _requestPermission() async {
  PermissionStatus permissionStatus = await location.hasPermission();
  if (permissionStatus == PermissionStatus.denied) {
    permissionStatus = await location.requestPermission();
    if (permissionStatus != PermissionStatus.granted) {
      return false;
    }
  }
  return true;
}

Future<LocationData?> getLocation() async {
  if (await _requestPermission()) {
    return location.getLocation();
  } else {
    // Handle permission denied
    return null;
  }
}