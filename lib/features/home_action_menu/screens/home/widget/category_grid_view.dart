import 'package:flutter/cupertino.dart';
import 'package:foodu/common/widgets/custom_shapes/container/image_text_category_container.dart';
import 'package:foodu/features/home_action_menu/controller/home_controller.dart';
import 'package:foodu/features/home_action_menu/screens/category/category_screen.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';

class CategoryGridView extends StatelessWidget {
  const CategoryGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;
    return SizedBox(
      height: THelperFunctions.screenHeight() / 5.3,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemCount: controller.categoryName.length,
        itemBuilder: (context, index) {
          return TImageTextCategoryContainer(
            image: controller.categoryImage[index],
            text: controller.categoryName[index],
            onTap: () {
              Get.to(const CategoryScreen());
            },
          );
        },
      ),
    );
  }
}
