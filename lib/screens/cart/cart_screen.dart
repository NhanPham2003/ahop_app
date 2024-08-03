import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/consts/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../consts/firebase_const.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';
import 'cart_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemsList =
    cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemsList.isEmpty
        ? const EmptyScreen(
      title: 'ohhh',
      subtitle: 'Giỏ của bạn trống trơn',
      buttonText: 'Mua ngay',
      imagePath: 'assets/images/box.png',
    )
        : Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: TextWidget(
            text: 'Giỏ hàng (${cartItemsList.length})',
            color: color,
            isTitle: true,
            textSize: 22,
          ),
          actions: [
            IconButton(
              onPressed: () {
                GlobalMethods.warningDialog(
                    title: 'Xóa giỏ hàng của bạn?',
                    subtitle: 'Bạn có chắc không?',
                    fct: () async {
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                    },
                    context: context);
              },
              icon: Icon(
                IconlyLight.delete,
                color: color,
              ),
            ),
          ]),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItemsList.length,
              itemBuilder: (ctx, index) {
                return ChangeNotifierProvider.value(
                    value: cartItemsList[index],
                    child: CartWidget(
                      q: cartItemsList[index].quantity,
                    ));
              },
            ),
          ),
          _checkout(ctx: context),
        ],
      ),
    );
  }

  Widget _checkout({required BuildContext ctx}) {
    final formatter = NumberFormat('###,###,###');
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(ctx);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.findProdById(value.productId);
      total += (getCurrProduct.isOnSale
          ? getCurrProduct.salePrice
          : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      // color: ,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            FittedBox(
              child: TextWidget(
                text: 'Tổng: ₫${formatter.format(total)}',
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            ),
            const Spacer(),
            Material(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () async {
                  User? user = authInstance.currentUser;

                  final productProvider =
                  Provider.of<ProductsProvider>(ctx, listen: false);

                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrProduct = productProvider.findProdById(
                      value.productId,
                    );
                    try {
                      final orderId = const Uuid().v4();
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getCurrProduct.isOnSale
                            ? getCurrProduct.salePrice
                            : getCurrProduct.price) *
                            value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getCurrProduct.imageUrl,
                        'userName': user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                      await cartProvider.clearOnlineCart();
                      cartProvider.clearLocalCart();
                      ordersProvider.fetchOrders();
                      await Fluttertoast.showToast(
                        msg: "Đơn hàng của bạn đã được đặt",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: error.toString(), context: ctx);
                    } finally {}
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                    text: 'Mua ngay',
                    textSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}