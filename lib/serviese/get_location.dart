import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class GetLocation {
  Future<String> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return "Narsingdi";
      }
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String? city = placemarks[0].locality;
      return city ?? "Narsingdi";
    } catch (e) {
      return "Narsingdi";
      // throw Exception('error :$e');
    }
  }
}
