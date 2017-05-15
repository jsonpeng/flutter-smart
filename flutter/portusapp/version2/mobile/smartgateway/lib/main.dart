import 'package:flutter/material.dart';
import 'all.dart';
import 'package:flutter/services.dart';


/*
 * next is according local server to load movie,but it seems very slow,so I should use
 * local android file to load
 */

String weatherFile="file:///sdcard/weather.mp4";
//"http://192.168.10.10:8360/static/movie/weather.mp4";
String temperatureFile="file:///sdcard/temperature.mp4";
//"http://192.168.10.10:8360/static/movie/temperature.mp4";
String sceneFile="file:///sdcard/scene.mp4";
//"http://192.168.10.10:8360/static/movie/scene.mp4";
void main() {
  /*
   * hide the android system status bar
   *
   */
 SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[SystemUiOverlay.top]);
 /*
  * setting the default app Landscape or Portrait
  *
  */
 SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft]);
 runApp(
    new MaterialApp(
     title: "SmartGateway",
      theme: new ThemeData(
         primarySwatch: Colors.yellow
       ),
      home: new HomePage(),
      /*
       * config the app router
       *
       */
      routes: <String, WidgetBuilder> {

        '/menu':(BuildContext context) => new TimePickerDialog(initvalue: 2),

        '/home': (BuildContext context) => new HomePage(),

        '/history': (BuildContext context) => new HistoryDataPage(initialIndex: 1),

        //'/tem': (BuildContext context) => new MediaPlayer(videofile:"$temperatureFile"),
        '/sceneselect':(BuildContext context)=>new SceneSelectPage(),
        //new MediaPlayer(videofile:"$sceneFile"),

        '/tianqi':(BuildContext context)=>new MediaPlayer(videofile:"$weatherFile"),

        '/device':(BuildContext context)=>new DevPage(),

       '/temperature':(BuildContext context)=>new TemperaturePage(),

      //  '/adddevice':(BuildContext context)=>new AddProgeress(),

      //  '/remdevice':(BuildContext context)=>new RemDevice(),

      },
      )
  );
}
