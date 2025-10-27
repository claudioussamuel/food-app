import 'package:flutter/cupertino.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class BuildSectionTitle extends StatelessWidget {
  const BuildSectionTitle({super.key, required this.title, this.actionLabel, this.onAction});

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final titleTextStyle = TextStyle(
        fontSize: 16.0,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.bold,
        color: isDark ? TColors.textWhite : TColors.textblack);

    if (actionLabel == null || onAction == null) {
      return Text(title, style: titleTextStyle);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleTextStyle),
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onAction,
          child: Text(
            actionLabel!,
            style: TextStyle(
              fontSize: 14.0,
              color: TColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
