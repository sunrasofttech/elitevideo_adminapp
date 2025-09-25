import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:elite_admin/bloc/auth/login/login_cubit.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/main.dart';
import 'package:elite_admin/model/jwt_model.dart';
import 'package:elite_admin/presentation/dashboard.dart';
import 'package:elite_admin/utils/preferences/local_preferences.dart';
import 'package:elite_admin/utils/utility_mixin.dart';
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:elite_admin/utils/widget/textformfield.dart';
import 'package:elite_admin/utils/widget/textwidget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Utility {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "asset/image/bg.png",
              ),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 9.8, sigmaY: 9.8, tileMode: TileMode.mirror),
              child: Container(
                width: 340,
                height: 400,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(37, 37, 37, 0.3).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightBox10(),
                      const Center(
                        child: TextWidget(
                          text: "Admin Login",
                          color: AppColors.whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      heightBox20(),
                      const TextWidget(
                        text: "Username",
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.whiteColor,
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        controller: usernameController,
                        showPrefix: true,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SvgPicture.asset(
                            "asset/svg/username.svg",
                          ),
                        ),
                        backgroundColor: AppColors.whiteColor,
                      ),
                      heightBox15(),
                      heightBox20(),
                      const TextWidget(
                        text: "Password",
                        color: AppColors.whiteColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      heightBox5(),
                      TextFormFieldWidget(
                        showPrefix: true,
                        controller: passwordController,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SvgPicture.asset(
                            "asset/svg/eye.svg",
                          ),
                        ),
                        backgroundColor: AppColors.whiteColor,
                      ),
                      heightBox30(),
                      BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginErrorState) {
                            Fluttertoast.showToast(msg: state.error);
                            return;
                          }

                          if (state is LoginLoadededState) {
                            Fluttertoast.showToast(msg: state.model.message.toString());
                            String token = state.model.token ?? "";
                            LocalStorageUtils.saveToken(token);
                            JwtModel decodedToken = JwtModel.fromJson(JwtDecoder.decode(token));
                            String? id = decodedToken.id;
                            userId = decodedToken.id;
                            token = state.model.token ?? "";
                            LocalStorageUtils.saveUserId(id ?? "")?.then((e) => {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DashboardScreen(),
                                    ),
                                    (route) => false,
                                  ),
                                });
                          }
                        },
                        builder: (context, state) {
                          return CustomOutlinedButton(
                            inProgress: (state is LoginLoadingState),
                            onPressed: () {
                              context.read<LoginCubit>().login(
                                    usernameController.text,
                                    passwordController.text,
                                  );
                            },
                            borderRadius: 12,
                            buttonText: 'Login',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
