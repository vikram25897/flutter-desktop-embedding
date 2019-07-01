import 'dart:math';

import 'package:example_flutter/second_screen.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:file_chooser/file_chooser.dart' as f;
String text;
void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  //sort();
  runApp(new MyApp());
}

void sort() {
  Random random = new Random();
  List<int> randoms = [];
  for(int i =0;i<1000000;i++){
    randoms.add(random.nextInt(200000));
  }
  DateTime dt = DateTime.now();
  randoms.sort();
  text = "${DateTime.now().millisecondsSinceEpoch-dt.millisecondsSinceEpoch}";
}

// ignore: public_member_api_docs
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "main",
      routes: {
        "main":(c)=>Home()
      },
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        // See https://github.com/flutter/flutter/wiki/Desktop-shells#fonts
        fontFamily: 'Roboto',
      ),
    );
  }
}

// ignore: public_member_api_docs
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);
    return Scaffold(
      body: Center(child: MaterialButton(
        onPressed: ()async{
          f.showOpenPanel((f,l){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (c)=>CompressorScreen(path: l[0],),
            ));
          },
            canSelectDirectories: false,
            allowedFileTypes: ['png','jpg'],
            allowsMultipleSelection: false,
            // ignore: prefer_single_quotes
            confirmButtonText: "Select Image",
          );
        },
        child: Text(
          "Press Me"
        ),
        color: Colors.red,
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 60),
      ),),
    );
  }
}