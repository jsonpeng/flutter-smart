/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:   2017/03/20
*@Update: 2017/04/06
*
*This file is the app guild page for our logo display
*
*/
import 'package:flutter/material.dart';
import 'dart:async';
import 'device.dart';

class GuildPage extends StatefulWidget{
  @override
  GuildPageState createState() =>new GuildPageState();
}

class GuildPageState extends State<GuildPage>{

@override
void initState(){
    super.initState();
    new Timer(new Duration(seconds: 12), turnToHome);
  //  UrlLauncher.launch('http://www.portushome.com/static/aerifai/index.html');
}

void turnToHome(){
  Navigator.pushNamed(context, '/home');
//  Navigator.push(context, new MaterialPageRoute(
        //builder: (BuildContext context) => new DevicePage(initvalue: 0)));
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body:

      new Center(
      child: new Image.asset('Assets/aerifai.png',
      fit:BoxFit.contain,width:500.0,height: 680.0),
    ),
/*
    new Container( // grey box
  child: new Center(
    child: new Container( // red box
      child: new Text(
        "Lorem ipsum",
        style: bold24Roboto,
      ),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          begin: const FractionalOffset(0.5, 0.0),
          end: const FractionalOffset(0.5, 0.8),
          colors: <Color>[
            const Color(0xffef5350),
            const Color(0x00ef5350)
          ],
        ),
      ),
      padding: new EdgeInsets.all(16.0),
    ),
  ),
  width: 320.0,
  height: 240.0,
  color: Colors.grey[300],
),
*/
  );
 }
}
