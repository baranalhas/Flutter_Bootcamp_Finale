import 'dart:async';

import 'package:baran_alhas_flutter_final/cubit/basketpage_cubit.dart';
import 'package:baran_alhas_flutter_final/cubit/homepage_cubit.dart';
import 'package:baran_alhas_flutter_final/views/login_page.dart';
import 'package:baran_alhas_flutter_final/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cubit/orderpage_cubit.dart';
import 'views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomePageCubit()),
        BlocProvider(create: (context) => BasketPageCubit()),
        BlocProvider(create: (context) => OrderPageCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: SplashScreen(),
      ),
    );
  }

}

