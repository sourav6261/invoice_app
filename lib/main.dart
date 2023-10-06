// main.dart

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:invoice_generator/home/home.dart';
import 'package:invoice_generator/model/providernot.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Project Calculator',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: AnimatedSplashScreen(
            splash: const Image(
              image: AssetImage(
                "assets/Logo.png",
              ),
            ),
            duration: 3000,
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: const Color.fromRGBO(16, 164, 210, 1),
            nextScreen: const Stack(
              children: [
                HomeScreen(),
              ],
            ),
          )),
    );
  }
}
//16, 164, 210, 1
