/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:        2017/03/20
*@LastUpdate:  2017/05/05
*This file is a single entry system application, which
* is used to debug applications in college, such as routing parameters of each application
*
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'all.dart';

  //add Polling for node data automatically and pmi data
  ZwaveWebsocketComunication autows=new ZwaveWebsocketComunication();
  Timer autotimer;

  void autoGotNodelist(Timer autotimer){
  ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'GET_NODELIST');
  }

  void autoGotPm(Timer autotimer){
  ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SENSOR_GET_PM');
  }

  void autoGotTem(Timer autotimer){
  ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'SENSOR_GET_TEMPERATURE');
  }

  void main() {

    //set the app defalut screen display,like landscape or portrait
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.landscapeLeft]);
    // hide the android system status bar
    SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[SystemUiOverlay.top]);
    //first to start the task for get some parameter for ui show

    new Timer(new Duration(seconds: 5),(){
      //start websocket connection
        autows.connectServer();
      //Handle transfer and store a websocket
        ZwaveWebsocketComunication.websocket =autows;
    });
    new Timer(new Duration(seconds: 8), (){
       ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'GET_NODELIST');
       ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SENSOR_GET_PM');
       ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'SENSOR_GET_TEMPERATURE');
       ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'SYSTEM_GET_JOG');
    });
    //set movie file for play the media movie
      String  allFile="file:///sdcard/all.mp4";
      runApp(new MaterialApp(
    //set the app title name for ui show
      title: "Aerifai",
    //set the system some theme color to show
      theme: new ThemeData(primarySwatch: Colors.yellow),
    //set the system the first page to show
      home: new GuildPage(),
    // set app some basic routering
      routes: <String, WidgetBuilder>{
      '/home':        (BuildContext context) => new HomePage(autoPlayMovie: false,homeAqiState:ZwaveWebsocketComunication.pm),
      '/menu':        (BuildContext context) => new MenuPage(initvalue: 2), //initvalue Determine the location of the cursor, for example, to enter the menu from the aqi cursor will hover to display the menu
      //'/basicdevice': (BuildContext context) => new BasicDevPage(),
      '/device':      (BuildContext context) => new DevicePage(initvalue: 0),
      '/adddevice':   (BuildContext context) => new AddProgeress(),
      '/remdevice':   (BuildContext context) => new RemDevice(),
      '/setting':     (BuildContext context) => new SystemSetting(),
      '/basictem':    (BuildContext context) => new BasicTemperature(),
      '/temperature': (BuildContext context) => new TemperaturePage(),
      '/allvideo':    (BuildContext context) => new MediaPlayer(videofile: "$allFile"),
      '/history':     (BuildContext context) => new HistoryDataPage(initialIndex: 1),
      '/sceneselect': (BuildContext context) => new SceneSelectPage(),
      '/reboot':      (BuildContext context) => new ReBoot(),
    },
  )
);
  /*
   * there can add auto task to do
   */
  //start auto task to got data
  new Timer.periodic(new Duration(seconds: 60), autoGotTem);
  //  new Timer.periodic(new Duration(seconds: 3), autoGotPm);
}
