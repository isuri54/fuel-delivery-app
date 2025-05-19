import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../consts/colors.dart';
import '../../res/custombtn.dart';

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
  bool _isLoading = true;
  String? _errorMessage;
  LatLng _fallbackLocation = const LatLng(6.9271, 79.8612); 

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = "Location services are disabled. Using fallback location.";
          _currentPosition = Position(
            latitude: _fallbackLocation.latitude,
            longitude: _fallbackLocation.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
        });
        await _findNearestFuelStation(_fallbackLocation.latitude, _fallbackLocation.longitude);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = "Location permission denied. Using fallback location.";
            _currentPosition = Position(
              latitude: _fallbackLocation.latitude,
              longitude: _fallbackLocation.longitude,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              heading: 0,
              speed: 0,
              speedAccuracy: 0,
              altitudeAccuracy: 0,
              headingAccuracy: 0,
            );
          });
          await _findNearestFuelStation(_fallbackLocation.latitude, _fallbackLocation.longitude);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = "Location permissions are permanently denied. Using fallback location.";
          _currentPosition = Position(
            latitude: _fallbackLocation.latitude,
            longitude: _fallbackLocation.longitude,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0,
            altitudeAccuracy: 0,
            headingAccuracy: 0,
          );
        });
        await _findNearestFuelStation(_fallbackLocation.latitude, _fallbackLocation.longitude);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      print("Current position: Lat=${position.latitude}, Lon=${position.longitude}");

      await _findNearestFuelStation(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _errorMessage = "Error getting location: $e. Using fallback location.";
        _currentPosition = Position(
          latitude: _fallbackLocation.latitude,
          longitude: _fallbackLocation.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        );
      });
      await _findNearestFuelStation(_fallbackLocation.latitude, _fallbackLocation.longitude);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _findNearestFuelStation(double lat, double lon) async {
    const String apiKey = "AIzaSyDy43qr6oaeZUW8YrJEN74hLpozVUdIVq0"; 
    final String url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lon&radius=10000&type=gas_station&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      print("Places API Response: ${response.body}"); 
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          var place = data['results'][0];
          double stationLat = place['geometry']['location']['lat'];
          double stationLon = place['geometry']['location']['lng'];
          setState(() {
            _nearestFuelStation = LatLng(stationLat, stationLon);
            _nearestStationName = place['name'] ?? "Unnamed Fuel Station";
          });

          
          if (_mapController != null && _nearestFuelStation != null) {
            _mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  southwest: LatLng(
                    lat < stationLat ? lat : stationLat,
                    lon < stationLon ? lon : stationLon,
                  ),
                  northeast: LatLng(
                    lat > stationLat ? lat : stationLat,
                    lon > stationLon ? lon : stationLon,
                  ),
                ),
                50,
              ),
            );
          }
        } else {
          setState(() {
            _nearestStationName = "No fuel stations found nearby. Status: ${data['status']}";
          });
        }
      } else {
        setState(() {
          _nearestStationName = "Error fetching fuel stations: HTTP ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _nearestStationName = "Error fetching fuel stations: $e";
      });
    }
  }

  void _proceedToCheckout() {
    if (_nearestFuelStation == null || _nearestStationName == "Finding nearest fuel station...") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No fuel station found. Please try again.")),
      );
      return;
    }
    
    Navigator.pushNamed(
      context,
      '/billing',
      arguments: {
        'stationName': _nearestStationName,
        'stationLat': _nearestFuelStation!.latitude,
        'stationLon': _nearestFuelStation!.longitude,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Nearest Fuel Station"),
        backgroundColor: AppColors.greenC,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("current_location"),
                      position: LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
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
                if (_errorMessage != null)
                  Positioned(
                    top: 80,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: CustomButton(
                        buttonText: "CHECKOUT",
                        onTap: _proceedToCheckout,
                        textColor: Colors.black,
                        buttonColor: AppColors.greenC,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}