/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:            2017/03/30
*@LastUpdate:      2017/05/10
*
*This file is mainly used for statics for node completed the power and waste
*
*/
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'menu.dart';
import 'base.dart';
import '../communication/newws.dart';
import '../communication/jogcontrol.dart';

const Duration _kDialAnimateDuration = const Duration(milliseconds: 200);

const double _kTwoPi = 2 * math.PI; //math.PI=3.1415926

const int _itemNum = 100;

int lastSelectedItem=0;

String message='';
enum timeType{
    minute,
    hour,
    day,
    month,
}
timeType type;


List<double> valueArr = new List();
List dataArr;
List<double> arr = new List();
double maxValue=0.0;


class StaticMenuPainter extends CustomPainter  {
  StaticMenuPainter({
//    this.primaryLabels,
//    this.secondaryLabels,
    this.backgroundColor,
    this.accentColor,
    this.theta

  });
//  StaticMenuPainter({
//    this.backgroundColor,
//    this.accentColor,
//    this.theta,
//    Animation<double> animation
//
//  }):_animation = animation,super(repaint:animation);
//  final List<TextPainter> primaryLabels;
//  final List<TextPainter> secondaryLabels;
  final Color backgroundColor;
  final Color accentColor;
  final double theta;
//  final Animation<double> _animation;
//  static int increasement=0;
//  static  int _animationIntValue=0;
  double backgoundLineLength = 30.0;




//  for (int i=0;i<30;i++){
//  arr[i]=30.0*(new math.Random().nextDouble());
//  }
  double _getThetaForIndex(int index) {
//    double fraction = (config.mode == _TimePickerMode.hour) ?
//    (time.hour / _kHoursPerPeriod) % _kHoursPerPeriod :
//    (time.minute / _kMinutesPerHour) % _kMinutesPerHour;
//    double fraction = ((index)/_itemNum )%_itemNum;
    double fraction = ((_itemNum - index)/_itemNum )%_itemNum;

//    return (math.PI / 2.0 - math.PI/_itemNum - fraction * _kTwoPi) % _kTwoPi;
    return (math.PI / 2.0 + math.PI +_kTwoPi*((5.5-1)/_itemNum) - fraction * _kTwoPi) % _kTwoPi;
  }

  int _getIndexForTheta(double theta) {
    double fraction = (0.25 - 0.5 +((5.5-1)/_itemNum) - (theta % _kTwoPi) / _kTwoPi) % 1.0;
    int index = (fraction * _itemNum).round() % _itemNum;

    return _itemNum-index;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //background circle radius
    double radius = size.shortestSide / 2.0-12.0;

    Offset center = new Offset(size.width / 2.0, size.height / 2.0);

    final Paint linePaint = new Paint()
      ..color = new Color.fromARGB(255,106,211,0);
    linePaint.strokeWidth = 12.0;

    double maxLineLength = 30.0;
    double smallCircleRadius = radius - maxLineLength;



    //add background grey line
    for(int i=1;i<=100;i++){
//      math.Random random = new math.Random();
//      double lineLength = 30.0*random.nextDouble();
      double lineLength = backgoundLineLength;
      double lineTheta = _getThetaForIndex(i);
//      int triangleIndex = _getIndexForTheta(theta);
//      double triangleTheta = _getThetaForIndex(triangleIndex);
      Point point1 = new Point(smallCircleRadius*math.cos(lineTheta) + center.dx,center.dy - smallCircleRadius*math.sin(lineTheta));
      Point point2 = new Point((smallCircleRadius + lineLength)*math.cos(lineTheta) + center.dx,center.dy - (smallCircleRadius + lineLength)*math.sin(lineTheta));

      linePaint.color= new Color.fromARGB(255,25,25,25);

      canvas.drawLine(point1, point2, linePaint);

    }
    linePaint.color =Colors.orange[400];
    //new Color.fromARGB(255,106,211,0);

    for(int i=1;i<=100;i++){
//      math.Random random = new math.Random();
//      double lineLength = 30.0*random.nextDouble();
//      double lineLength = arr[i%arr.length];
      double lineLength = arr[i-1];
      double lineTheta = _getThetaForIndex(i);
      int triangleIndex = _getIndexForTheta(theta);
      double triangleTheta = _getThetaForIndex(triangleIndex);
      Point point1 = new Point(smallCircleRadius*math.cos(lineTheta) + center.dx,center.dy - smallCircleRadius*math.sin(lineTheta));
      Point point2 = new Point((smallCircleRadius + lineLength)*math.cos(lineTheta) + center.dx,center.dy - (smallCircleRadius + lineLength)*math.sin(lineTheta));
      if(lineTheta==triangleTheta){
        linePaint.color= Colors.orange[400];
        canvas.drawLine(point1,point2,linePaint);
        //linePaint.color= new Color.fromARGB(255,106,211,0);
        linePaint.color= Colors.orange[400];
      }else {
        canvas.drawLine(point1, point2, linePaint);
      }
    }
    print('theta=$theta');
    print('triangleIndex=${_getIndexForTheta(theta)}');
//    if(_animation.value.round()!=_animationIntValue){
//      increasement++;}
//    _animationIntValue = _animation.value.round();

/*
    //triangle side length
    const double sideLength = 60.0;
    //triangle high
    final double high = sideLength * math.cos(math.PI/6.0);
    //the distance of the triangle's farest point to background max circle
    const double trianglePadding = 30.0;
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
*/
  }

