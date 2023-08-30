// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:text_scaning/pages/text_scanned_page.dart';

import '../them_app/model_them.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: themeNotifier.isDark ? Colors.black54 : Colors.deepOrange,
          title: Text("QCR App" , style: TextStyle(
            color: themeNotifier.isDark ? Colors.deepOrange : Colors.white,
          ),),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(themeNotifier.isDark
                    ? Icons.nightlight_round_sharp
                    : Icons.wb_sunny),
                onPressed: () {
                  themeNotifier.isDark
                      ? themeNotifier.isDark = false
                      : themeNotifier.isDark = true;
                }),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/back.jpg',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (textScanning) Center(child: const CircularProgressIndicator()),
                      if (!textScanning && imageFile == null)
                        Image.asset('assets/pin.png' , width: 280,height: 350,),
                      if (imageFile != null) Image.file(File(imageFile!.path)),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              getImage(ImageSource.gallery);
                            },
                            child: Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.deepOrange,
                                    width: 2,
                                  )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image , color: Colors.white,size: 30,),
                                  Text("Gallery" , style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          InkWell(
                            onTap: (){
                              getImage(ImageSource.camera);
                            },
                            child: Container(
                              width: 80,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.deepOrange,
                                    width: 2,
                                  )
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt , color: Colors.white,size: 30,),
                                  Text("Camera" , style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TextScannedPage(result: scannedText,)));
                        },
                        child: Container(
                          width: 100,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.deepOrange,
                                width: 2,
                              )
                          ),
                          child: Center(
                            child: Text("Text Scan" , style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
    textScanning = false;
    setState(() {});
  }
}