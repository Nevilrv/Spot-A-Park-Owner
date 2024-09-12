import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_place_picker/flutter_place_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:owner_app/constant/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as latlang;

class Utils {
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  static Future<List<Placemark>> getAddress(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    return placemarks;
  }

  static Future<PickResult?> showPlacePicker(BuildContext context,
      {double? lat, double? lng}) async {
    // LocationResult? mainResult = await Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => PlacePicker(Constant.mapAPIKey)));

    PickResult? mainResult;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlutterPlacePicker(
          apiKey: Constant.mapAPIKey,
          onPlacePicked: (result) {
            log('result==========>>>>>${result.geometry?.location.lng}');
            log('result==========>>>>>${result.geometry?.location.lat}');
            Navigator.of(context).pop(result);
            mainResult = result;
          },
          desiredLocationAccuracy: LocationAccuracy.high,
          initialPosition: latlang.LatLng(lat!, lng!),
          useCurrentLocation: true,
          selectInitialPosition: true,
        ),
      ),
    );

    return mainResult;
  }
}
