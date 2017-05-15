import 'package:flutter/material.dart';
import 'home.dart';
import 'remdevice.dart';
import 'menuNew.dart';
import 'dev.dart';
import 'statistics.dart';


import 'adddevice.dart';
import 'package:flutter/services.dart';


/*
 * // is according local server to load movie,but it seems very slow
 *


String weatherFile="file:///sdcard/weather.mp4";
//"http://192.168.10.10:8360/static/movie/weather.mp4";
String temperatureFile="file:///sdcard/temperature.mp4";
//"http://192.168.10.10:8360/static/movie/temperature.mp4";
String sceneFile="file:///sdcard/scene.mp4";
//"http://192.168.10.10:8360/static/movie/scene.mp4";
*/
void main() {
 SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[SystemUiOverlay.bottom]);
 SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft]);
 SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[SystemUiOverlay.top]);
  runApp(

    new MaterialApp(
     title: "SmartGateway",

      theme: new ThemeData(
         primarySwatch: Colors.yellow
       ),


      home: new HomePage(),
      routes: <String, WidgetBuilder> {

        '/menu':(BuildContext context) => new TimePickerDialog(initvalue: 7),
        '/home': (BuildContext context) => new HomePage(),
        '/history': (BuildContext context) => new HistoryDataPage(initialIndex: 1),
        //'/menu': (BuildContext context) => new MenuPage(),
      //  '/temperature': (BuildContext context) => new MediaPlayer(videofile:"$temperatureFile"),
        //new TemperaturePage(),
        //'/sceneselect':(BuildContext context)=>new MediaPlayer(videofile:"$sceneFile"),
        // new SceneSelectPage(),
        //'/sceneadd':(BuildContext context)=> new SceneAddPage(),
        //'/historydetail':(BuildContext context)=>new HistoryDetail(),
      //  '/tianqi':(BuildContext context)=>new MediaPlayer(videofile:"$weatherFile"),
        '/device':(BuildContext context)=>new DevPage(),
        '/adddevice':(BuildContext context)=>new AddProgeress(),
        '/remdevice':(BuildContext context)=>new RemDevice(),

      },
    )
  );
}
