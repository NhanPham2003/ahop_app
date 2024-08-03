import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fashion_app/consts/colors.dart';
import 'package:fashion_app/widgets/price_widget.dart';
import 'package:fashion_app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({Key? key}) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  final _quantityTextController = TextEditingController();
  @override
  void initState() {
    _quantityTextController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? _isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? _isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(6),
        color: Theme.of(context).canvasColor,
        elevation: 1,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetails.routeName,
                arguments: productModel.id);
            // GlobalMethods.navigateTo(
            //     ctx: context, routeName: ProductDetails.routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: HeartBTN(
                  productId: productModel.id,
                  isInWishlist: _isInWishlist,
                )),
              Column(children: [
                FancyShimmerImage(
                  imageUrl: productModel.imageUrl,
                  height: size.width * 0.3,
                  width: size.width * 0.3,
                  boxFit: BoxFit.fill,
                ),

                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextWidget(
                          text: productModel.title,
                          color: color,
                          maxLines: 2,
                          textSize: 18,
                          isTitle: true,
                        ),
                      ),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 3,
                        child: PriceWidget(
                          salePrice: productModel.salePrice,
                          price: productModel.price,
                          textPrice: _quantityTextController.text,
                          isOnSale: productModel.isOnSale,
                        ),
                      ),
                      // Flexible(
                      //   child: Row(
                      //     children: [
                      //       const SizedBox(
                      //         width: 5,
                      //       ),
                      //       Flexible(
                      //           flex: 2,
                      //           // TextField can be used also instead of the textFormField
                      //           child: TextFormField(
                      //             controller: _quantityTextController,
                      //             key: const ValueKey('10'),
                      //             style: TextStyle(color: color, fontSize: 18),
                      //             keyboardType: TextInputType.number,
                      //             maxLines: 1,
                      //             enabled: true,
                      //             onChanged: (valueee) {
                      //               setState(() {});
                      //             },
                      //             inputFormatters: [
                      //               FilteringTextInputFormatter.allow(
                      //                 RegExp('[0-9.]'),
                      //               ),
                      //             ],
                      //           ))
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: _isInCart
                        ? null
                        : () async {
                      // if (_isInCart) {
                      //   return;
                      // }
                      final User? user = authInstance.currentUser;

                      if (user == null) {
                        GlobalMethods.errorDialog(
                            subtitle: 'No user found, Please login first',
                            context: context);
                        return;
                      }
                      await GlobalMethods.addToCart(
                          productId: productModel.id,
                          quantity: int.parse(_quantityTextController.text),
                          context: context);
                      await cartProvider.fetchCart();
                      // cartProvider.addProductsToCart(
                      //     productId: productModel.id,
                      //     quantity: int.parse(_quantityTextController.text));
                    },
                    style: ButtonStyle(
                        backgroundColor:_isInCart ? MaterialStateProperty.all(Colors.black12):
                        MaterialStateProperty.all(AppColor.primaryColor),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6),
                            ),
                          ),
                        )),
                    child: TextWidget(
                      text: _isInCart ? 'Đã thêm' : 'Thêm vào giỏ',
                      maxLines: 1,
                      color: Colors.white,
                      textSize: 20,
                    ),
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }

}