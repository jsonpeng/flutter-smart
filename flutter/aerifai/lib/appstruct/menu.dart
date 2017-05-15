/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:   2017/03/20
*@Update: 2017/05/08
*
*This file is the app mainly menu page to jump and swiching the page jump and jog swich
*
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:convert';
import 'base.dart';
import '../communication/jogcontrol.dart';
import '../communication/newws.dart';



const Duration _kDialAnimateDuration = const Duration(milliseconds: 200);
const double _kTwoPi = 2 * math.PI;
const int _itemNum = 7;
const PlatformMethodChannel methodChannel =const PlatformMethodChannel('video');

Future<Null> _openWeatherVideo() async {
  int result = await methodChannel.invokeMethod('playWeather');
       print('get result :$result');
}

Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('$dir/nodelist.json');
    return new File('$dir/nodelist.json');
  }

Future<String> _readNodeListFile() async {
    try {
      File file = await _getLocalFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      return contents;
    } on FileSystemException {
      return "";
    }
  }

class MenuPainter extends CustomPainter {
  const MenuPainter({
    this.backgroundColor,
    this.accentColor,
    this.theta
  });
  final Color backgroundColor;
  final Color accentColor;
  final double theta;

  @override
  void paint(Canvas canvas, Size size) {

    double radius = size.shortestSide / 2.0-12.0;

    Offset center = new Offset(size.width / 2.0, size.height / 2.0);


    //triangle side length
  const double sideLength = 60.0;
  //triangle high
  final double high = sideLength * math.cos(math.PI/6.0);
  //the distance of the triangle's farest point to background max circle
  const double trianglePadding = 40.0;
  //the distance of the triangle's nearest point(the same as above) to background circle center point.
  final double minPointRadius = radius - trianglePadding;

  final double pointTheta = math.atan((sideLength/2.0)/(minPointRadius + high));
  final double maxPointRadius = (sideLength/2.0)/math.sin(pointTheta);

  Point pointMin = new Point(minPointRadius*math.cos(theta) + center.dx,center.dy - minPointRadius*math.sin(theta));
  Point pointMax1 = new Point(maxPointRadius*math.cos(theta+pointTheta) + center.dx,center.dy - maxPointRadius*math.sin(theta+pointTheta));
  Point pointMax2 = new Point(maxPointRadius*math.cos(theta-pointTheta) + center.dx,center.dy - maxPointRadius*math.sin(theta-pointTheta));

  Path trianglePath = new Path();
  trianglePath.moveTo(pointMin.x,pointMin.y);
  trianglePath.lineTo(pointMax1.x,pointMax1.y);
  trianglePath.lineTo(pointMax2.x,pointMax2.y);
  trianglePath.lineTo(pointMin.x,pointMin.y);

  final Paint jogWheelPaint = new Paint()
    ..color = accentColor;
  canvas.drawPath(trianglePath,jogWheelPaint);


  }

  @override
  bool shouldRepaint(MenuPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor
        || oldPainter.accentColor != accentColor
        || oldPainter.theta != theta;
  }
}


class TimeTest extends StatefulWidget{
  TimeTest({
    this.selectedIndex,
    this.onChanged
  }) {
     assert(selectedIndex != null);
  }
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  TimeTestState createState()=>new TimeTestState();
}


