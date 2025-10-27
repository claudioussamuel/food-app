import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  static LocationController get instance => Get.find();

  // Observable variables
  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final RxString locationAddress = ''.obs;
  final RxString locationLabel = ''.obs;
  final RxBool isLoadingLocation = false.obs;
  final RxBool isLoadingSuggestions = false.obs;
  final RxList<Map<String, dynamic>> placeSuggestions =
      <Map<String, dynamic>>[].obs;
  final RxString searchQuery = ''.obs;
  final Rx<LocationPermission> permissionStatus = LocationPermission.denied.obs;

  // Google Maps configuration
  final Rx<CameraPosition> initialCameraPosition = const CameraPosition(
    target: LatLng(51.5074, -0.1278), // Default to London
    zoom: 14.0,
  ).obs;

  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxString googleAPIKey = 'AIzaSyBEbT4gVfEBUmq2Wwv85RD4cUaNEqVqLyw'.obs;

  // Google Map Controller for camera animations
  GoogleMapController? _mapController;

  // Local persistence
  final GetStorage _storage = GetStorage();
  static const String _kAddressKey = 'selected_address';
  static const String _kLatKey = 'selected_lat';
  static const String _kLngKey = 'selected_lng';
  static const String _kLabelKey = 'selected_label';

  @override
  void onInit() {
    super.onInit();
    _loadAPIKey();
    _loadSavedLocation();
  }

  /// Set the Google Map Controller for camera animations
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Animate camera to location with smooth transition
  Future<void> _animateCameraToLocation(LatLng location) async {
    if (_mapController != null) {
      try {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: location,
              zoom: 16.0,
            ),
          ),
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error animating camera: $e');
        }
      }
    }
  }

  void _loadAPIKey() {
    try {
      googleAPIKey.value = dotenv.env["GOOGLE_API_KEY"] ?? '';
      if (googleAPIKey.value.isEmpty) {
        if (kDebugMode) {
          print('Google API Key not found in .env file');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading Google API Key: $e');
      }
    }
  }

  void _loadSavedLocation() {
    try {
      final savedAddress = _storage.read<String>(_kAddressKey) ?? '';
      final savedLat = _storage.read<double>(_kLatKey);
      final savedLng = _storage.read<double>(_kLngKey);
      final savedLabel = _storage.read<String>(_kLabelKey) ?? '';

      if (savedLat != null && savedLng != null) {
        final latLng = LatLng(savedLat, savedLng);
        currentLocation.value = latLng;
        initialCameraPosition.value =
            CameraPosition(target: latLng, zoom: 16.0);
        _updateMarkers(latLng);
      }

      locationAddress.value = savedAddress;
      locationLabel.value = savedLabel;
    } catch (_) {}
  }

  void _saveSelectedLocation() {
    try {
      final lat = currentLocation.value?.latitude;
      final lng = currentLocation.value?.longitude;
      if (lat != null && lng != null) {
        _storage.write(_kLatKey, lat);
        _storage.write(_kLngKey, lng);
      }
      _storage.write(_kAddressKey, locationAddress.value);
      _storage.write(_kLabelKey, locationLabel.value);
    } catch (_) {}
  }

  /// Check if location permissions are granted
  Future<bool> hasLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Get user's current location
  Future<void> getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;

      if (kIsWeb) {
        // WEB: Use browser's Geolocation API
        await _getCurrentLocationWeb();
      } else {
        // MOBILE: Use Geolocator package
        await _getCurrentLocationMobile();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current location: $e');
      }

      // Show user-friendly error message
      String errorMessage = 'Failed to get current location. ';
      if (e.toString().contains('timeout')) {
        errorMessage += 'Location request timed out. Please try again.';
      } else if (e.toString().contains('permission') || e.toString().contains('denied')) {
        errorMessage += 'Location permission is required. Please allow location access in your browser.';
      } else if (e.toString().contains('service') || e.toString().contains('unavailable')) {
        errorMessage += 'Location services are not available.';
      } else {
        errorMessage += 'Please check your browser settings and try again.';
      }

      Get.snackbar(
        'Location Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        mainButton: TextButton(
          onPressed: () => getCurrentLocation(),
          child: const Text(
            'Retry',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Get current location on web using browser's Geolocation API
  Future<void> _getCurrentLocationWeb() async {
    try {
      // For web, we'll use a simpler approach with Geolocator
      // which internally uses the browser's Geolocation API
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception('Location request timed out. Please ensure location is enabled in your browser.');
        },
      );

      final location = LatLng(position.latitude, position.longitude);
      currentLocation.value = location;

      // Update camera position
      initialCameraPosition.value = CameraPosition(
        target: location,
        zoom: 16.0,
      );

      // Update markers
      _updateMarkers(location);

      // Animate camera to current location for smooth transition
      await _animateCameraToLocation(location);

      // Get address from coordinates
      await _getAddressFromCoordinates(location);
      _saveSelectedLocation();

      if (kDebugMode) {
        print('Web - Current location: ${location.latitude}, ${location.longitude}');
      }

      Get.snackbar(
        'Location Found',
        'Your current location has been set successfully.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Web location error: $e');
      }
      rethrow;
    }
  }

  /// Get current location on mobile using Geolocator package
  Future<void> _getCurrentLocationMobile() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location Services',
        'Location services are disabled. Please enable them.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Check if we have permission first
    if (!await hasLocationPermission()) {
      bool granted = await requestLocationPermission();
      if (!granted) {
        Get.snackbar(
          'Location Permission Required',
          'Location access is needed to show nearby restaurants and delivery services.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
    }

    // Get current permission status
    LocationPermission permission = await Geolocator.checkPermission();
    permissionStatus.value = permission;

    // Get current position with timeout
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );

    final location = LatLng(position.latitude, position.longitude);
    currentLocation.value = location;

    // Update camera position
    initialCameraPosition.value = CameraPosition(
      target: location,
      zoom: 16.0,
    );

    // Update markers
    _updateMarkers(location);

    // Animate camera to current location for smooth transition
    await _animateCameraToLocation(location);

    // Get address from coordinates
    await _getAddressFromCoordinates(location);
    _saveSelectedLocation();

    if (kDebugMode) {
      print('Mobile - Current location: ${location.latitude}, ${location.longitude}');
    }
  }

  /// Set location manually (from map tap)
  Future<void> setLocation(LatLng location) async {
    currentLocation.value = location;
    _updateMarkers(location);

    // Update camera position
    initialCameraPosition.value = CameraPosition(
      target: location,
      zoom: 16.0,
    );

    // Animate camera to new location for smooth transition
    await _animateCameraToLocation(location);

    // Get address from coordinates
    await _getAddressFromCoordinates(location);
    _saveSelectedLocation();
  }

  /// Search for places
  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      placeSuggestions.clear();
      return;
    }

    if (googleAPIKey.value.isEmpty) {
      if (kDebugMode) {
        print('Google API Key not available for place search');
      }
      return;
    }

    try {
      isLoadingSuggestions.value = true;
      searchQuery.value = query;

      final String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
          'input=$query&key=${googleAPIKey.value}&components=country:gh';

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        placeSuggestions.value =
            List<Map<String, dynamic>>.from(data['predictions']);
      } else {
        placeSuggestions.clear();
        if (kDebugMode) {
          print('Places API error: ${data['status']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error searching places: $e');
      }
      placeSuggestions.clear();
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  /// Select a place from suggestions
  Future<void> selectPlace(Map<String, dynamic> suggestion) async {
    try {
      final placeId = suggestion['place_id'];
      final latLng = await _getLatLngFromPlaceId(placeId);

      if (latLng != null) {
        currentLocation.value = latLng;
        locationAddress.value = suggestion['description'] ?? '';

        _updateMarkers(latLng);

        // Update camera position
        initialCameraPosition.value = CameraPosition(
          target: latLng,
          zoom: 16.0,
        );

        // Animate camera to new location for smooth transition
        await _animateCameraToLocation(latLng);

        // Clear suggestions
        placeSuggestions.clear();
        searchQuery.value = '';

        _saveSelectedLocation();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error selecting place: $e');
      }
    }
  }

  /// Update location label
  void updateLocationLabel(String label) {
    locationLabel.value = label;
    _saveSelectedLocation();
  }

  /// Get coordinates from place ID
  Future<LatLng?> _getLatLngFromPlaceId(String placeId) async {
    if (googleAPIKey.value.isEmpty) return null;

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json?'
          'place_id=$placeId&key=${googleAPIKey.value}';

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final location = data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting coordinates from place ID: $e');
      }
    }
    return null;
  }

  /// Get address from coordinates using Google Geocoding API
  Future<void> _getAddressFromCoordinates(LatLng location) async {
    try {
      if (googleAPIKey.value.isEmpty) {
        locationAddress.value =
            '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
        return;
      }

      final String url = 'https://maps.googleapis.com/maps/api/geocode/json?'
          'latlng=${location.latitude},${location.longitude}&key=${googleAPIKey.value}';

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        final result = data['results'][0];
        locationAddress.value = result['formatted_address'] ??
            '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
      } else {
        locationAddress.value =
            '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting address from coordinates: $e');
      }
      locationAddress.value =
          '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
    }
  }

  /// Update map markers
  void _updateMarkers(LatLng location) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: location,
        infoWindow: InfoWindow(
          title: 'Selected Location',
          snippet: locationAddress.value.isNotEmpty
              ? locationAddress.value
              : 'Tap to set location',
        ),
        // Add custom marker color for better visibility
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        // Add animation effect
        consumeTapEvents: false,
      ),
    );
  }

  /// Clear search
  void clearSearch() {
    placeSuggestions.clear();
    searchQuery.value = '';
  }

  /// Reset location data
  void resetLocation() {
    currentLocation.value = null;
    locationAddress.value = '';
    locationLabel.value = '';
    markers.clear();
    placeSuggestions.clear();
    searchQuery.value = '';
  }

  /// Check if location is set
  bool get isLocationSet => currentLocation.value != null;

  /// Get location summary for display
  String get locationSummary {
    if (locationAddress.value.isNotEmpty) {
      return locationAddress.value;
    } else if (currentLocation.value != null) {
      return '${currentLocation.value!.latitude.toStringAsFixed(6)}, ${currentLocation.value!.longitude.toStringAsFixed(6)}';
    }
    return 'No location selected';
  }
}
