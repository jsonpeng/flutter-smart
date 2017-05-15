/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:   2017/03/20
*
*This file is the flutter app media lib for protected to play movie.
*
*/
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

 String kVideoUrl;
class MediaPlayer extends StatefulWidget {
  MediaPlayer({
    Key key,
    this.videofile
  }) : super(key: key) {
       assert(videofile != null);
  }
  final String videofile;
  @override
  _MediaplayerState createState() => new _MediaplayerState();
}

class _MediaplayerState extends State<MediaPlayer> {
  @override

  void initState(){
    super.initState();
    kVideoUrl=config.videofile;
     //_play();
    // _openVideoActivity();
  //new Timer.periodic(new Duration(seconds:2),hideScereen);
  }
Timer timer;
 backToHome() async{
  //  print("success back");
    //_stop();
    //Navigator.of(context).pop();


  }
hideScereen(Timer timer){
  setState((){
    print("hide scereen bar");
    SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[SystemUiOverlay.top]);

  });

}
  //String _platformFeedback = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        /*type: MaterialType.transparency,*/

backgroundColor: Colors.black,
        body:new GestureDetector(
          onDoubleTap: (){
            backToHome();
          },
          child:
        new Container(
            alignment: FractionalOffset.bottomCenter,

            decoration: new BoxDecoration(
  backgroundColor: Colors.black,
),

                  )));
  }






}
