import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/custom_shapes/container/rounded_container.dart';
import '../../../../common/widgets/layouts/sliding_panel.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controller/location_controller.dart';

class SetYourLocation extends StatelessWidget {
  const SetYourLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final locationController = Get.put(LocationController());

    return Scaffold(
      body: TSlidingPanel(
        // Panel configuration: adjust heights as you like
        initialHeight: 450,
        minPanelHeight: 100,
        maxPanelHeight: THelperFunctions.screenHeight() * 0.65,

        // ───► Map in the background
        body: Obx(() => GoogleMap(
              initialCameraPosition:
                  locationController.initialCameraPosition.value,
              markers: locationController.markers,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              onTap: (LatLng position) {
                locationController.setLocation(position);
              },
              onMapCreated: (GoogleMapController controller) {
                // Set the map controller for smooth camera animations
                locationController.setMapController(controller);
                // Get current location when map is created
                locationController.getCurrentLocation();
              },
            )),

        // ───► Sliding panel overlay
        panel: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          width: double.infinity,
          child: TRoundedContainer(
            backgroundColor:
                isDark ? TColors.backgroundDark : TColors.backgroundLight,
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header Row: "Location" + Current Location Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Location",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Obx(() => IconButton(
                            onPressed: locationController
                                    .isLoadingLocation.value
                                ? null
                                : () => locationController.getCurrentLocation(),
                            icon: locationController.isLoadingLocation.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Icon(Iconsax.location),
                          )),
                    ],
                  ),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // ── Search Field
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.search_normal),
                      hintText: 'Search for a location...',
                      filled: true,
                      fillColor: isDark
                          ? TColors.backgroundDark
                          : TColors.backgroundLight,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
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

                  const SizedBox(height: TSizes.spaceBtwItems),

                  // ── Location Suggestions
                  Obx(() {
                    if (locationController.placeSuggestions.isNotEmpty) {
                      return Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: locationController.placeSuggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion =
                                locationController.placeSuggestions[index];
                            return ListTile(
                              leading: const Icon(Iconsax.location),
                              title: Text(
                                suggestion['description'] ?? '',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              onTap: () =>
                                  locationController.selectPlace(suggestion),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  // ── Selected Location Display
                  Obx(() => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? TColors.darkCard
                              : TColors.backgroundLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Iconsax.location, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                locationController.locationSummary,
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: TSizes.spaceBtwSection),

                  // ── Label Field
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.tag),
                      labelText: 'Label',
                      hintText: 'Enter label for this location',
                      filled: true,
                      fillColor: isDark
                          ? TColors.backgroundDark
                          : TColors.backgroundLight,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    onChanged: (value) =>
                        locationController.updateLocationLabel(value),
                  ),

                  const SizedBox(height: TSizes.spaceBtwSection),

                  // ── Continue button
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: locationController.isLocationSet
                              ? () => Get.back()
                              : null,
                          child: const Text("Continue"),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),

        // ───► Floating "current location" button
        floatingWidget: Positioned(
          top: 16,
          right: 16,
          child: Obx(() => FloatingActionButton(
                onPressed: locationController.isLoadingLocation.value
                    ? null
                    : () => locationController.getCurrentLocation(),
                backgroundColor: TColors.primary,
                child: locationController.isLoadingLocation.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.my_location, color: Colors.white),
              )),
        ),
      ),
    );
  }
}
