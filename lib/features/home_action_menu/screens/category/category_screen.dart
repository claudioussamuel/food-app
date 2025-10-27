import 'package:flutter/material.dart';
import 'package:foodu/common/styles/spacing_styles.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/features/home_action_menu/controller/category_controller.dart';
import 'package:foodu/features/home_action_menu/screens/category/widget/category_grid_view.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CategoryController());
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'More Category',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        showBackButton: true,
      ),
      body: Padding(
        padding: TSpacingStyles.paddingWithHeightWidth,
        child: const CategoryGridView(),
      ),
    );
  }
}
