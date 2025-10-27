import 'package:flutter/material.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/sizes.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String description;
  final String status;

  const NotificationCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(TSizes.md)),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Leading Icon with Background according to title
                if (title == 'Orders Successful!')
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.lock, color: Colors.white, size: TSizes.lg),
                  ),
                if (title == 'Orders Cancelled!')
                  const CircleAvatar(
                    backgroundColor: Color(0x14F75555),
                    child: Icon(Icons.close, color: Color(0xffFF8A9B), size: TSizes.lg),
                  ),
                if (title == 'New Services Available!')
                  const CircleAvatar(
                    backgroundColor: Color(0x14FF9800),
                    child: Icon(Icons.home_repair_service, color: Color(0xffFFAB38), size: TSizes.lg),
                  ),
                if (title == 'Credit Card Connected!')
                  const CircleAvatar(
                    backgroundColor: Color(0x14246BFD),
                    child: Icon(Icons.credit_card, color: Color(0xff5089FF), size: TSizes.lg),
                  ),
                if (title == 'Account Setup Successful!')
                  const CircleAvatar(
                    backgroundColor: Color(0x141BAC4B),
                    child: Icon(Icons.person, color: Color(0xff46D375), size: TSizes.lg),
                  ),
                const SizedBox(width: TSizes.sm),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Card Title
                          Text(title, style: Theme.of(context).textTheme.bodySmall),

                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: TSizes.sm, vertical: TSizes.xs),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(TSizes.cardRadiusMd)),
                            child: Text(status, style: Theme.of(context).textTheme.labelSmall!.apply(color: Colors.white)),
                          ),
                        ],
                      ),
                      Text('$date | $time', style: Theme.of(context).textTheme.labelSmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.xm),
            Text(description, style: Theme.of(context).textTheme.labelSmall!.apply(color: TColors.textblack)),
          ],
        ),
      ),
    );
  }
}
