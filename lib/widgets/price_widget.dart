import 'package:fashion_app/consts/colors.dart';
import 'package:fashion_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/utils.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key? key,
    required this.salePrice,
    required this.price,
    required this.textPrice,
    required this.isOnSale,
  }) : super(key: key);
  final double salePrice, price;
  final String textPrice;
  final bool isOnSale;
  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,###,###');
    final Color color = Utils(context).color;
    double userPrice = isOnSale? salePrice : price;
    return FittedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: '₫${formatter.format(userPrice * int.parse(textPrice))}',
              color: AppColor.primaryColor,
              textSize: 18,
            ),
            const SizedBox(
              width: 5,
            ),
            Visibility(
              visible: isOnSale? true :false,
              child: Text(
                '₫${formatter.format(price * int.parse(textPrice))}',
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColor.subTextColor,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
          ],
        ));
  }
}