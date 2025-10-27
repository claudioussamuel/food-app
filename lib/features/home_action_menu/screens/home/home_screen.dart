import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/app_bar/app_bar.dart';
import 'package:foodu/common/widgets/button/title_with_text_button.dart';
import 'package:foodu/common/widgets/custom_shapes/container/search_container.dart';
import 'package:foodu/features/home_action_menu/controller/home_controller.dart';
import 'package:foodu/features/home_action_menu/controller/branch_controller.dart';
import 'package:foodu/features/home_action_menu/controller/cart_controller.dart';
import 'package:foodu/features/restaurant_details_and_food_place_order/screen/checkout_order/checkout_order_screen.dart';
import 'package:foodu/features/home_action_menu/screens/home/widget/action_icon.dart';
import 'package:foodu/features/home_action_menu/screens/home/widget/branch_selector.dart';
import 'package:foodu/features/home_action_menu/screens/home/widget/chip_list_row.dart';
import 'package:foodu/features/home_action_menu/screens/home/widget/horizental_food_list.dart';
import 'package:foodu/features/home_action_menu/screens/home/widget/verical_food_list.dart';
import 'package:foodu/features/home_action_menu/screens/recommanded_for_you/recommanded_for_you_screen.dart';
import 'package:foodu/features/home_action_menu/screens/search/search_screen.dart';
import 'package:foodu/features/personalization/controller/profile_form_controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Get greeting based on current time
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  /// Custom AppBar that supports reactive profile data
  PreferredSizeWidget _buildReactiveAppBar(
      BuildContext context, ProfileFormController profileController) {
    return PreferredSize(
      preferredSize:
          const Size.fromHeight(TSizes.homeAppBarHeight + TSizes.defaultSpace),
      child: Obx(() => TAppBar(
            // User Image - Use profile image if available, otherwise use default
            leadingImage: profileController
                    .currentProfile.value?.profileImagePath ??
                "https://firebasestorage.googleapis.com/v0/b/food-9d1af.firebasestorage.app/o/profile_images%2F1757320438653_34.jpg?alt=media&token=d40a3658-19bb-433d-9892-585af3ff23fa",
            increaseAppbarSpace: TSizes.defaultSpace,
            height: TSizes.homeAppBarHeight,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(getGreeting(),
                    style: Theme.of(context).textTheme.labelSmall),

                // User Name - Use profile name if available, otherwise use default
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          profileController.currentProfile.value?.fullName ??
                              'Opoku Mensah',
                          style: Theme.of(context).textTheme.labelLarge!.apply(
                              color: THelperFunctions.isDarkMode(context)
                                  ? TColors.textWhite
                                  : TColors.textblack),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// Notification and Cart Icons
            actions: [
              // ActionIcon(
              //     onTap: () => Get.to(const NotificationScreen()),
              //     iconData: Iconsax.notification),
              const Gap(TSizes.sm),
              Obx(() {
                final cartController = Get.find<CartController>();
                return ActionIcon(
                  onTap: () => Get.to(const CheckoutOrderScreen()),
                  iconData: Iconsax.shopping_cart,
                  badgeCount: cartController.itemCount,
                );
              }),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    Get.put(BranchController(), permanent: true);

    // Initialize ProfileFormController to access user profile data
    final profileController = Get.put(ProfileFormController(), permanent: true);

    // Load user profile data when home screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileController.loadCurrentUserProfile();
    });

    return SafeArea(
      child: Scaffold(
        appBar: _buildReactiveAppBar(context, profileController),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
            child: Column(
              children: [
                /// Branch Selector Section
                const BranchSelector(),
                const SizedBox(height: TSizes.spaceBtwItems),

                /// SearchBar Section
                GestureDetector(
                    onTap: () => Get.to(const SearchScreen()),
                    child:
                        const TSearchContainer(text: 'What are you craving?')),
                const SizedBox(height: TSizes.spaceBtwSection),

                /// Banners Section
                // TRowWithTextButton(
                //     title: 'Special Offer',
                //     onTap: () => Get.to(DiscountScreen())),
                // const SizedBox(height: TSizes.spaceBtwItems),
                // const DiscountImage(imagePath: TImages.banner4),
                // const SizedBox(height: TSizes.spaceBtwSection),

                /// Categories Section
                // const CategoryGridView(),
                // const SizedBox(height: TSizes.spaceBtwSection),

                /// Discount Guaranteed Section
                TRowWithTextButton(
                  title: 'Fast Sales',
                  onTap: () => Get.to(
                    const RecommandedForYouScreen(),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                const HorizontalFoodList(),
                const SizedBox(height: TSizes.spaceBtwSection),

                /// Recommended Section
                TRowWithTextButton(
                  title: 'Recommended For You',
                  onTap: () => Get.to(
                    const RecommandedForYouScreen(),
                  ),
                ),
                const ChipListRow(),
                const VerticalFoodList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