  @override
  bool shouldRepaint(StaticMenuPainter oldPainter) {
//    print('old=${oldPainter._animation.value.round()}');
//    print('new=${_animation.value.round()}');
//    return oldPainter.primaryLabels != primaryLabels
//        || oldPainter.secondaryLabels != secondaryLabels
    return oldPainter.backgroundColor != backgroundColor
        || oldPainter.accentColor != accentColor
        || oldPainter.theta != theta;
//        || oldPainter._animation.value.round() !=_animation.value.round();
  }
}


class DeviceTimeTest extends StatefulWidget{
  DeviceTimeTest({
//    this.selectedTime,
//    this.mode,
    this.selectedIndex,
    this.onChanged
  }) {
    assert(selectedIndex != null);
  }

//  final TimeOfDay selectedTime;
   int selectedIndex;
//  final _TimePickerMode mode;
  final ValueChanged<int> onChanged;

// DeviceTimeTest({Key key,}):super(key:key){}

  DeviceTimeTestState createState()=>new DeviceTimeTestState();


}


class DeviceTimeTestState  extends State<DeviceTimeTest> with SingleTickerProviderStateMixin{
Timer statictimer;
  @override
  void initState() {
    super.initState();
  config.selectedIndex=52;
//statictimer=new Timer.periodic(new Duration(milliseconds: 500), settimer);
    _animationC = new AnimationController(
        duration: _kDialAnimateDuration,
        vsync: this,
    );
    _thetaTween= new Tween<double>(begin: _getThetaForIndex(config.selectedIndex));

    _animation = _thetaTween.animate(new CurvedAnimation(
        parent: _animationC,
        curve: Curves.fastOutSlowIn
    ))..addListener(() => setState(() { }));
  //  _updateThetaForPan();
  //_animateTo(_getThetaForIndex(config.selectedIndex));
//   _tween
// ..begin =20.0
//       ..end = 100.0;
  // _animationC  ..forward();
  }

void settimer(Timer statictimer){
  setState((){
  config.selectedIndex=jogDeviceNum;
  });
}
  @override
  void didUpdateConfig(DeviceTimeTest oldConfig) {
//    if (config.mode != oldConfig.mode && !_dragging)
//      _animateTo(_getThetaForTime(config.selectedTime));
    if (!_dragging)
      _animateTo(_getThetaForIndex(config.selectedIndex));

  }

  @override
  void dispose() {
    _animationC.dispose();
    super.dispose();
  }

  Tween<double> _thetaTween;
//  Animation<double> _theta;
  bool _dragging = false;
  AnimationController _animationC;

  Animation<double> _animation;
//  Tween<double> _tween;

//  void _handlePanEnd(DragEndDetails details) {
//    startAnimation();
//  }

  static double _nearest(double target, double a, double b) {
    return ((target - a).abs() < (target - b).abs()) ? a : b;
  }

  void _animateTo(double targetTheta) {
    double currentTheta = _animation.value;
    double beginTheta = _nearest(targetTheta, currentTheta, currentTheta + _kTwoPi);
    beginTheta = _nearest(targetTheta, beginTheta, currentTheta - _kTwoPi);
    _thetaTween
      ..begin = beginTheta
      ..end = targetTheta;
    _animationC
      ..value = 0.0
      ..forward();
  }
  //get the theta of index,the index at the leftest of the circle will return 0,
  //and the highest of the circle will return PI/2,etc,
  double _getThetaForIndex(int index) {
//    double fraction = (config.mode == _TimePickerMode.hour) ?
//    (time.hour / _kHoursPerPeriod) % _kHoursPerPeriod :
//    (time.minute / _kMinutesPerHour) % _kMinutesPerHour;
//    double fraction = ((index)/_itemNum )%_itemNum;
    double fraction = ((_itemNum - index)/_itemNum )%_itemNum;

//    return (math.PI / 2.0 - math.PI/_itemNum - fraction * _kTwoPi) % _kTwoPi;
    return (math.PI / 2.0 + math.PI +_kTwoPi*((5.5-1)/_itemNum) - fraction * _kTwoPi) % _kTwoPi;
  }

