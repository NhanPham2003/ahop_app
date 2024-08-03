import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/consts/colors.dart';
import 'package:fashion_app/consts/consts_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../inner_screens/feeds_screen.dart';
import '../inner_screens/on_sale_screen.dart';
import '../models/product.dart';
import '../providers/products_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';
import '../widgets/feed_items.dart';
import '../widgets/on_sale_widget.dart';
import '../widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    final Color color = Utils(context).color;
    Size size = utils.getScreenSize;
    final productProviders = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProviders.getProducts;
    List<ProductModel> productsOnSale = productProviders.getOnSaleProducts;
    ProductsProvider provider = ProductsProvider();
    return Scaffold(
      body: RefreshIndicator(
        color: AppColor.primaryColor,
        backgroundColor: Colors.white,
        onRefresh:() async{
          await Future.delayed(Duration(seconds: 3));
          await provider.fetchProducts();
      },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: getBanner(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> imageUrls =
                        (snapshot.data as List<String>?) ?? [];
                    return SizedBox(
                      height: size.height * 0.25,
                      child: Swiper(
                        autoplay: true,
                        itemCount: imageUrls.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(imageUrls[index],
                              fit: BoxFit.cover);
                        },
                        pagination: const SwiperPagination(),
                        control: const SwiperControl(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 8.0),
                child: SizedBox(
                  width: 110,
                  height: 18,
                  child: InkWell(
                    onTap: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: OnSaleScreen.routeName);
                    },
                    child: Image.asset(
                      'assets/images/flashsale.png',
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: size.height * 0.24,
                      child: ListView.builder(
                          itemCount: productsOnSale.length < 10
                              ? productsOnSale.length
                              : 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, index) {
                            return ChangeNotifierProvider.value(
                                value: productsOnSale[index],
                                child: const OnSaleWidget());
                          }),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: ' Sản Phẩm',
                      color: color,
                      textSize: 20,
                      isTitle: true,
                    ),
                    // const Spacer(),

                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                // crossAxisSpacing: 10,
                childAspectRatio: size.width / (size.height * 0.61),
                children: List.generate(
                    allProducts.length < 8
                        ? allProducts.length
                        : 8, (index) {
                  return ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child: const FeedsWidget(),
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: FeedsScreen.routeName);
                    },
                    child: TextWidget(
                      text: 'Xem thêm >',
                      maxLines: 1,
                      color: color,
                      textSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> getBanner() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('banners').get();

      List<String> imageUrls = [];

      querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('imageUrl')) {
          String imageUrl = data['imageUrl'];
          imageUrls.add(imageUrl);
        }
      });

      return imageUrls;
    } catch (error) {
      print('Lỗi khi lấy dữ liệu: $error');
      throw error;
    }
  }

}
