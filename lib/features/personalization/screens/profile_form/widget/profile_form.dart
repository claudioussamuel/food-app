import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/login_signup/phone_number_field.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/constants/text_strings.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../../../../profile/screens/update_profile/widget/gender_selection_button.dart';
import '../../../../profile/screens/update_profile/widget/profile_pic_selection.dart';
import '../../../../profile/screens/update_profile/widget/text_icon_container.dart';
import '../../../controller/profile_form_controller.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    // Initialize ProfileFormController to access user profile data
    final profileController = Get.put(ProfileFormController(), permanent: true);
    return Form(
        child: SizedBox(
      height: THelperFunctions.screenHeight() / 1.5,
      child: Obx(() {
        // Show loading indicator while profile data is being loaded
        if (profileController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Profile Image
            const ProfilePicSelection(),

            /// First name
            TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              controller: profileController.firstNameController,
              cursorColor: TColors.primary,
              cursorHeight: TSizes.lg,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                hintText: TTexts.firstName,
                fillColor:
                    isDark ? TColors.darkCard : TColors.textFieldFillColor,
                hintStyle: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            /// Last name
            TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              controller: profileController.lastNameController,
              cursorColor: TColors.primary,
              cursorHeight: TSizes.lg,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_2),
                hintText: TTexts.lastName,
                fillColor:
                    isDark ? TColors.darkCard : TColors.textFieldFillColor,
                hintStyle: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            /// Email
            TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              controller: profileController.emailController,
              cursorColor: TColors.primary,
              cursorHeight: TSizes.lg,
              style: Theme.of(context).textTheme.bodySmall,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                fillColor:
                    isDark ? TColors.darkCard : TColors.textFieldFillColor,
                hintText: TTexts.email,
                hintStyle: Theme.of(context).textTheme.titleSmall,
              ),
            ),

            /// Date of Birth
            Obx(
              () => TextIconContainer(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    // Starting Date of the calender
                    firstDate: DateTime(1950),
                    // End Date of the calender
                    lastDate: DateTime(2024),
                  );
                  if (date != null) {
                    profileController.dateOfBirth.value =
                        DateFormat('dd/MM/yyyy').format(date);
                  }
                },
                text: profileController.dateOfBirth.value,
                iconData: Icons.calendar_month_rounded,
              ),
            ),

            /// Mobile Number
            const TPhoneNumberField(),

            /// Gender
            const GenderSelectionButton(),
          ],
        );
      }),
    ));
  }
}
