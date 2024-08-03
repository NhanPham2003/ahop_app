import 'package:fashion_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../inner_screens/category_screen.dart';
import '../providers/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget(
      {Key? key,
        required this.catText,
        required this.imgPath,
        required this.passedColor})
      : super(key: key);
  final String catText, imgPath;
  final Color passedColor;
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    final themeState = Provider.of<DarkThemeProvider>(context);
    double _screenWidth = MediaQuery.of(context).size.width;
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryScreen.routeName,
            arguments: catText);
      },
      child: Card(
        elevation: 1,
        color: Theme.of(context).canvasColor,
        // height: _screenWidth * 0.6,
        // decoration: BoxDecoration(
        //   color: passedColor.withOpacity(0.1),
        //   borderRadius: BorderRadius.circular(16),
        //   border: Border.all(
        //     color: passedColor.withOpacity(0.7),
        //     width: 2,
        //   ),
        // ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Container(
            height: _screenWidth * 0.3,
            width: _screenWidth * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                    imgPath,
                  ),
                  fit: BoxFit.fitWidth),
            ),
          ),
          // Category name
          TextWidget(
            text: catText,
            color: color,
            textSize: 20,
            isTitle: true,
          ),
        ]),
      ),
    );
  }
}