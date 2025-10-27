
import 'package:flutter/cupertino.dart';
import 'package:foodu/utils/constants/colors.dart';

class TCustomDivider extends StatelessWidget {
  const TCustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: double.infinity,
        color: TColors.borderGrey,
        height: 1,
      ),
    );
  }
}