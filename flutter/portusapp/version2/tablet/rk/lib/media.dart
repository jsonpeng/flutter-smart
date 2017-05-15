import 'dart:async';
import 'dart:convert';
//import 'dart:io';
//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

 String kVideoUrl;

//const kAudioUrl = "http://www.sample-videos.com/audio/mp3/crowd-cheering.mp3";

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
    _play();
   // _openVideoActivity();
  }

 backToHome() async{
  //  print("success back");
    _stop();
    Navigator.of(context).pop();


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

  Future<Null> _play() async {
    String reply = await PlatformMessages.sendString('playVideo', kVideoUrl);
    final data = JSON.decode(reply) as Map<String, dynamic>;
    //updateDuration(data);
    print("playVideo => $reply");
  }

  Future<Null> _stop() async {
    String reply = await PlatformMessages.sendString('stopVideo', '');
    print("stopVideo => $reply");
  }

  Future<Null> _openVideoActivity() async {
    String reply =
    await PlatformMessages.sendString('openVideoActivity', kVideoUrl);
    print("openVideoActivity => $reply");
  }
/*
  void updateDuration(data) {
    setState(() {
      _platformFeedback = data.containsKey('duration')
          ? '${data['duration']} sec'
          : 'Duration : undefined';
    });
  }
  */

}
