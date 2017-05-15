/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:        2017/05/11

*
*This file is all the demo for mobile phone play temperature movie
*
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  //set the app defalut screen display,like landscape or portrait
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft]);
  // hide the android system status bar
  SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[SystemUiOverlay.top]);
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of  application for edit.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MobileDemo(),
    );
  }
}

class MobileDemo extends StatefulWidget {
  MobileDemo({Key key}) : super(key: key);
  @override
  _MobileDemoState createState() => new _MobileDemoState();
}



class _MobileDemoState extends State<MobileDemo> {
 PlatformMethodChannel mobileMovieChannel =const PlatformMethodChannel('mobileMovie');


 @override
 void initState(){
   super.initState();
   _openTemperatureVideo();
 }

 Future<Null> _openTemperatureVideo() async {
   int result = await mobileMovieChannel.invokeMethod('playTemperature');
        print('get result :$result');
 }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance
    // as done by the _incrementCounter method above.
    // The Flutter framework has been optimized to make rerunning
    // build methods fast, so that you can just rebuild anything that
    // needs updating rather than having to individually change
    // instances of widgets.
    return new Scaffold(
      backgroundColor: Colors.black,
      body: new Center(
        child:
         new Container(),
       )
     );
   }
}
