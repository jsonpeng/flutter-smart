/*
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:       2017/03/20
*@LastUpdate: 2017/05/08
*
*This file is the app homepage to show aqi and approch aqi animation
*
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import '../communication/newws.dart';
import 'base.dart';

class HomePage extends StatefulWidget {
HomePage({Key key,this.autoPlayMovie,this.homeAqiState}) : super(key: key);
bool autoPlayMovie;
int homeAqiState;
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const PlatformMessageChannel<String>  movieChannel=const PlatformMessageChannel<String> ('movie',const StringCodec());
  static const PlatformMethodChannel methodChannel =const PlatformMethodChannel('video');
  Color aqiColor;
  var imagefile ="Assets/home.png";
  double  homeImageSize=1.0;
  double aqiNumSize =320.0;
  bool _showOutAqi = false;
  bool _showHomeAnimation=true;
  bool _showOnlyAqi=true;

  AnimationController _animation = new AnimationController(
      vsync:const TestVSync(),
      duration: new Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 330.0
    );

void _startAnimation() {
  _animation.forward(from:0.0);
}

String aqiNum;
void initState() {
   super.initState();
  //  movieChannel.setMessageHandler((String message) async {
  //    // do something, then
  //    return reply;
  //    print('reply => $reply');
  //  });
   if(config.autoPlayMovie){
    // new Timer.periodic(new Duration(seconds: 5),turntoMovie);
   }else{
     config.autoPlayMovie=false;
   }
  varifiedAqiNum(aqitimer);
   _showOnlyAqi=true;
  aqitimer=new Timer.periodic(new Duration(seconds:15), varifiedAqiNum);
}



Timer aqitimer;
void varifiedAqiNum(Timer aqitimer){
   ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SENSOR_GET_PM');
setState((){
config.homeAqiState=ZwaveWebsocketComunication.pm;
  if(config.homeAqiState>0 && config.homeAqiState<=50){
    aqiNum='${config.homeAqiState}';
    //imagefile="Assets/aqi_50.png";
    aqiColor=Colors.green[600];
}else if(config.homeAqiState>=51 && config.homeAqiState<=100){
    aqiNum='${config.homeAqiState}';
    //imagefile="Assets/aqi_100.png";
    aqiColor=Colors.yellow[700];
}else if(config.homeAqiState>=101 && config.homeAqiState<=150){
    aqiNum='${config.homeAqiState}';
    //imagefile="Assets/aqi_150.png";
    aqiColor=Colors.orange[600];
}else if(config.homeAqiState>=151 && config.homeAqiState<=200){
    aqiNum='${config.homeAqiState}';
    //imagefile="Assets/aqi_200.png";
      aqiColor=Colors.red[600];
}else if(config.homeAqiState>=201 && config.homeAqiState<=300){
    aqiNum='${config.homeAqiState}';
    //imagefile="Assets/aqi_300.png";
      aqiColor=Colors.red[600];
}else if(config.homeAqiState>=301){
    aqiNum='${config.homeAqiState}';
    //imagefile="Assets/aqi_301.png";
      aqiColor=Colors.red[600];
}else{
    aqiNum='null';
    aqiColor=Colors.green[600];
    //imagefile="Assets/aqi_50.png";
}
});
}

/*Test work
void sendhistory(Timer timer){
   WebsocketService ws=new WebsocketService();
   ws.set('gethistory');
}
for(var i=1;i<=1;i++){
new Timer.periodic(new Duration(seconds:3),sendhistory);
}
*/

Timer timer;
Timer movietime;
void turntoMovie(Timer movietime){
  Navigator.of(context).pushNamed('/allvideo');
   movietime.cancel();
}

String allVideoFile="file:///sdcard/all.mp4";


