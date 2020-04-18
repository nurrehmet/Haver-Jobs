import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetLocation {
  double lat,long ;
  Future<void> getLat() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then(
      (Position position) {
        lat = position.latitude;
      },
    );
    return lat;
  }
  Future<void> getLong() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then(
      (Position position) {
        long = position.longitude;
      },
    );
    return long;
  }
}
