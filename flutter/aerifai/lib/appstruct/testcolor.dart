/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:   2017/05/03
*
*This file is the app to test color
*
*/
import 'package:flutter/material.dart';
import 'dart:async';


class TestColorPage extends StatefulWidget{
  @override
  TestColorPageState createState() =>new TestColorPageState();
}


class TestColorPageState extends State<TestColorPage>{
  Color ex=Colors.orange[500];
@override
void initState(){
  Timer testtimer;
    super.initState();
    //Color ex;
      //Color ex=Colors.orange[500];
    //new Timer(new Duration(seconds: 5), turnToHome);
    //color();
    new Timer.periodic(new Duration(seconds: 5), red);
    new Timer.periodic(new Duration(seconds: 10), green);
    new Timer.periodic(new Duration(seconds: 15),blue);
    new Timer.periodic(new Duration(seconds: 20),yellow);
    new Timer.periodic(new Duration(seconds: 25),white);
    new Timer.periodic(new Duration(seconds: 30),black);

  //  UrlLauncher.launch('http://www.portushome.com/static/aerifai/index.html');
}


void color(){
for(int i=0;i<=1000;i++){
  if(i<10){

  }
}
}

void red(Timer testtimer){
  print("red");
  setState((){
   ex=Colors.red[500];
  });
}

void green(Timer testtimer){
    print("green");
  setState((){
 ex=Colors.green[500];
  });
}

void blue(Timer testtimer){
    print("blue");
  setState((){
 ex=Colors.blue[500];
  });
}

void yellow(Timer testtimer){
    print("yellow");
  setState((){
ex=Colors.yellow[500];
  });
}

void white(Timer testtimer){
  print("white");
setState((){
ex=Colors.white;
});
}

void black(Timer testtimer){
  print("black");
setState((){
ex=Colors.black;
});
}

void turnToHome(){
  //ex=Colors.red;
    Navigator.pushNamed(context, '/home');
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body:
new Container(
  decoration: new BoxDecoration(
    backgroundColor: ex,
  ),
  child:
      new Center(
      child:
     new Transform(
       child:
      //new TemperatureTimeTest(  selectedIndex: 1),
      new Container(),
      transform: new Matrix4.identity()
        ..scale(1.0),

      /*new Image.asset('Assets/aerifai.png',
      fit:BoxFit.contain,width:500.0,height: 680.0),
      */
    ))),
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
