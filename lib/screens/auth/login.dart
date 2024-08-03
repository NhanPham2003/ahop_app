import 'package:card_swiper/card_swiper.dart';
import 'package:fashion_app/consts/colors.dart';
import 'package:fashion_app/screens/auth/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../consts/consts_data.dart';
import '../../consts/firebase_const.dart';
import '../../fetch_screen.dart';
import '../../providers/dark_theme_provider.dart';
import '../../services/global_methods.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/google_button.dart';
import '../../widgets/text_widget.dart';
import '../loading_manager.dart';
import 'forget_pass.dart';


class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FetchScreen(),
          ),
        );
        print('Đăng nhập thành công');
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
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color colors = themeState.getDarkTheme ? Colors.white : Colors.black;
    final Color subTitleColor = themeState.getDarkTheme ? Colors.white : AppColor.subTextColor;
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 120.0,
                  ),
                  TextWidget(
                    text: 'Chào mừng',
                    color: colors,
                    textSize: 30,
                    isTitle: true,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: "Đăng nhập để tiếp tục",
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
                                .requestFocus(_passFocusNode),
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Vui lòng nhập địa chỉ email hợp lệ';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(color: colors),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(color: colors),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: colors),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: colors),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          //Password

                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              _submitFormOnLogin();
                            },
                            controller: _passTextController,
                            focusNode: _passFocusNode,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return 'Vui lòng nhập lại mật khẩu hợp lệ';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(color: colors),
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
                                  )),
                              hintText: 'Mật khẩu',
                              hintStyle: TextStyle(color: colors),
                              enabledBorder:  UnderlineInputBorder(
                                borderSide: BorderSide(color: colors,),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: colors,),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ForgetPasswordScreen.routeName);
                      },
                      child: Text(
                        'Quên mật khẩu?',
                        maxLines: 1,
                        style: TextStyle(
                            color: subTitleColor,
                            fontSize: 16,
                            // decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AuthButton(
                    fct: _submitFormOnLogin,
                    buttonText: 'Đăng Nhập',
                    primary: AppColor.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GoogleButton(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                       Expanded(
                        child: Divider(
                          color: colors,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        text: 'OR',
                        color: colors,
                        textSize: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                       Expanded(
                        child: Divider(
                          color: colors,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AuthButton(
                    fct: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FetchScreen(),
                        ),
                      );
                    },
                    buttonText: 'Đăng nhập với khách',
                    primary: AppColor.subTextColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'Chưa có tài khoản?',
                          style: TextStyle(
                              color: colors, fontSize: 18),
                          children: [
                            TextSpan(
                                text: '  Đăng ký',
                                style: const TextStyle(
                                    color: AppColor.primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    GlobalMethods.navigateTo(
                                        ctx: context,
                                        routeName: RegisterScreen.routeName);
                                  }),
                          ]))
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}