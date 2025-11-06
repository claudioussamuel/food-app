import 'package:flutter/material.dart';
import 'package:foodu/features/personalization/controller/location_controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BranchLocationPickerScreen extends StatelessWidget {
  final Function(LatLng location, String address) onLocationSelected;
  final LatLng? initialLocation;
  final String? initialAddress;

  const BranchLocationPickerScreen({
    super.key,
    required this.onLocationSelected,
    this.initialLocation,
    this.initialAddress,
  });

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    final searchController = TextEditingController();

    // Set initial location if provided
    if (initialLocation != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        locationController.setLocation(initialLocation!);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Branch Location'),
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Obx(() => TextButton(
                onPressed: locationController.isLocationSet
                    ? () {
                        final location = locationController.currentLocation.value!;
                        final address = locationController.locationAddress.value;
                        onLocationSelected(location, address);
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Input
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for branch location...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() => locationController.isLoadingSuggestions.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const SizedBox.shrink()),
                        IconButton(
                          onPressed: () {
                            searchController.clear();
                            locationController.clearSearch();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                        IconButton(
                          onPressed: locationController.getCurrentLocation,
                          icon: const Icon(Icons.my_location),
                          tooltip: 'Use current location',
                        ),
                      ],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      locationController.searchPlaces(value);
                    } else {
                      locationController.clearSearch();
                    }
                  },
                ),
                
                // Search Suggestions
                Obx(() {
                  if (locationController.placeSuggestions.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  
                  return Container(
                    margin: const EdgeInsets.only(top: TSizes.sm),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: locationController.placeSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = locationController.placeSuggestions[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on, color: TColors.primary),
                          title: Text(
                            suggestion['structured_formatting']['main_text'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            suggestion['structured_formatting']['secondary_text'] ?? '',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          onTap: () async {
                            await locationController.selectPlace(suggestion);
                            searchController.text = suggestion['description'] ?? '';
                            locationController.clearSearch();
                          },
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          // Current Location Info
          Obx(() {
            if (!locationController.isLocationSet) {
              return Container(
                padding: const EdgeInsets.all(TSizes.defaultSpace),
                child: const Text(
                  'Tap on the map or search for a location to select branch address',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              margin: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              decoration: BoxDecoration(
                color: TColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: TColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: TColors.primary),
                  const SizedBox(width: TSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selected Location:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                        Text(
                          locationController.locationAddress.value.isNotEmpty
                              ? locationController.locationAddress.value
                              : 'Coordinates: ${locationController.currentLocation.value!.latitude.toStringAsFixed(6)}, ${locationController.currentLocation.value!.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          // Google Map
          Expanded(
            child: Obx(() => GoogleMap(
                  initialCameraPosition: locationController.initialCameraPosition.value,
                  markers: locationController.markers,
                  onTap: (LatLng location) {
                    locationController.setLocation(location);
                  },
                  onMapCreated: (GoogleMapController controller) {
                    // Set the map controller for smooth camera animations
                    locationController.setMapController(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  mapToolbarEnabled: false,
                )),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: TSizes.md),
                Expanded(
                  child: Obx(() => ElevatedButton.icon(
                        onPressed: locationController.isLocationSet
                            ? () {
                                final location = locationController.currentLocation.value!;
                                final address = locationController.locationAddress.value;
                                onLocationSelected(location, address);
                                Navigator.pop(context);
                              }
                            : null,
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text(
                          'Select Location',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primary,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