  int _getIndexForTheta(double theta) {
    double fraction = (0.25 - 0.5 +((5.5-1)/_itemNum) - (theta % _kTwoPi) / _kTwoPi) % 1.0;
    int index = (fraction * _itemNum).round() % _itemNum;

    return _itemNum-index;
  }


  void _notifyOnChangedIfNeeded() {
    if (config.onChanged == null)
      return;
    int index = _getIndexForTheta(_animation.value);
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
//    turnToPage();

  }


  @override
  Widget build(BuildContext context){

    return  new GestureDetector(

        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: new CustomPaint(
            key: const ValueKey<String>('time-picker-dial'), // used for testing.
            painter: new StaticMenuPainter(

              //圆的背景颜色
                backgroundColor: Colors.white10,
                //圆的指针颜色
                accentColor: Colors.white,
                //圆心到圆的指针
                theta: _animation.value,
//                animation: _animationC
            )

        ),


    );

  }


}



class DeviceLayout extends StatefulWidget {
  DeviceLayout({
    Key key,
    this.initialIndex,
    this.startLightControl,
    this.lightid,
    this.lightstate,
    this.binaraid,
    this.binaraSwitchstate,
    this.binaraSwitchShow,
    this.selectVarifiedBinaraSwitchState,
    this.selectVarifiedLightSwitchState
  }) : super(key: key) {
    assert(initialIndex != null);
  }

  final int initialIndex;
  bool startLightControl;
  int lightid;
  int binaraid;
  int lightstate;
  int binaraSwitchstate;
  bool binaraSwitchShow;
  bool selectVarifiedBinaraSwitchState;
  bool selectVarifiedLightSwitchState;

  @override
  DeviceLayoutState createState() => new DeviceLayoutState();
}

Timer staticstimer;
int jogDeviceNum=50;
bool jogDeviceFlag = true;
class DeviceLayoutState extends State<DeviceLayout> {

  @override
  void initState() {
    super.initState();
    JogControl.jogItem = config.initialIndex;
    print(JogControl.jogItem);
    //_handleModeChanged(_mode);
    type = timeType.minute;
    date = now.subtract(new Duration(seconds:60*JogControl.jogItem));
    //getMessage(jogDeviceNum);
    JogControl.jogNum=4;
    deviceLayoutTimer=new Timer.periodic(new Duration(milliseconds: 250), deviceControlJog);

  }





