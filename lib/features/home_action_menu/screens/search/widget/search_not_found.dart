import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:gap/gap.dart';

class SearchNotFound extends StatelessWidget {
  const SearchNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Gap(50),
        SizedBox(
            width: double.infinity,
            child: Image.asset(
              TImages.searchNotFound,
              fit: BoxFit.cover,
            )),
        const Gap(20),
        Text('Not Found', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        const Gap(20),
        Text('Sorry, the keyword you entered cannot be found, please check again or search with another keyword.',
            textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium)
      ],
    );
  }
}
