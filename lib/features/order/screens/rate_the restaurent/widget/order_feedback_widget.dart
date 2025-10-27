import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_divider.dart';
import 'package:foodu/common/widgets/custom_shapes/container/custom_text_field.dart';
import 'package:foodu/features/order/screens/rate_driver/widget/star_rating.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class OrderFeedbackWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final Function(int) onRatingChanged;

  const OrderFeedbackWidget(
      {required this.imageUrl, required this.title, required this.subtitle, required this.onRatingChanged, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              imageUrl,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium!.apply(color: isDark ? TColors.textWhite : TColors.textblack),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.textGrey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          const TCustomDivider(),
          StarRating(
            starSize: 30.0,
            onRatingChanged: onRatingChanged,
          ),
          const TCustomDivider(),
          const SizedBox(height: 8.0),
          TCustomTextField(height: 100, maxline: 3, hintText: "write your comment", textEditingController: TextEditingController())
        ],
      ),
    );
  }
}
