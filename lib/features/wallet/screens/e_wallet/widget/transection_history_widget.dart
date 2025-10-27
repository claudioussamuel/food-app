import 'package:flutter/material.dart';
import 'package:foodu/common/widgets/images/t_circular_image.dart';
import 'package:foodu/features/wallet/controller/wallet_controller.dart';
import 'package:foodu/utils/constants/colors.dart';
import 'package:foodu/utils/constants/image_strings.dart';
import 'package:foodu/utils/helpers/helper_function.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TransactionHistoryWidget extends StatelessWidget {
  const TransactionHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WalletController.instance;
    final isDark = THelperFunctions.isDarkMode(context);
    return Expanded(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.transactions.length,
          itemBuilder: (context, index) {
            final transaction = controller.transactions[index];
            return ListTile(
              leading: TCircularImage(
                image: transaction['image'].toString(),
                padding: 4,
              ),
              // Image.asset(transaction['image'].toString(), width: 50, height: 50,),

              title: Text(transaction['title'].toString(),
                  style:
                      Theme.of(context).textTheme.bodyMedium!.apply(fontWeightDelta: 2, color: isDark ? Colors.white : TColors.textblack)),
              subtitle: Text(transaction['date'].toString(), style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.textGrey)),

              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("\$${transaction['amount']}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(fontWeightDelta: 2, color: isDark ? TColors.textWhite : TColors.textblack)),
                  SizedBox(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(transaction['type'].toString(), style: Theme.of(context).textTheme.bodySmall!.apply(color: TColors.textGrey)),
                        Image.asset(transaction['isCredit'] as bool ? TImages.topdown : TImages.topup)
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
