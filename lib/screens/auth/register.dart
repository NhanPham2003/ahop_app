import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/consts/colors.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../../consts/consts_data.dart';
import '../../consts/firebase_const.dart';
import '../../fetch_screen.dart';
import '../../providers/dark_theme_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/text_widget.dart';
import '../loading_manager.dart';
import 'forget_pass.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/RegisterScreen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _addressTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  bool _obscureText = true;
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailTextController.dispose();
    _passTextController.dispose();
    _addressTextController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnRegister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        final User? user = authInstance.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(_fullNameController.text);
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': _fullNameController.text,
          'email': _emailTextController.text.toLowerCase(),
          'shipping-address': _addressTextController.text,
          'userWish': [],
          'userCart': [],
          'createdAt': Timestamp.now(),
        });
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const FetchScreen(),
        ));
        print('Succefully registered');
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = Utils(context).color;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color colors = themeState.getDarkTheme ? Colors.white : Colors.black;
    final Color subTitleColor = themeState.getDarkTheme ? Colors.white : AppColor.subTextColor;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 60.0,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : null,
                    child: Icon(
                      IconlyLight.arrowLeft2,
                      color: theme == true ? Colors.white : Colors.black,
                      size: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextWidget(
                    text: 'Chào mừng ',
                    color: colors,
                    textSize: 30,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: "Đăng ký tài khoản để tiếp tục",
                    color: subTitleColor,
                    textSize: 18,
                    isTitle: false,
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Vui lòng nhập đủ";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(color: colors),
                          decoration:  InputDecoration(
                            hintText: 'Full name',
                            hintStyle: TextStyle(color: colors),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colors),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colors),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_passFocusNode),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains("@")) {
                              return "Vui lòng nhập địa chỉ Email hợp lệ";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(color: colors),
                          decoration:  InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: colors),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colors),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colors),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Password
                        TextFormField(
                          focusNode: _passFocusNode,
                          obscureText: _obscureText,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return "Vui lòng nhập mật khẩu hợp lệ";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(color: colors),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(_addressFocusNode),
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: colors,
                              ),
                            ),
                            hintText: 'Password',
                            hintStyle:  TextStyle(color: colors),
                            enabledBorder:  UnderlineInputBorder(
                              borderSide: BorderSide(color: colors),
                            ),
                            focusedBorder:  UnderlineInputBorder(
                              borderSide: BorderSide(color: colors),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          focusNode: _addressFocusNode,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: _submitFormOnRegister,
                          controller: _addressTextController,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 10) {
                              return "Vui lòng nhập một địa chỉ hợp lệ";
                            } else {
                              return null;
                            }
                          },
                          style: TextStyle(color: colors),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Shipping address',
                            hintStyle: TextStyle(color: colors),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colors),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: colors),
                            ),
                            errorBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ForgetPasswordScreen.routeName);
                      },
                      child: const Text(
                        'Quên mật khẩu?',
                        maxLines: 1,
                        style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: 18,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  AuthButton(
                    buttonText: 'Đăng ký',
                    fct: () {
                      _submitFormOnRegister();
                    }, primary: AppColor.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Bạn đã là người dùng?',
                        style:
                        TextStyle(color: colors, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' Đăng nhập',
                              style: TextStyle(
                                  color: AppColor.primaryColor, fontSize: 18),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, LoginScreen.routeName);
                                }),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}