class TimeTestState  extends State<TimeTest> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    _thetaController = new AnimationController(
        duration: _kDialAnimateDuration,
        vsync: this,
    );
    _thetaTween = new Tween<double>(begin: _getThetaForIndex(config.selectedIndex));

    _theta = _thetaTween.animate(new CurvedAnimation(
        parent: _thetaController,
        curve: Curves.fastOutSlowIn
    ))..addListener(() => setState(() { }));

  }

  @override
  void didUpdateConfig(TimeTest oldConfig) {

    if (!_dragging)
      _animateTo(_getThetaForIndex(config.selectedIndex));
  }

  @override
  void dispose() {
    _thetaController.dispose();
    super.dispose();
  }

  Tween<double> _thetaTween;
  Animation<double> _theta;
  AnimationController _thetaController;
  bool _dragging = false;

  static double _nearest(double target, double a, double b) {
    return ((target - a).abs() < (target - b).abs()) ? a : b;
  }

  void _animateTo(double targetTheta) {
    double currentTheta = _theta.value;
    double beginTheta = _nearest(targetTheta, currentTheta, currentTheta + _kTwoPi);
    beginTheta = _nearest(targetTheta, beginTheta, currentTheta - _kTwoPi);
    _thetaTween
      ..begin = beginTheta
      ..end = targetTheta;
    _thetaController
      ..value = 0.0
      ..forward();
  }

  double _getThetaForIndex(int index) {

    double fraction = ((index-1)/_itemNum )%_itemNum;

    return (math.PI / 2.0 - math.PI/_itemNum - fraction * _kTwoPi) % _kTwoPi;
  }

  int _getIndexForTheta(double theta) {
    double fraction = (0.25-0.5/_itemNum - (theta % _kTwoPi) / _kTwoPi) % 1.0;
      int index = (fraction * _itemNum).round() % _itemNum;

      return index+1;
    }

  void _notifyOnChangedIfNeeded() {
    if (config.onChanged == null)
      return;
    int index = _getIndexForTheta(_theta.value);
    if (index != config.selectedIndex)
      config.onChanged(index);
  }

  void _updateThetaForPan() {
    setState(() {
      final Offset offset = _position - _center;
      final double angle = (math.atan2(offset.dx, offset.dy) - math.PI / 2.0) % _kTwoPi;
      _thetaTween
        ..begin = angle
        ..end = angle; // The controller doesn't animate during the pan gesture.
    });
  }

  Point _position;
  Point _center;

  void _handlePanStart(DragStartDetails details) {
    assert(!_dragging);
    _dragging = true;
    final RenderBox box = context.findRenderObject();
    _position = box.globalToLocal(details.globalPosition);
    _center = box.size.center(Point.origin);
    _updateThetaForPan();
    _notifyOnChangedIfNeeded();
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    _position += details.delta;
    _updateThetaForPan();
    _notifyOnChangedIfNeeded();
  }

  void _handlePanEnd(DragEndDetails details) {
    assert(_dragging);
    _dragging = false;
    _position = null;
    _center = null;
    _animateTo(_getThetaForIndex(config.selectedIndex));
    turnToPage();
  }
  Timer timer;


  //count device=7,but we need  8 count to add
  void turnToPage(){
    if(config.selectedIndex==7){
        setState((){
            print("enter temperature page");
            // gotoDevice();
           //  device[7]=1.2;
     new Timer(new Duration(milliseconds:100),turntoTem);
        });
    }else if(config.selectedIndex==1){
      print("enter scene page");
//device[1]=1.2;
        new Timer(new Duration(milliseconds:100),turntoScene);
     //Navigator.of(context).pushNamed('/sceneselect');
    }else if(config.selectedIndex==2){
      print("enter home page");
      //device[2]=1.2;
     // Navigator.of(context).pushNamed('/home');
    new Timer(new Duration(milliseconds:100),turntoAqi);
    }else if(config.selectedIndex==3){
      print("enter tianqi page");
      //device[3]=1.2;
      //Navigator.of(context).pushNamed('/tianqi');
      new Timer(new Duration(milliseconds:100),turntoTianQi);
    }else if(config.selectedIndex==4){
      print("enter setting page");
      //device[4]=1.2;
    // Navigator.of(context).pushNamed('/history');
    new Timer(new Duration(milliseconds:100),turntoSetting);
    }else if(config.selectedIndex==5){
      print("enter history page");
      //device[5]=1.2;
// Navigator.of(context).pushNamed('/history');
new Timer(new Duration(milliseconds:100),turntoHistory);
    }else if(config.selectedIndex==6){
      print("enter device page");
      //device[6]=1.2;
// Navigator.of(context).pushNamed('///device');
new Timer(new Duration(milliseconds:100),turntoDevice);
    }
  }




void turntoTem(){
    jogtimer?.cancel();
     Navigator.of(context).pushNamed('/basictem');
}

void turntoScene(){
    jogtimer?.cancel();
    Navigator.of(context).pushNamed('/sceneselect');

}

void turntoAqi(){
  jogtimer?.cancel();
    Navigator.of(context).pushNamed('/home');
}

void turntoSetting(){
  jogtimer?.cancel();
    Navigator.of(context).pushNamed('/setting');
}