  Timer deviceLayoutTimer;
  deviceControlJog(Timer deviceLayoutTimer) {
    /*
    if(!config.startLightControl && !config.selectVarifiedBinaraSwitchState){
      getMessage(0);
       _handleIndexChanged(0);
     }
     */
      if(config.startLightControl){
//ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'GET_LIGHTSTATE',nodeid: config.lightid);
        if(config.selectVarifiedLightSwitchState){
          jogDeviceNum=config.lightstate;
          getMessage(jogDeviceNum);
          _handleIndexChanged(jogDeviceNum);

        }
        config.selectVarifiedLightSwitchState=false;
    ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SYSTEM_GET_JOG');
       int temp;
       int jogPos = ZwaveWebsocketComunication.jogPos;
       int jogDirx= ZwaveWebsocketComunication.jogDir;

      //first get data
      if( (state == 1) && (jogPos == newJogPos)){
        if (flag >=4){
        newJogPos = -1;
        state =0;
        flag = 0;
        oldJogPos=jogPos;
        oldJogDirx=jogDirx;
        getMessage(jogDeviceNum);
        _handleIndexChanged(jogDeviceNum);
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
     if(oldJogDirx==1){
           if(newJogPos-oldJogPos>JogControl.jogNum){
               oldJogPos=newJogPos;
               oldJogDirx=newJogDirx;
                jogDeviceNum+=25;
               if(jogDeviceNum>=100){
                 jogDeviceNum=100;
               }
               state = 1;
               getMessage(jogDeviceNum);
               _handleIndexChanged(jogDeviceNum);
               ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_LIGHTSWITCHLEVEL',nodeid: config.lightid,lightlevel:jogDeviceNum*1.0);
               //_handleIndexChanged(JogControl.jogItem);
         }else if(newJogPos<oldJogPos){
              temp=newJogPos;
              if(newJogPos+24-oldJogPos>JogControl.jogNum){
                jogDeviceNum+=25;
               if(jogDeviceNum>=100){
              jogDeviceNum=100;
               }

                //  _handleIndexChanged(JogControl.jogItem);
                   oldJogPos=temp;
                  oldJogDirx=newJogDirx;
                  state = 1;
                  getMessage(jogDeviceNum);
                  _handleIndexChanged(jogDeviceNum);
                   ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_LIGHTSWITCHLEVEL',nodeid: config.lightid,lightlevel:jogDeviceNum*1.0);
          }
        }
     }
     else if(oldJogDirx==0){
         if(newJogPos-oldJogPos<= -JogControl.jogNum){
             oldJogPos=newJogPos;
             oldJogDirx = newJogDirx;
             jogDeviceNum-=25;
             if(jogDeviceNum<=0){
               jogDeviceNum=0;
             }
            //  _handleIndexChanged(JogControl.jogItem);
            state = 1;
              getMessage(jogDeviceNum);
             _handleIndexChanged(jogDeviceNum);
              ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_LIGHTSWITCHLEVEL',nodeid: config.lightid,lightlevel:jogDeviceNum*1.0);
         }else if(newJogPos>oldJogPos){
           temp=newJogPos;
           if(newJogPos-24-oldJogPos<= -JogControl.jogNum){
             jogDeviceNum-=25;
             if(jogDeviceNum<=0){
               jogDeviceNum=0;
             }
          //  _handleIndexChanged(JogControl.jogItem);
           oldJogPos=temp;
           oldJogDirx = newJogPos;
           state =1;
            getMessage(jogDeviceNum);
            _handleIndexChanged(jogDeviceNum);
             ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_LIGHTSWITCHLEVEL',nodeid: config.lightid,lightlevel:jogDeviceNum*1.0);
            }
          }
     }

 }
  if(config.binaraSwitchShow){

        if(config.selectVarifiedBinaraSwitchState){
    //varified the binaraswitch state
    if(config.binaraSwitchstate==0){
      getMessage(0);
      _handleIndexChanged(0);
    }else if(config.binaraSwitchstate==255 && ZwaveWebsocketComunication.swichstate==255){
      getMessage(100);
      _handleIndexChanged(jogDeviceNum);
    }else{
      getMessage(0);
      _handleIndexChanged(0);
    }
}
    config.selectVarifiedBinaraSwitchState=false;
   ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SYSTEM_GET_JOG');
      int temp;
      int jogPos = ZwaveWebsocketComunication.jogPos;
      int jogDirx= ZwaveWebsocketComunication.jogDir;
     //first get data
     if( (state == 1) && (jogPos == newJogPos)){
       if (flag >=4){
       newJogPos = -1;
       state =0;
       flag = 0;
       oldJogPos=jogPos;
       oldJogDirx=jogDirx;

       if (jogDeviceNum >= 90){
         getMessage(100);
         _handleIndexChanged(jogDeviceNum);
         ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_SWITCH_ON',nodeid: config.binaraid);
       }else if(jogDeviceNum <= 10){
         getMessage(0);
         _handleIndexChanged(jogDeviceNum);
         ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_SWITCH_OFF',nodeid: config.binaraid);
       }
       return;
     }else{
       flag++;

       return;
     }
   }else{
     flag=0;
     jogDeviceNum = 50;
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
    if(oldJogDirx==1){
          if(newJogPos-oldJogPos>JogControl.jogNum){
              oldJogPos=newJogPos;
              oldJogDirx=newJogDirx;

              state = 1;
              jogDeviceNum=90;
              //getMessage(100);
              //_handleIndexChanged(jogDeviceNum);
               ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_SWITCH_ON',nodeid: config.binaraid);
              //ZwaveWebsocketComunication.websocket.basicSetting(wsdata: //'SET_SWITCH_ON',nodeid: config.binaraid);
              //_handleIndexChanged(JogControl.jogItem);
        }else if(newJogPos<oldJogPos){
             temp=newJogPos;
             if(newJogPos+24-oldJogPos>JogControl.jogNum){


               //  _handleIndexChanged(JogControl.jogItem);
                  oldJogPos=temp;
                 oldJogDirx=newJogDirx;
                 state = 1;
                   jogDeviceNum=90;
                 getMessage(100);
                _handleIndexChanged(jogDeviceNum);
                 ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_SWITCH_ON',nodeid: config.binaraid);
                  //ZwaveWebsocketComunication.websocket.basicSetting(wsdata: '//SET_SWITCH_ON',nodeid: config.binaraid);
         }
       }
    }
    else if(oldJogDirx==0){
        if(newJogPos-oldJogPos<= -JogControl.jogNum){
            oldJogPos=newJogPos;
            oldJogDirx = newJogDirx;

           //  _handleIndexChanged(JogControl.jogItem);
           state = 1;
             jogDeviceNum=10;
             getMessage(0);
            _handleIndexChanged(jogDeviceNum);
             ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_SWITCH_OFF',nodeid: config.binaraid);
              //ZwaveWebsocketComunication.websocket.basicSetting(wsdata: //'SET_SWITCH_OFF',nodeid: config.binaraid);
        }else if(newJogPos>oldJogPos){
          temp=newJogPos;
          if(newJogPos-24-oldJogPos<= -JogControl.jogNum){

         //  _handleIndexChanged(JogControl.jogItem);
          oldJogPos=temp;
          oldJogDirx = newJogPos;
          state =1;
          jogDeviceNum=10;
           getMessage(0);
           _handleIndexChanged(jogDeviceNum);
            ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_SWITCH_OFF',nodeid: config.binaraid);
            //ZwaveWebsocketComunication.websocket.basicSetting(wsdata: //'SET_SWITCH_OFF',nodeid: config.binaraid);
           }
         }
    }

 }

  }

  getMessage(int index) async{
print("jognum:$index");
    String docDir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('docDir=$docDir');
    String dataDir;
      dataDir = docDir+'/historyhour.json';
    print('dataDir=$dataDir');
    File file = new File(dataDir);
    await file.readAsString(encoding: UTF8).then((String fileData){
      print('fileData=$fileData');
      if(fileData!='') {
       arr.clear();
      // dataArr.clear();
       valueArr.clear();

        message = fileData;
//      print('getmessage=$message');
//
        print('message=$message');
        List data = JSON.decode(message);
        print('decodeData=$data');
        // if (data['data'] != null) {
          dataArr = data[0]['data'];
          //print('dataArr=$dataArr');
          for (int i = 0; i < dataArr.length; i++) {

            Map map = dataArr[i];
            //print('map=$map');
            double value = map['data']*1.0;
            valueArr.add(value.roundToDouble());
            if (value > maxValue) {
              maxValue = value;
            }
          }
        //}
        for (int i = 1; i <=100; i++) {
           if(i>100-index /*|| i==100 || i>94*/){
             arr.add(600.0 * 30 / maxValue);

           }else {
             arr.add(0.0);

         }
        }

      }
      setState((){});
      //print('arr=$arr');
      //print('dataArr=$dataArr');
      //print('valueArr=$valueArr');
    });
    }



  Timer timer;

//String weekday;
//String month;
  DateTime now= new DateTime.now();
  DateTime date;








  void _home(){

    Navigator.of(context).pop();
  }


  void _handleIndexChanged(int index) {
    setState(() {
      lastSelectedItem = JogControl.jogItem;
      JogControl.jogItem = index;
        //  getMessage();
      print(JogControl.jogItem);
    });
  }



  @override
  Widget build(BuildContext context) {
    Widget picker = new Container(
        child:
        new Padding(
            padding: const EdgeInsets.all(0.0),
            child: new AspectRatio(
                aspectRatio: 0.5,
                child: new DeviceTimeTest(

                    selectedIndex: JogControl.jogItem,
                    onChanged: _handleIndexChanged,
                ),

            )
        ),

    );

    Widget text =new GestureDetector(
        onTap:  (){
          _home();
        },
        child:new Padding(padding: const EdgeInsets.only(top:0.0,bottom: 0.0),
            child: new Icon(
                Icons.arrow_back,
                color: Colors.white,
            )

        )
    );


    var orientation;
    orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
      case Orientation.landscape:
        print('statistics page:display landscape');
        return new CustomMultiChildLayout(
            delegate: new LandspaceLayout(),
            children: <Widget>[

              new LayoutId(
                  id: LandspaceLayout.centerElements,

                  child: new Container()),
              new LayoutId(
                  id: LandspaceLayout.background,
                  child:

new GestureDetector(
  onDoubleTap: (){
staticstimer?.cancel();

Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => new MenuPage(initvalue: 5)));

 },
   child:

                  new Stack(
                      children: <Widget>[
                        picker,
                      ])),
              )
            ]
        );
        break;

    }

  }
}