void _showOutAqiNum() {
    setState((){
homeImageSize=0.5;
  _startAnimation();
  _showOutAqi=true;
  _showHomeAnimation=true;
  _showOnlyAqi=false;
  config.autoPlayMovie=false;
    });
  }

  void _home(){
      setState((){
          config.autoPlayMovie=false;
          Navigator.of(context).pushNamed('/menu');
      });
  }

  void _back(){
      setState((){
        _showHomeAnimation=false;
        homeImageSize=1.0;
        _showOutAqi=false;
        _showOnlyAqi=true;
      });
  }


  @override
  Widget build(BuildContext context) {
      List<Widget> chips = <Widget>[];

      List<Widget> aqi=<Widget>[];

      List<Widget> homeAnimation=<Widget>[];

      if (_showOnlyAqi) {
        aqi.add(
          new Padding(
            padding: const EdgeInsets.only(top:0.0),
            child:
     new Container(
              child:new Text('AQI',style: new TextStyle(
               color: Colors.white,
               fontFamily: 'Hepworth',
               fontSize: 60.0,
               fontWeight:FontWeight.bold
              ),
            ),
          )
        ),
      );
    }

      if (_showOutAqi) {
        chips.add(
          new Container(
          child:new GestureDetector(
               onTap: (){
                  _home();
              },
              child:new Text('129',style: new TextStyle(
               fontFamily: 'Hepworth',
               color: Colors.white,
               decorationColor:Colors.black87,
               fontSize: 140.0,
            ),
          )),
           decoration: new BoxDecoration(
             backgroundColor: Colors.black,
           ),
         ),
       );
      }

if(_showHomeAnimation){
  homeAnimation.add(
    new Center(
        child:new Padding(
            padding: const EdgeInsets.all(0.0),
            child:
    new CustomPaint(
            key:new GlobalKey(),
            foregroundPainter: new _AnimationPainter(
              repaint:_animation
          )))),
        );
      }

var orientation;
orientation = MediaQuery.of(context).orientation;
switch (orientation) {
 case Orientation.landscape:
 print("HomePage:Landscape Screen");
    return  new Scaffold(
        backgroundColor:Colors.black87,
    body:new GestureDetector(
      onLongPress :(){
      _back();
      },
      onDoubleTap: (){
        _showOutAqiNum();
      },
      onTap: (){
        aqitimer?.cancel();
        Navigator.of(context).pushNamed('/menu');
      },
      child:new CustomMultiChildLayout(
         delegate: new LandspaceLayout(),
         children: <Widget>[
           new LayoutId(
               id: LandspaceLayout.background,
               child:new Transform(
                   child:new Container(
                      width: 720.0,
                      decoration: new BoxDecoration(
                      backgroundColor: aqiColor,
                      borderRadius: new BorderRadius.all(const Radius.circular(4200.0),),
                      ),


                      ),
                                       /*
            new Image.asset('$imagefile',
                   fit: BoxFit.contain),
                   */
  alignment: FractionalOffset.center,
                        transform: new Matrix4.identity()
                          ..scale(homeImageSize),
               )
             ),
            new LayoutId(
              id: LandspaceLayout.centerElements,
                      child:new Stack(
                          children: [
                                    new Stack(
                                      children: homeAnimation.map((Widget widget) {
                                        return  new Padding(
                                    padding: const EdgeInsets.all(0.0),
                                              child: widget);
                                      }
                                    ).toList()
                                    ),
                       new Transform(
                          child:
                      new Container(
        //backgroundColor:Colors.black87,
        child: new Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children:<Widget>[
new Stack(
     alignment: const FractionalOffset(2.9,3.5),
    //mainAxisAlignment: MainAxisAlignment.center,
    children:[
        new Column(
          children: chips.map((Widget widget) {
            return new Center(
              child: new Padding(
        padding: const EdgeInsets.all(0.0),
                  child: widget)
            );
          }
        ).toList()
        ),

        new Center(
        child:new Text('$aqiNum',style: new TextStyle(
            fontFamily: 'Hepworth',
             color: Colors.white,
             decorationColor:Colors.black87,
             fontSize: aqiNumSize,
             fontWeight:FontWeight.bold),
         )),

]
),
])),
alignment: FractionalOffset.center,
transform: new Matrix4.identity()
                            ..scale(homeImageSize),
),

new Padding(
  padding: const EdgeInsets.only(top: 520.0),
child:   new Column(
children: aqi.map((Widget widget) {
return new Center(
child:widget
);
}
).toList()
),
),
])
),

])));
break;
case Orientation.portrait:
print("HomePage:Portrait Screen");
return  new Scaffold(
    backgroundColor:Colors.black87,
body:new GestureDetector(
  onLongPress :(){
  _back();
  },
  onDoubleTap: (){
  _showOutAqiNum();
  },
  onTap: (){
    aqitimer?.cancel();
    Navigator.of(context).pushNamed('/menu');
  },
  child:new CustomMultiChildLayout(
     delegate: new LandspaceLayout(),
     children: <Widget>[
       new LayoutId(
           id: LandspaceLayout.background,
           child:new Transform(
               child:
        new Image.asset('$imagefile',
               fit: BoxFit.contain),
alignment: FractionalOffset.center,
                    transform: new Matrix4.identity()
                      ..scale(homeImageSize),
           )),
        new LayoutId(
          id: LandspaceLayout.centerElements,
                  child:new Stack(
                      children: [
                                new Stack(
                                  children: homeAnimation.map((Widget widget) {
                                    return  new Padding(
                                padding: const EdgeInsets.all(0.0),
                                          child: widget);
                                  }
                                ).toList()
                                ),
                   new Transform(
                      child:
                  new Container(
    //backgroundColor:Colors.black87,
    child: new Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children:<Widget>[
new Stack(
 alignment: const FractionalOffset(2.9,2.9),
//mainAxisAlignment: MainAxisAlignment.center,
children:[
    new Column(
      children: chips.map((Widget widget) {
        return new Center(
          child: new Padding(
    padding: const EdgeInsets.all(0.0),
              child: widget)
        );
      }
    ).toList()
    ),

  new Center(
    child:new Text('$aqiNum',style: new TextStyle(
        fontFamily: 'Hepworth',
         color: Colors.white,
         decorationColor:Colors.black87,
         fontSize: aqiNumSize,
         fontWeight:FontWeight.bold),
     )),

]
),
])),
alignment: FractionalOffset.center,
transform: new Matrix4.identity()
                        ..scale(homeImageSize),
),

new Padding(
padding: const EdgeInsets.only(top: 500.0),
child:   new Column(
children: aqi.map((Widget widget) {
return new Center(
child:widget
);
}
).toList()
),
),
])
),

])));
break;
}
  }
}



class _AnimationPainter extends CustomPainter{
  Animation<double> _repaint ;
  _AnimationPainter({
    Animation<double> repaint
  }):_repaint = repaint,super(repaint:repaint);

  @override
  void paint(Canvas canvas, Size size){
    final Paint paint = new Paint()
      ..color = Colors.orange[600].withOpacity(0.6)
      ..strokeWidth = 14.0
      ..style = PaintingStyle.stroke;
      //canvas.drawArc(Offset.infinite & size, _repaint.value, _repaint.value, false, paint);
   canvas.drawCircle(new Point(size.width/2, size.height/2), _repaint.value, paint);
  }

  @override
  bool shouldRepaint(_AnimationPainter oldDelegate){
    return oldDelegate._repaint != _repaint;
  }
}

class TestVSync implements TickerProvider {
  /// Creates a ticker provider that creates standalone tickers.
  const TestVSync();

  @override
  Ticker createTicker(TickerCallback onTick) => new Ticker(onTick);
}