turntoTianQi() async{
  int result = await methodChannel.invokeMethod('playWeather');
       print('get result :$result');
}

void turntoHistory(){
  jogtimer?.cancel();
    Navigator.of(context).pushNamed('/history');
}

void turntoDevice(){
  jogtimer?.cancel();
   Navigator.of(context).pushNamed('/device');
}

  @override
  Widget build(BuildContext context){
    return new Stack(
        children: [
    new GestureDetector(
        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: new CustomPaint(
            key: const ValueKey<String>('time-picker-dial'), // used for testing.
            painter: new MenuPainter(
                //圆的背景颜色
                backgroundColor: Colors.white10,
                //圆的指针颜色
                accentColor: Colors.white,
                //圆心到圆的指针
                theta: _theta.value
              )
            ),
          ),
        ]
      );
    }
  }



class MenuPage extends StatefulWidget {
  MenuPage({
    Key key,
    this.initvalue
  }) : super(key: key) {
       assert(initvalue != null);
  }
   int initvalue;

  @override
  MenuPageState createState() => new MenuPageState();
}

int oldJogPos = -1;
int newJogPos = -1;
int newJogDirx = 0;
int oldJogDirx=-1;
int flag=0;
Timer jogtimer;
int state=0;

class MenuPageState extends State<MenuPage>{

  @override
  void initState() {
    super.initState();
    JogControl.jogItem = config.initvalue;
    print(JogControl.jogItem);
    JogControl.jogNum=4;
    jogtimer=new Timer.periodic(new Duration(milliseconds:250),menuJog);
    //print("jogtimer:$jogtimer");
  }

