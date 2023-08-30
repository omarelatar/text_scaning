import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../them_app/model_them.dart';

class TextScannedPage extends StatelessWidget {
  const TextScannedPage({super.key, required this.result});

  final String result;

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        backgroundColor: themeNotifier.isDark ? Colors.grey.shade900 : Colors.white,
        appBar: AppBar(
          backgroundColor: themeNotifier.isDark ? Colors.black54 : Colors.deepOrange,
          title: Text("Text Recognition" , style: TextStyle(
            color: themeNotifier.isDark ? Colors.deepOrange : Colors.white,
          ),),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back , color: themeNotifier.isDark ? Colors.deepOrange : Colors.white,),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            height: 350,
            width: 300,
            margin: const EdgeInsets.only(top: 70),
            padding: const EdgeInsets.only(left: 28, bottom: 20, right: 18, top: 15),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/note.jpg'), fit: BoxFit.contain)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  result,
                  style: const TextStyle(color: Colors.deepOrange),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}