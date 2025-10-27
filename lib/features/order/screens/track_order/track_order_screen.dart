// import 'package:flutter/material.dart';
// import 'package:foodu/features/order/screens/cancel_order/cancel_order_screen.dart';
// import 'package:foodu/features/order/screens/track_order/driver_information/driver_information.dart';
// import 'package:foodu/features/order/screens/track_order/widget/driver_card_info.dart';
// import 'package:foodu/utils/constants/colors.dart';
// import 'package:foodu/utils/constants/image_strings.dart';
// import 'package:foodu/utils/helpers/helper_function.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import '../../../../common/widgets/custom_shapes/container/rounded_container.dart';
// import '../../../../common/widgets/layouts/sliding_panel.dart';

// class TrackOrderScreen extends StatelessWidget {
//   const TrackOrderScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = THelperFunctions.isDarkMode(context);
//     // Dummy map center (e.g. London)
//     const LatLng dummyCenter = LatLng(51.5074, -0.1278);
//     const Marker dummyMarker = Marker(
//       markerId: MarkerId('dummy_marker'),
//       position: dummyCenter,
//       infoWindow: InfoWindow(title: 'Dummy Location'),
//     );
//     return Scaffold(
//       body: TSlidingPanel(
//         // Panel configuration: adjust heights as you like
//         initialHeight: 280,
//         minPanelHeight: 100,
//         maxPanelHeight: THelperFunctions.screenHeight() * 0.45,

//         // ───► Map in the background
//         body: GoogleMap(
//           initialCameraPosition: const CameraPosition(
//             target: dummyCenter,
//             zoom: 14.0,
//           ),
//           markers: {dummyMarker},
//           mapType: MapType.normal,
//           zoomControlsEnabled: false,
//           myLocationEnabled: false,
//           myLocationButtonEnabled: false,
//         ),

//         // ───► Sliding panel overlay
//         panel: SizedBox(
//           height: MediaQuery.of(context).size.height * 0.40,
//           width: double.infinity,
//           child: TRoundedContainer(
//             backgroundColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 InkWell(
//                   onTap: () => Get.to(const DriverInformationScreen()),
//                   child: DriverInfoCard(
//                     driverName: 'Rayfore Chanil',
//                     vehicleName: 'Yamaha mx king',
//                     vehiclePlate: 'HSW 476 XK',
//                     rating: 4.5,
//                     driverImageUrl: TImages.pic,
//                     onCancel: () => Get.to(const CancelOrderScreen()),
//                     onMessage: () {},
//                     onCall: () {},
//                   ),
//                 ),
//                 // ── Header Row: "Location Name" + Search Icon
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //   children: [
//                 //     Text(
//                 //       "Location",
//                 //       style: Theme.of(context).textTheme.titleMedium,
//                 //     ),
//                 //     IconButton(
//                 //       onPressed: () {
//                 //         // Design only: no action
//                 //       },
//                 //       icon: const Icon(CupertinoIcons.search),
//                 //     ),
//                 //   ],
//                 // ),
//                 //
//                 // const SizedBox(height: TSizes.spaceBtwItems),
//                 //
//                 // // ── Selected Location Placeholder
//                 // Text(
//                 //   '123 Example Street, London',
//                 //   // In a real app, replace with dynamic address text
//                 //   style: Theme.of(context).textTheme.bodyMedium,
//                 //   maxLines: 1,
//                 //   overflow: TextOverflow.ellipsis,
//                 // ),
//                 //
//                 // const SizedBox(height: TSizes.spaceBtwSection),
//                 //
//                 // // ── Name
//                 // Form(
//                 //   child: Column(
//                 //     children: [
//                 //       // Name field
//                 //       TextFormField(
//                 //         decoration: InputDecoration(
//                 //           prefixIcon: const Icon(CupertinoIcons.person),
//                 //           labelText: 'Label',
//                 //           hintText: 'Enter label for Location',
//                 //           filled: true,
//                 //           fillColor: isDark ? TColors.backgroundDark : TColors.backgroundLight,
//                 //           enabledBorder: OutlineInputBorder(
//                 //             borderRadius: BorderRadius.circular(12),
//                 //             borderSide: BorderSide(color: Theme.of(context).primaryColor),
//                 //           ),
//                 //         ),
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 //
//                 // const SizedBox(height: TSizes.spaceBtwSection),
//                 //
//                 // // ── Confirm button
//                 // SizedBox(
//                 //   width: double.infinity,
//                 //   child: ElevatedButton(
//                 //     onPressed: () {},
//                 //     child: const Text("Continue"),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
