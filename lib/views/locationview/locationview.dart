import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  _LocationViewState createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  LatLng? _nearestFuelStation;
  String _nearestStationName = "Finding nearest fuel station...";

  @override
  void initState() {
    super.initState();
    checkPermissions();
    _getCurrentLocation();
  }

  void checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied.");
        return;
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _nearestStationName = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _nearestStationName = "Location permission denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _nearestStationName = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });

    _findNearestFuelStation(position.latitude, position.longitude);
  }

  Future<void> _findNearestFuelStation(double lat, double lon) async {
    const String apiKey = "AIzaSyDy43qr6oaeZUW8YrJEN74hLpozVUdIVq0";
    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lon&radius=5000&type=gas_station&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        var place = data['results'][0];
        double lat = place['geometry']['location']['lat'];
        double lng = place['geometry']['location']['lng'];
        setState(() {
          _nearestFuelStation = LatLng(lat, lng);
          _nearestStationName = place['name'];
        });
      } else {
        setState(() {
          _nearestStationName = "No fuel stations found nearby.";
        });
      }
    } else {
      setState(() {
        _nearestStationName = "Error fetching fuel stations.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find Nearest Fuel Station")),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("current_location"),
                      position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                      infoWindow: const InfoWindow(title: "Your Location"),
                    ),
                    if (_nearestFuelStation != null)
                      Marker(
                        markerId: const MarkerId("nearest_fuel"),
                        position: _nearestFuelStation!,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                        infoWindow: InfoWindow(title: _nearestStationName),
                      ),
                  },
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 5),
                      ],
                    ),
                    child: Text(
                      _nearestStationName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