  List<double> device=[0.0,1.7,1.7,1.7,1.7,1.7,1.7,1.7];
  menuJog(Timer jogtimer) {
    ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SYSTEM_GET_JOG');
       int temp;
       int jogPos = ZwaveWebsocketComunication.jogPos;
       int jogDirx= ZwaveWebsocketComunication.jogDir;
      //first get data
      if( (state == 1) && (jogPos == newJogPos)){
        if (flag >=8){
        newJogPos = -1;
        state =0;
        flag = 0;
        oldJogPos=jogPos;
        oldJogDirx=jogDirx;
        turnToPage();
        return;
      }else{
        flag++;
        return;
      }
    }else{
      flag=0;
    }
      //set new pos and direct
      newJogPos = jogPos;
      newJogDirx= jogDirx;
      //compare direct
      if( newJogDirx != oldJogDirx){
        oldJogPos=jogPos;
        oldJogDirx = jogDirx;
        flag=0;
        return;
      }
     if(oldJogDirx==0){
           if(newJogPos-oldJogPos>JogControl.jogNum){
               oldJogPos=newJogPos;
               oldJogDirx=newJogDirx;
               JogControl.jogItem--;
               if(JogControl.jogItem<1){
                 JogControl.jogItem=7;
               }
               state = 1;
               _handleIndexChanged(JogControl.jogItem);
         }else if(newJogPos<oldJogPos){
              temp=newJogPos;
              if(newJogPos+24-oldJogPos>JogControl.jogNum){
                 JogControl.jogItem--;
                 if(JogControl.jogItem<1){
                   JogControl.jogItem=7;
                 }
                 _handleIndexChanged(JogControl.jogItem);
                   oldJogPos=temp;
                  oldJogDirx=newJogDirx;
                  state = 1;
          }
        }
     }
     else if(oldJogDirx==1){
         if(newJogPos-oldJogPos<= -JogControl.jogNum){
             oldJogPos=newJogPos;
             oldJogDirx = newJogDirx;
             JogControl.jogItem++;
             if(JogControl.jogItem>7){
               JogControl.jogItem=1;
             }
             _handleIndexChanged(JogControl.jogItem);
            state = 1;
         }else if(newJogPos>oldJogPos){
           temp=newJogPos;
           if(newJogPos-24-oldJogPos<= -JogControl.jogNum){
           JogControl.jogItem++;
           if(JogControl.jogItem>7){
             JogControl.jogItem=1;
           }
           _handleIndexChanged(JogControl.jogItem);
           oldJogPos=temp;
           oldJogDirx = newJogPos;
           state =1;
            }
          }
     }
 }


void turnToPage(){
  if(JogControl.jogItem==7){
    print("enter temperature page");
    //new Timer(new Duration(milliseconds: 1000),(){
    jogtimer.cancel();
    //});
   new Timer(new Duration(milliseconds:200),(){
      Navigator.pushNamed(context, '/basictem');
   });
  }else if(JogControl.jogItem==1){
    print("enter scene page");
    //jogtimer.cancel();
    //new Timer(new Duration(milliseconds: 1000),(){
 jogtimer.cancel();
  //  });
    new Timer(new Duration(milliseconds: 200), (){
    Navigator.pushNamed(context, '/sceneselect');
    });
 }else if(JogControl.jogItem==2){
    print("enter home page");
     jogtimer.cancel();
    //new Timer(new Duration(millimilliseconds: 200000),(){
  //jogtimer.cancel();
     //});
  new Timer(new Duration(milliseconds:200),(){
  Navigator.pushNamed(context, '/home');
  });
}else if(JogControl.jogItem==3){
    print("enter tianqi page");
   //jogtimer.cancel();

    new Timer(new Duration(milliseconds:200),turntoTianQi);
  }else if(JogControl.jogItem==4){
    print("enter setting page");
     jogtimer.cancel();
      //new Timer(new Duration(millimilliseconds: 200000),(){
   //jogtimer.cancel();
      //});
  new Timer(new Duration(milliseconds:200),(){
      Navigator.pushNamed(context, '/setting');
  });
}else if(JogControl.jogItem==5){
    print("enter history page");
       jogtimer.cancel();
      //new Timer(new Duration(millimilliseconds: 200000),(){
    //jogtimer.cancel();
      // });
new Timer(new Duration(milliseconds:200),(){
      Navigator.pushNamed(context, '/history');
});
  }else if(JogControl.jogItem==6){
    print("enter device page");
    jogtimer.cancel();
  //  new Timer(new Duration(millimilliseconds: 200000),(){
 //jogtimer.cancel();
    //});
new Timer(new Duration(milliseconds:200),(){
    Navigator.pushNamed(context, '/device');
});

  }

}
void getHistoryData(Timer timer){
  String nodelist=ZwaveWebsocketComunication.nodelist;
  var jsonNodeList=JSON.decode(nodelist);
  var nodeLength=jsonNodeList['data'];
  int nodelength=nodeLength.length;
  for(int i=0;i<nodeLength.length;i++){
 if(jsonNodeList['data'][i]['GenericDeviceClass']==16){
   ZwaveWebsocketComunication.websocket.basicSetting(nodeid: jsonNodeList['data'][i]['NodeId'],wsdata: 'GET_HISTORYPARAMETER',historyparameter: 'minute');
  }else if(jsonNodeList['data'][i]['GenericDeviceClass']==33){
    ZwaveWebsocketComunication.websocket.basicSetting(nodeid:jsonNodeList['data'][i]['NodeId'],wsdata: 'GET_TEMPERATURE');
  }
 }
}




  void turntoTem(){
    jogtimer?.cancel();
    Navigator.of(context).pushNamed('/basictem');
  }

  void turntoScene(){
    jogtimer?.cancel();
    Navigator.of(context).pushNamed('/sceneselect');
  }

  void turntoAqi(){
    jogtimer?.cancel();
      Navigator.of(context).pushNamed('/home');
  }

  void turntoSetting(){
      jogtimer?.cancel();
      Navigator.of(context).pushNamed('/setting');
  }

   turntoTianQi() async{
       int result = await methodChannel.invokeMethod('playWeather');
            print('get result :$result');
  }

  void turntoHistory(){
    jogtimer?.cancel();
    Navigator.of(context).pushNamed('/history');
  }

  void turntoDevice(Timer timer){
      jogtimer?.cancel();
       Navigator.of(context).pushNamed('/device');
  }

