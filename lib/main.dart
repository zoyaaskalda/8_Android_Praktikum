import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:praktikum_8_android/views/home_screen.dart';

void main() => runApp(GetMaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
    ));
