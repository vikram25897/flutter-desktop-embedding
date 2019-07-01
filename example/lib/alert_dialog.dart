import 'dart:async';
import 'dart:io';
import 'package:example_flutter/second_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as x;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class CustomAlertDialog extends StatefulWidget {
  final List<int> imageToSave;
  final String image_path;
  final int width;
  final BuildContext b;
  final int height;
  final String format;

  const CustomAlertDialog(
      {Key key,
      this.imageToSave,
      this.format,
      this.b,
      this.image_path,
      this.width,
      this.height})
      : super(key: key);

  createState() => _AlertState();
}

class _AlertState extends State<CustomAlertDialog> {
  TextEditingController width;
  TextEditingController height;
  TextEditingController name;
  double aspectRatio;
  bool saving = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    aspectRatio = widget.height.toDouble() / widget.width.toDouble();
    width = TextEditingController(text: "${widget.width}");
    height = TextEditingController(text: "${widget.height}");
    name = TextEditingController(text: "edited.${widget.format}");
    super.initState();
  }

  @override
  Widget build(BuildContext c) {
    return Center(
      child: Card(
        elevation: 10,
        color: Colors.white,
        borderOnForeground: true,
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: MediaQuery.of(c).size.width * 0.3,
          height: 300,
          child: Center(
            child: Form(
              key: key,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Size",
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            ":",
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder()),
                              autovalidate: true,
                              validator: (s) {
                                int w;
                                try {
                                  w = int.parse(s);
                                  if (w < 0 )//|| w > widget.width)
                                    throw new Exception("Invalid width");
                                } catch (ex) {
                                  return "Invalid Number";
                                }
                                return null;
                              },
                              onChanged: (s) {
                                int w;
                                try {
                                  w = int.parse(s);
                                  if (w < 0 )//|| w > widget.width)
                                    throw new Exception("bdnv n");
                                  height.text = "${(w * aspectRatio).toInt()}";
                                } catch (ex) {
                                  return "Invalid Number";
                                }
                              },
                              controller: width,
                            )),
                        Expanded(
                          flex: 1,
                          child: Text(
                            " x ",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder()),
                              autovalidate: true,
                              validator: (s) {
                                int h;
                                try {
                                  h = int.parse(s);
                                  if (h < 0 )//|| h > widget.height)
                                    throw new Exception("Invalid Height");
                                } catch (ex) {
                                  return "Invalid Number";
                                }
                                return null;
                              },
                              onChanged: (s) {
                                int h;
                                try {
                                  h = int.parse(s);
                                  if (h < 0 )//|| h > widget.height)
                                    throw new Exception("bdnv n");
                                  width.text = "${(h / aspectRatio).toInt()}";
                                } catch (ex) {
                                  return "Invalid Number";
                                }
                              },
                              controller: height,
                            )),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: Text(
                          "Output File Name",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          ":",
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 7,
                        child: TextFormField(
                          controller: name,
                          autovalidate: true,
                          validator: (s) {
                            if (s.trim().length <= 0)
                              return "Inavlid File Name";
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    child: saving != true
                        ? Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 26),
                          )
                        : CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.red),
                          ),
                    color: Colors.green,
                    onPressed: () {
                      startSaving();
                    },
                    padding:
                        EdgeInsets.symmetric(vertical: 7.0, horizontal: 35.0),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // ignore: omit_local_variable_types
  void startSaving() async {
    if (key.currentState.validate()) {
      setState(() {
        saving = true;
      });
      final Directory dir = File(widget.image_path).parent;
      File file = new File(dir.path + "/${name.text}");
      x.Image img = await compute(
          fromBytes, [widget.width, widget.height, widget.imageToSave]);
      List<String> paths = name.text.split(".");
      String format = paths[paths.length - 1];
      List<int> bytes = await compute(
          resize, [format, img, int.parse(width.text), int.parse(height.text)]);
      //img =
      await file.writeAsBytes(
        bytes,
        flush: true,
      );
      setState(() {
        saving = false;
      });
      Scaffold.of(widget.b).showSnackBar(SnackBar(
        content: Text("File Saved"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ));
      await Future.delayed(Duration(seconds: 1));
      Navigator.popUntil(context, ModalRoute.withName("main"));
    }
    ;
  }

  static FutureOr<x.Image> fromBytes(List params) {
    return x.decodeImage(params[2]);
  }

  static FutureOr<List<int>> resize(List params) {
    print("size=> ${params[2]} ${params[3]}");
    return params[0].toLowerCase() == "png"
        ? x.encodePng(
            x.copyResize(params[1], width: params[2], height: params[3],interpolation: x.Interpolation.nearest))
        : x.encodeJpg(
            x.copyResize(params[1], width: params[2], height: params[3],interpolation: x.Interpolation.nearest));
  }
}
