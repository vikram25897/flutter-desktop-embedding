import 'dart:async';
import 'dart:io';

import 'package:example_flutter/alert_dialog.dart';
import 'package:example_flutter/slider_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Im;

// ignore: public_member_api_docs
class CompressorScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  final String path;

  // ignore: public_member_api_docs, sort_constructors_first
  const CompressorScreen({@required this.path});

  @override
  // ignore: type_annotate_public_apis, always_declare_return_types
  createState() => _CompressorState();
}

class _CompressorState extends State<CompressorScreen> {
  bool processing = false;
  double value = 10;
  Im.Image originalImage;
  var newImage;
  String format;
  double blacks = -1.0;
  double whites = 0.0;
  double saturation = 1.0;
  double contrast = 1.0;
  double brightness = 1.0;
  double gamma = 1.0;
  double exposure = 0.0;
  double hue = 0.0;

  @override
  void initState() {
    List<String> paths = widget.path.split(".");
    format = paths[paths.length - 1];
    File(widget.path).readAsBytes().then((bytes) async {
      if (bytes != null) {
        originalImage = await compute(decode, [bytes]);
        newImage = bytes;
        setState(() {});
      }
    });
    super.initState();
  }

  static FutureOr<Im.Image> decode(List params) {
    return Im.decodeImage(params[0]);
  }

  static FutureOr<List<int>> conver(List params) {
    return params[9].toLowerCase() == "png"
        ? Im.encodePng(
            Im.adjustColor(params[0],
                whites: params[2] ?? null,
                blacks: params[1] ?? null,
                contrast: params[3] ?? null,
                saturation: params[4] ?? null,
                brightness: params[5] ?? null,
                gamma: params[6] ?? null,
                exposure: params[7] ?? null,
                hue: params[8] ?? null),
          )
        : Im.encodeJpg(
            Im.adjustColor(params[0],
                whites: params[2] ?? null,
                blacks: params[1] ?? null,
                contrast: params[3] ?? null,
                saturation: params[4] ?? null,
                brightness: params[5] ?? null,
                exposure: params[7] ?? null,
                gamma: params[6] ?? null,
                hue: params[8] ?? null),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (c) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.2,
                    ),
                    Text(
                      "Original Image",style: TextStyle(
                      color: Colors.black,fontWeight: FontWeight.w600,fontSize: 28
                    ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
                        height: MediaQuery.of(context).size.height*0.5,
                      child: Image.file(
                        File(widget.path),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: AbsorbPointer(
                  absorbing: newImage == null || processing,
                  child: Stack(
                    children: <Widget>[
                      newImage == null
                          ? Center(
                              child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10.0,
                                  )),
                            )
                          : SizedBox(),
                      Opacity(
                        opacity: newImage == null ?? processing ? 0.5 : 1.0,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // ignore: prefer_const_literals_to_create_immutables
                              Text("Modifiers",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w500,fontSize: 24),),
                              SliderContainer(
                                max: 5000,
                                min: -100,
                                start: 0,
                                border: true,
                                label: "Whites",
                                onChange: (d) {
                                  whites = d;
                                  startConversion();
                                },
                              ),
                              SliderContainer(
                                max: 2,
                                min: 0,
                                start: 1,
                                border: true,
                                label: "Saturation",
                                onChange: (d) {
                                  saturation = d;
                                  startConversion();
                                },
                              ),
                              SliderContainer(
                                max: 2,
                                min: 0,
                                start: 1,
                                border: true,
                                label: "Contrast",
                                onChange: (d) {
                                  contrast = d;
                                  startConversion();
                                },
                              ),
                              SliderContainer(
                                max: 2,
                                min: 0,
                                start: 1,
                                border: true,
                                label: "Brightness",
                                onChange: (d) {
                                  brightness = d;
                                  startConversion();
                                },
                              ),
                              SliderContainer(
                                max: 2,
                                min: -2,
                                start: 0,
                                border: true,
                                label: "Exposure",
                                onChange: (d) {
                                  exposure = d;
                                  startConversion();
                                },
                              ),
                              SliderContainer(
                                max: 10,
                                min: 0,
                                start: 1,
                                border: true,
                                label: "Gamma",
                                onChange: (d) {
                                  gamma = d;
                                  startConversion();
                                },
                              ),
                              SliderContainer(
                                max: 360,
                                min: 0,
                                start: 0,
                                border: false,
                                label: "Hue",
                                onChange: (d) {
                                  hue = d;
                                  startConversion();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.2,
                      ),
                      Text("Modified Image",style: TextStyle(
                        color: Colors.black,fontWeight: FontWeight.w600,fontSize: 28
                      ),),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
                        height: MediaQuery.of(context).size.height*0.5,
                        child: newImage != null && processing != true
                            ? Image.memory(
                                newImage,
                                fit: BoxFit.contain,
                              )
                            : Center(
                              child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.red),
                                  )),
                            ),
                      ),
                      RaisedButton(
                        color: Colors.green,
                        onPressed: (){
                          startSave(c);
                        },
                        child: Icon(Icons.save_alt,color: Colors.white,size: 40,),
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 60),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void startConversion() async {
    setState(() {
      processing = true;
    });
    print(gamma);
    newImage = await compute(conver, [
      originalImage,
      whites.toInt(),
      null,
      contrast,
      saturation,
      brightness,
      gamma,
      exposure,
      hue.toInt(),
      format
    ]);
    setState(() {
      processing = false;
    });
  }

  void startSave(BuildContext c) {
    showDialog(
        context: c,
      barrierDismissible: false,
      builder: (con)=>CustomAlertDialog(
        image_path: widget.path,
        imageToSave: newImage,
        b: c,
        width: originalImage.width,
        height: originalImage.height,
        format: format,
      )
    );
  }
}
