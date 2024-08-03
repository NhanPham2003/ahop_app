import 'package:fashion_app/consts/colors.dart';
import 'package:fashion_app/consts/consts_data.dart';
import 'package:fashion_app/providers/cart_provider.dart';
import 'package:fashion_app/providers/wishlist_provider.dart';
import 'package:fashion_app/screens/btm_bar.dart';
import 'package:fashion_app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'consts/firebase_const.dart';
import 'providers/products_provider.dart';

class FetchScreen extends StatefulWidget {
  const FetchScreen({Key? key}) : super(key: key);

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  List<String> images = ConstData.authImagesPaths;
  @override
  void initState() {
    images.shuffle();
    Future.delayed(const Duration(seconds: 2), () async {
      final productsProvider =
      Provider.of<ProductsProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final wishlistProvider =
      Provider.of<WishlistProvider>(context, listen: false);
      final User? user = authInstance.currentUser;
      if (user == null) {
        await productsProvider.fetchProducts();
        cartProvider.clearLocalCart();
        wishlistProvider.clearLocalWishlist();
      } else {
        await productsProvider.fetchProducts();
        await cartProvider.fetchCart();
        await wishlistProvider.fetchWishlist();
      }

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => const BottomBarScreen(),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: Stack(
        children: [
          Center(
            child: Image.asset("assets/images/logo-01.png"),
            ),
        ],
      ),
    );
  }
}