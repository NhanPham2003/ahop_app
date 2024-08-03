import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fashion_app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_const.dart';
import '../inner_screens/on_sale_screen.dart';
import '../inner_screens/product_details.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import 'heart_btn.dart';
import 'price_widget.dart';

class OnSaleWidget extends StatefulWidget {
  const OnSaleWidget({Key? key}) : super(key: key);

  @override
  State<OnSaleWidget> createState() => _OnSaleWidgetState();
}

class _OnSaleWidgetState extends State<OnSaleWidget> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    final theme = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.getWishlistItems.containsKey(productModel.id);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(6),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          child: Stack(
              children: [
            FancyShimmerImage(
              imageUrl: productModel.imageUrl,
              height: size.width * 0.3,
              width: size.width * 0.3,
              boxFit: BoxFit.fitWidth,
            ),
            Positioned(
              bottom: 8,

              left: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  TextWidget(
                    text: productModel.title,
                    color: color,
                    textSize: 16,
                    isTitle: true,
                  ),
                  PriceWidget(
                    salePrice: productModel.salePrice,
                    price: productModel.price,
                    textPrice: '1',
                    isOnSale: true,
                  ),

                  // const SizedBox(height: 5),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: _isInCart
                  //           ? null
                  //           : () async {
                  //         final User? user =
                  //             authInstance.currentUser;
                  //
                  //         if (user == null) {
                  //           GlobalMethods.errorDialog(
                  //               subtitle:
                  //               'No user found, Please login first',
                  //               context: context);
                  //           return;
                  //         }
                  //         await GlobalMethods.addToCart(
                  //             productId: productModel.id,
                  //             quantity: 1,
                  //             context: context);
                  //         await cartProvider.fetchCart();
                  //         // cartProvider.addProductsToCart(
                  //         //     productId: productModel.id,
                  //         //     quantity: 1);
                  //       },
                  //       child: Text(
                  //         _isInCart
                  //             ? 'Xóa khỏi giỏ'
                  //             : 'Thêm vào giỏ',
                  //         style: TextStyle(
                  //           color: _isInCart ? Colors.green : color,
                  //         ),
                  //
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [

                      HeartBTN(
                        productId: productModel.id,
                        isInWishlist: _isInWishlist,
                      )
                    ],
                  ),
                ),
          ]),
        ),
      ),
    );
  }
}
