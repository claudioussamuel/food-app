import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/helpers/helper_function.dart';

class TExpandableText extends StatefulWidget {
  const TExpandableText({super.key, required this.text});

  final String text;

  @override
  State<TExpandableText> createState() => _TExpandableTextState();
}

class _TExpandableTextState extends State<TExpandableText> {
  late String firstHalf;
  late String secondHalf;
  bool hiddenText = true;
  double textHeight = THelperFunctions.screenHeight() / 5.63;

  @override
  void initState() {
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(firstHalf)
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hiddenText ? ("$firstHalf...") : (firstHalf + secondHalf), style: Theme.of(context).textTheme.labelSmall),
                InkWell(
                  onTap: () {
                    setState(() {
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(hiddenText ? "Read more" : 'Read less', style: Theme.of(context).textTheme.titleSmall!.apply(color: TColors.primary)),
                      Icon(hiddenText ? Icons.arrow_drop_down : Icons.arrow_drop_up, color: TColors.primary)
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
