
import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class TRowWithTextButton extends StatelessWidget {
  const TRowWithTextButton({
    super.key, required this.title, required this.onTap,
  });
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style:  Theme.of(context).textTheme.headlineSmall!.apply(color: isDark ? TColors.textWhite :TColors.textblack),),
        InkWell(onTap: onTap,child: Text('See All',style: Theme.of(context).textTheme.labelLarge,))
      ],
    );
  }
}