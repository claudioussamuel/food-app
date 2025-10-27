import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/home_action_menu/screens/home/widget/verical_food_list.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        showBackButton: true,
        title: Text("My Favourite Restaurent"),
      ),
      body: Padding(
        padding: TSpacingStyles.paddingWithHeightWidth,
        child: const VerticalFoodList(),
      ),
    );
  }
}
