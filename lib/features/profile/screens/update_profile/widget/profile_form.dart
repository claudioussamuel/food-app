import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/login_signup/phone_number_field.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';
import 'package:foodu/utils/constants/text_strings.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../../../../personalization/controller/profile_form_controller.dart';
import '../../../../personalization/screens/profile_form/widget/gender_selection_button.dart';
import '../../../../personalization/screens/profile_form/widget/profile_pic_selection.dart';
import '../../../../personalization/screens/profile_form/widget/text_icon_container.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final controller = ProfileFormController.instance;
    return Form(
        child: SizedBox(
      height: THelperFunctions.screenHeight() / 1.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Profile Image
          const ProfilePicSelection(),

          /// First name
          TextFormField(
            controller: controller.firstNameController,
            textAlignVertical: TextAlignVertical.bottom,
            cursorColor: TColors.primary,
            cursorHeight: TSizes.lg,
            style: Theme.of(context).textTheme.bodySmall,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              hintText: TTexts.firstName,
              fillColor: isDark ? TColors.darkCard : TColors.textFieldFillColor,
              hintStyle: Theme.of(context).textTheme.titleSmall,
            ),
          ),

          /// Last name
          TextFormField(
            controller: controller.lastNameController,
            textAlignVertical: TextAlignVertical.bottom,
            cursorColor: TColors.primary,
            cursorHeight: TSizes.lg,
            style: Theme.of(context).textTheme.bodySmall,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_2),
              hintText: TTexts.lastName,
              fillColor: isDark ? TColors.darkCard : TColors.textFieldFillColor,
              hintStyle: Theme.of(context).textTheme.titleSmall,
            ),
          ),

          /// Email
          TextFormField(
            controller: controller.emailController,
            textAlignVertical: TextAlignVertical.bottom,
            cursorColor: TColors.primary,
            cursorHeight: TSizes.lg,
            style: Theme.of(context).textTheme.bodySmall,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              hintText: TTexts.email,
              fillColor: isDark ? TColors.darkCard : TColors.textFieldFillColor,
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
                  lastDate: DateTime.now(),
                );
                controller.dateOfBirth.value =
                    DateFormat('dd/MM/yyyy').format(date!);
              },
              text: controller.dateOfBirth.value,
              iconData: Icons.calendar_month_rounded,
            ),
          ),

          /// Mobile Number
          const TPhoneNumberField(),

          /// Gender
          const GenderSelectionButton(),
        ],
      ),
    ));
  }
}
