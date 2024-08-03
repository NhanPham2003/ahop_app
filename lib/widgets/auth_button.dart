import 'package:fashion_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.fct,
    required this.buttonText,
    required this.primary,
  }) : super(key: key);
  final Function fct;
  final String buttonText;
  final Color primary;
  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: primary, // background (button) color
          ),
          onPressed: () {
            fct();
            // _submitFormOnLogin();
          },
          child: Container(
            padding: EdgeInsets.all(13),
            child: TextWidget(
              text: buttonText,
              textSize: 18,
              color: Colors.white,
            ),
          )),
    );
  }
}