import 'package:fashion_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';

import '../consts/colors.dart';
import '../inner_screens/feeds_screen.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {Key? key,
        required this.imagePath,
        required this.title,
        required this.subtitle,
        required this.buttonText})
      : super(key: key);
  final String imagePath, title, subtitle, buttonText;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final themeState = Utils(context).getTheme;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: size.height * 0.4,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Ôi không!',
                    style: TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextWidget(text: subtitle, color: color, textSize: 20),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        // side: BorderSide(
                        //   color: color,
                        // ),
                      ),
                      primary: AppColor.primaryColor,
                      // onPrimary: color,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    ),
                    onPressed: () {
                      GlobalMethods.navigateTo(
                          ctx: context, routeName: FeedsScreen.routeName);
                    },
                    child: TextWidget(
                      text: buttonText,
                      textSize: 20,
                      color: Colors.white,
                      isTitle: true,
                    ),
                  ),
                ]),
          )),
    );
  }
}