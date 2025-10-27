import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/order/screens/track_order/driver_information/widget/driver_information_card.dart';
import 'package:foodu/utils/constants/image_strings.dart';

class DriverInformationScreen extends StatelessWidget {
  const DriverInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar(
        showBackButton: true,
        title: Text("Driver Information"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DriverInformationCard(
            driverName: 'Rayford Chenail',
            driverPhoneNumber: '+1 800 555 0199',
            driverImageUrl: TImages.pic,
            rating: 4.8,
            orders: 425,
            years: 4,
            memberSince: 'July 15, 2019',
            vehicleModel: 'Yamaha MX King',
            plateNumber: 'HSW 4736 XK',
          ),
        ],
      ),
    );
  }
}
