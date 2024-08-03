import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_const.dart';
import '../fetch_screen.dart';
import '../providers/dark_theme_provider.dart';
import '../screens/btm_bar.dart';
import '../services/global_methods.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );

          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'id': authResult.user!.uid,
              'name': authResult.user!.displayName,
              'email': authResult.user!.email,
              'shipping-address': '',
              'userWish': [],
              'userCart': [],
              'createdAt': Timestamp.now(),
            });
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FetchScreen(),
            ),
          );
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: '${error.message}', context: context);
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final Color bgColor = themeState.getDarkTheme ? Colors.transparent : Colors.transparent;
    return Material(
      color: bgColor,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(6)
            ),// Add border properties
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.all(8),
              //color: Colors.white,
              child: Image.asset(
                'assets/images/google.png',
                width: 35.0,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            TextWidget(
                text: 'Sign in with google', color: color, textSize: 18)
          ]),
        ),
      ),
    );
  }
}