  void _handleIndexChanged(int index) {
    setState(() {
      JogControl.jogItem = index;
      print(JogControl.jogItem);
    if (JogControl.jogItem==1){
      print("increase 1");
      device[1]=2.0;
      device[2]=1.7;
      device[3]=1.7;
      device[4]=1.7;
      device[5]=1.7;
      device[6]=1.7;
      device[7]=1.7;
    }else if(JogControl.jogItem==2){
        print("increase 2");
          device[2]=2.0;
          device[1]=1.7;
          device[3]=1.7;
          device[4]=1.7;
          device[5]=1.7;
          device[6]=1.7;
          device[7]=1.7;
    }else if(JogControl.jogItem==3){
        print("increase 3");
          device[3]=2.0;
          device[1]=1.7;
          device[2]=1.7;
          device[4]=1.7;
          device[5]=1.7;
          device[6]=1.7;
          device[7]=1.7;
    }else if(JogControl.jogItem==4){
        print("increase 4");
          device[4]=2.0;
          device[1]=1.7;
          device[2]=1.7;
          device[3]=1.7;
          device[5]=1.7;
          device[6]=1.7;
          device[7]=1.7;
    }else if(JogControl.jogItem==5){
        print("increase 5");
          device[5]=2.0;
          device[1]=1.7;
          device[2]=1.7;
          device[4]=1.7;
          device[3]=1.7;
          device[6]=1.7;
          device[7]=1.7;
    }else if(JogControl.jogItem==6){
        print("increase 6");
          device[6]=2.0;
          device[1]=1.7;
          device[2]=1.7;
          device[4]=1.7;
          device[5]=1.7;
          device[3]=1.7;
          device[7]=1.7;
    }else if(JogControl.jogItem==7){
        print("increase 7");
          device[7]=2.0;
          device[1]=1.7;
          device[2]=1.7;
          device[4]=1.7;
          device[5]=1.7;
          device[6]=1.7;
          device[3]=1.7;
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget picker = new Container(
        child:
        new Padding(
            padding: const EdgeInsets.all(0.0),
            child: new AspectRatio(
                aspectRatio: 1.2,
                child: new TimeTest(
                    selectedIndex: JogControl.jogItem,
                    onChanged: _handleIndexChanged,
                ),
            )
        ),
    );

    Widget menuView =new Container(
        child:
        new Column(
       children: [
    new Padding(
    padding: const EdgeInsets.only(top:60.0,left: 130.0),
    child:
           new Row(
               children: [
                   new GestureDetector(
                       onTap: (){
                         jogtimer?.cancel();
                      Navigator.pushNamed(context, '/basictem');
                       },
                      child:
                   new Padding(
                       padding: const EdgeInsets.all(30.0),
                       child:
                   new Transform(
                           child: new Image.asset('Assets/menu-tem.png',width: 96.0,height: 96.0),
                           //alignment: FractionalOffset.center,
                           transform: new Matrix4.identity()
                                                       ..scale(device[7]),
                   ))),
                   new GestureDetector(
                       onTap: (){
                            jogtimer?.cancel();
                        Navigator.pushNamed(context, '/sceneselect');
                       },
                       child:
                   new Padding(
                       padding: const EdgeInsets.only(left:120.0,top:10.0),
                   child: new Transform(

                           child: new Image.asset('Assets/menu-scene.png',width: 96.0,height: 96.0),
                           //alignment: FractionalOffset.center,
                           transform: new Matrix4.identity()
                                                       ..scale(device[1]),

                   ))),
               ]
           )),


           new Padding(
           padding: const EdgeInsets.only(top:0.0,left: 0.0),
           child:
                  new Row(
                      children: [
                          new GestureDetector(
                              onTap: (){
                            jogtimer?.cancel();
                            Navigator.pushNamed(context, '/device');
                              },
                             child:
                          new Padding(
                              padding: const EdgeInsets.only(left:40.0,top:70.0),
                              child:
                          new Transform(
                                      //padding: const EdgeInsets.all(20.0),
                                  child: new Image.asset('Assets/menu-device.png',width: 96.0,height: 96.0),
                                  //alignment: FractionalOffset.center,
                                  transform: new Matrix4.identity()
                                                              ..scale(device[6]),

                          ))),



                          new GestureDetector(
                              onTap: (){
                                  jogtimer?.cancel();
                                Navigator.pushNamed(context, '/home');
                              },
                              child:
                          new Padding(
                              padding: const EdgeInsets.only(left:360.0,top:5.0,bottom: 0.0),
                          child: new Transform(

                                  child: new Image.asset('Assets/menu-aqi.png',fit:BoxFit.contain,width: 96.0,height: 96.0),
                                  //alignment: FractionalOffset.center,
                                  transform: new Matrix4.identity()
                                                              ..scale(device[2]),

                          ))),
                      ]
                  )),




                  new Padding(
                  padding: const EdgeInsets.only(top:35.0,left:135.0),
                  child:
                         new Row(

                             children: [
                                 new GestureDetector(
                                     onTap: (){
                                      jogtimer?.cancel();
                                      Navigator.pushNamed(context, '/history');
                                     },
                                    child:
                                 new Padding(
                                     padding: const EdgeInsets.only(left:0.0,top:0.0),
                                     child:
                                 new Transform(
                                             //padding: const EdgeInsets.all(20.0),
                                         child: new Image.asset('Assets/menu-history.png',width: 96.0,height: 96.0),
                                         //alignment: FractionalOffset.center,
                                         transform: new Matrix4.identity()
                                                                     ..scale(device[5]),
                                 ))),
                                 new Stack(
                                     children: [
                                 new GestureDetector(
                                     onTap: (){
                                         jogtimer?.cancel();
                                         Navigator.pushNamed(context, '/setting');
                                     },
                                     child:
                                 new Padding(
                                     padding: const EdgeInsets.only(left:100.0,top:145.0),
                                 child: new Transform(
                                         child: new Image.asset('Assets/menu-setting1.png',width: 56.0,height: 56.0),
                                         //alignment: FractionalOffset.center,
                                         transform: new Matrix4.identity()
                                                                     ..scale(device[4]),
                                 ))),
                                 new GestureDetector(
                                     onTap: (){
                                         jogtimer?.cancel();
                                        Navigator.pushNamed(context, '/setting');
                                     },
                                     child:
                                 new Padding(
                                     padding: const EdgeInsets.only(left:165.0,top:145.0),
                                 child: new Transform(
                                         child: new Image.asset('Assets/menu-setting2.png',width: 26.0,height: 26.0),
                                         //alignment: FractionalOffset.center,
                                         transform: new Matrix4.identity()
                                                                     ..scale(device[4]),
                                 ))),
                             ]),
                                 new GestureDetector(
                                     onTap: (){
                                         //jogtimer?.cancel();
                                          turntoTianQi();
                                     },
                                     child:
                                 new Padding(
                                     padding: const EdgeInsets.only(left:25.0,bottom:75.0),
                                 child: new Transform(

                                         child: new Image.asset('Assets/menu-tianqi.png',width: 96.0,height: 96.0),
                                         //alignment: FractionalOffset.center,
                                         transform: new Matrix4.identity()
                                                                     ..scale(device[3]),

                                 ))),
                             ]
                         )),


       ],

        ),

    );

    var orientation;
    orientation = MediaQuery.of(context).orientation;
   switch (orientation) {
     case Orientation.landscape:
       print('menupage:display landscape screen');
    return new Scaffold(
        backgroundColor: Colors.black87,
        body:new GestureDetector(
          onDoubleTap: (){
          jogtimer?.cancel();
          Navigator.pushNamed(context, '/home');
          },
          child:
        new CustomMultiChildLayout(
            delegate: new LandspaceLayout(),
            children: <Widget>[

              new LayoutId(
                  id: LandspaceLayout.background,
                        //Assets/menu.png
                  child:new Container()),
              new LayoutId(
                  id: LandspaceLayout.centerElements,
                  child:
                  new Stack(
                      children: [
                          picker,
                          menuView,
                      ]
                  ),
              )
            ]))
    );
    break;

    case Orientation.portrait:
      print('menupage:display portrait screen');
      return new Scaffold(
          backgroundColor: Colors.black87,
          body:new GestureDetector(
            onDoubleTap: (){
              Navigator.pushNamed(context, '/home');
            },
            child:
          new CustomMultiChildLayout(
              delegate: new PortraitLayout(),
              children: <Widget>[

                new LayoutId(
                    id: PortraitLayout.background,
                    //Assets/menu.png

                    child: new Container()),
                new LayoutId(
                    id: PortraitLayout.centerElements,
                    child:new Stack(
                        children: [
                            picker,
                            menuView,
                        ]
                    ),
                  )
              ])
            ));
      break;
    }
  }
}
