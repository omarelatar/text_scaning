// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_scaning/pages/home_page.dart';

import 'package:text_scaning/them_app/model_them.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Text Recognition',
            theme: themeNotifier.isDark
                ? ThemeData(brightness: Brightness.dark)
                : ThemeData(brightness: Brightness.light),
            home: HomePage(),
          );
        },
      ),
    );
  }
}

