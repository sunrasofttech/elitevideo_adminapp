import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elite_admin/constant/color.dart';
import 'package:elite_admin/presentation/auth/login_screen.dart';
import 'package:elite_admin/presentation/dashboard.dart';
import 'package:elite_admin/utils/blocproviders/bloc_provider.dart';
import 'dart:io';
import 'package:elite_admin/utils/preferences/local_preferences.dart';

String? userId;
final dio = Dio();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageUtils.init().then(
    (e) => {
      userId = LocalStorageUtils.userId,
    },
  );
   HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.lightGreyColor,
          dialogBackgroundColor: AppColors.whiteColor,
          switchTheme: const SwitchThemeData(
            thumbColor: WidgetStatePropertyAll(
              AppColors.zGreenColor,
            ),
          ),
        ),
        home: userId != null ? const DashboardScreen() : const LoginScreen(),
      ),
    );
  }
}

 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}