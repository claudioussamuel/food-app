import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class PaymentMethodItem extends StatelessWidget {
  final int index;
  final String label;
  final String image;
  final String? cardNumber;

  const PaymentMethodItem({
    super.key,
    required this.index,
    required this.label,
    required this.image,
    this.cardNumber,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85, // Set the height of the card
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.cardRadiusSm)),
        child: Center(
          child: ListTile(
            leading: Image.asset(image, height: 25),
            title: Text(label, style: Theme.of(context).textTheme.bodyMedium!.apply(fontWeightDelta: 2)),
            subtitle: cardNumber != null ? Text(cardNumber!) : null,
            trailing: Text("Connected", style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      ),
    );
  }
}
