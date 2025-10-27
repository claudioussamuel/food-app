import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';

class FilterSection extends StatelessWidget {
  final String title;
  final List<String> options;
  final dynamic selectedOptions;
  final Function(int) onOptionSelected;
  final bool radioButton;

  const FilterSection({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
    required this.radioButton,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return radioButton
                    ? RadioListTile(
                        dense: true,
                        value: index,
                        activeColor: TColors.primary,
                        groupValue: selectedOptions,
                        // Compare with the integer index
                        onChanged: (value) => onOptionSelected(index),
                        title: Text(options[index], style: Theme.of(context).textTheme.bodySmall),
                      )
                    : CheckboxListTile(
                        dense: true,
                        value: selectedOptions[index],
                        onChanged: (value) => onOptionSelected(index),
                        title: Text(
                          options[index],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
