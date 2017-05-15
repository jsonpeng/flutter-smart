import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'base.dart';
import '../communication/websocket.dart';
import 'dart:convert';
import 'dart:io';

const Duration _kDialAnimateDuration = const Duration(milliseconds: 200);
//enum _TimePickerMode { hour, minute }
//圆的周长
const double _kTwoPi = 2 * math.PI; //math.PI=3.1415926
//一天24小时
//const int _kHoursPerDay = 24;
////设置的刻度位
//const int _kHoursPerPeriod = 6;
////分钟
//const int _kMinutesPerHour = 60;
const int _itemNum = 130;

int lastSelectedItem=0;
WebsocketService wsService=new WebsocketService();
// send() async{
// print("send his");
//   wsService.set('gethistory');
// }
String message='';
enum timeType{
    minute,
    hour,
    day,
    month,
}
timeType type;

/*
Future<String> getData() async{

  wsService.onMessage(message);
  print('message=$message');
  return (await'$message');
}
*/
//getData() {
//
//   wsService.onMessage(message);
//   print('message=$message');
//
//}

// List<double> arr = [15.0,22.0,30.0,28.0,10.0,12.0,3.0,23.0,16.0,14.0,19.0,21.0,1.0,30.0,28.0,10.0,15.0,15.0,5.0,13.0,23.0,6.0];
List<double> valueArr = new List();
List dataArr = new List();
List<double> arr = new List();
double maxValue=0.0;
//List<TextPainter> _initPainters(TextTheme textTheme, List<String> labels) {
//  TextStyle style = textTheme.subhead;
//  List<TextPainter> painters = new List<TextPainter>(labels.length);
//  for (int i = 0; i < painters.length; ++i) {
//    String label = labels[i];
//    // TODO(abarth): Handle textScaleFactor.
//    // https://github.com/flutter/flutter/issues/5939
//    painters[i] = new TextPainter(
//        text: new TextSpan(style: style, text: label)
//    )..layout();
//  }
//  return painters;
//}
//
//List<TextPainter> _initHours(TextTheme textTheme) {
//  return _initPainters(textTheme, <String>[
//    //'12', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'
//    'temperature','scene','home','tianqi','history','device'
//  ]);
//}

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
    double radius = size.shortestSide / 2.0;

    Offset center = new Offset(size.width / 2.0, size.height / 2.0);





    final Paint linePaint = new Paint()
      ..color = new Color.fromARGB(255,106,211,0);
    linePaint.strokeWidth = 3.0;

    double maxLineLength = 50.0;
    double smallCircleRadius = radius - maxLineLength;


//    AnimationController animationC = new AnimationController(vsync: new Tic, duration:const Duration(seconds: 5),lowerBound: 0.0,upperBound: 120.0);
//    animationC.forward();
//    int lineIndex = _getIndexForTheta(theta);
//    print('vale=${_animation.value}');
//    print('vale=${_animation.value.round()}');
//    int lineIndex = _animation.value.round();
//    print('lineIndex=$lineIndex');



//    for(int i=0;i<=lineIndex+2*increasement;i++){
////      math.Random random = new math.Random();
////      double lineLength = 30.0*random.nextDouble();
//      double lineLength = arr[(i-increasement)%arr.length];
//      double lineTheta = _getThetaForIndex(i);
//      Point point1 = new Point(smallCircleRadius*math.cos(lineTheta) + center.dx,center.dy - smallCircleRadius*math.sin(lineTheta));
//      Point point2 = new Point((smallCircleRadius + lineLength)*math.cos(lineTheta) + center.dx,center.dy - (smallCircleRadius + lineLength)*math.sin(lineTheta));
//
//      canvas.drawLine(point1,point2,linePaint);
//    }
    //add background grey line
    for(int i=1;i<=120;i++){
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
    linePaint.color =new Color.fromARGB(255,106,211,0);

    for(int i=1;i<=120;i++){
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
        linePaint.color= Colors.white;
        canvas.drawLine(point1,point2,linePaint);
        linePaint.color= new Color.fromARGB(255,106,211,0);
      }else {
        canvas.drawLine(point1, point2, linePaint);
      }
    }
    print('theta=$theta');
    print('triangleIndex=${_getIndexForTheta(theta)}');
//    if(_animation.value.round()!=_animationIntValue){
//      increasement++;}
//    _animationIntValue = _animation.value.round();

    //triangle side length
    const double sideLength = 30.0;
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


class StaticTimeTest extends StatefulWidget{
  StaticTimeTest({
//    this.selectedTime,
//    this.mode,
    this.selectedIndex,
    this.onChanged
  }) {
    assert(selectedIndex != null);
  }

//  final TimeOfDay selectedTime;
  final int selectedIndex;
//  final _TimePickerMode mode;
  final ValueChanged<int> onChanged;

// StaticTimeTest({Key key,}):super(key:key){}

  StaticTimeTestState createState()=>new StaticTimeTestState();


}


class StaticTimeTestState  extends State<StaticTimeTest> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();

//    getData();


//   while(true){
//
//
//     if(WebsocketService.data!=''){
//       message = WebsocketService.data;
//       break;
//     }
//   };

//   print('message=$message');
//   var data = JSON.decode(message);
//   print('data=$data');
//   if(data['data']!=null){
//     dataArr = data['data'];
//     for(int i=0;i<dataArr.length;i++)
//       {
//         Map map = dataArr[i];
//         valueArr.add(map['data']);
//         if(map['data']>maxValue)
//           {
//             maxValue = map['data'];
//           }
//       }
//
//   }
//    for(int i=0;i<120;i++){
//      arr[i]=valueArr[i]*30/maxValue;
//    }
//  print('arr=$arr');
//    print('dataArr=$dataArr');
//    print('valueArr=$valueArr');
    /*
    _thetaController = new AnimationController(
        duration: _kDialAnimateDuration,
        vsync: this,
    );
    _thetaTween = new Tween<double>(begin: _getThetaForIndex(config.selectedIndex));

    _theta = _thetaTween.animate(new CurvedAnimation(
        parent: _thetaController,
        curve: Curves.fastOutSlowIn
    ))..addListener(() => setState(() { }));
*/
//    _indexTween = new Tween<int>(begin:1,end: 120);
//
//
//    _animationC = new AnimationController(value:0.0 , duration: const Duration(seconds: 4),vsync: this,lowerBound: 0.0,upperBound: 45.0);
//    _animationC.forward();
//
//   _animationC.addListener(()=>setState((){print('setState');}));
    _animationC = new AnimationController(
        duration: _kDialAnimateDuration,
        vsync: this,
    );
    _thetaTween= new Tween<double>(begin: _getThetaForIndex(config.selectedIndex));

    _animation = _thetaTween.animate(new CurvedAnimation(
        parent: _animationC,
        curve: Curves.fastOutSlowIn
    ))..addListener(() => setState(() { }));

//   _tween
//      ..begin =20.0
//      ..end = 120.0;
//   _animationC
//      ..value = 10.0
//      ..forward();
  }

  @override
  void didUpdateConfig(StaticTimeTest oldConfig) {
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

//  double _getThetaForIndex(int index) {
////    double fraction = (config.mode == _TimePickerMode.hour) ?
////    (time.hour / _kHoursPerPeriod) % _kHoursPerPeriod :
////    (time.minute / _kMinutesPerHour) % _kMinutesPerHour;
////    double fraction = ((index)/_itemNum )%_itemNum;
//    double fraction = ((_itemNum - index)/_itemNum )%_itemNum;
//
////    return (math.PI / 2.0 - math.PI/_itemNum - fraction * _kTwoPi) % _kTwoPi;
//    return (math.PI / 2.0 + math.PI - fraction * _kTwoPi) % _kTwoPi;
//  }
//
////  int _getIndexForTheta(double theta) {
////    double fraction = (0.25-0.5/_itemNum - (theta % _kTwoPi) / _kTwoPi) % 1.0;
////    int index = (fraction * _itemNum).round() % _itemNum;
////
////    return _itemNum-index-1;
////  }
//  int _getIndexForTheta(double theta) {
//    double fraction = (0.25 - 0.5 - (theta % _kTwoPi) / _kTwoPi) % 1.0;
//    int index = (fraction * _itemNum).round() % _itemNum;
//
//    return _itemNum-index;
//  }
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
//  void turnToPage(){
//    if(config.selectedIndex==6){
//      print("enter temperature page");
//      gotoTemperature();
//
//    }else if(config.selectedIndex==1){
//      print("enter scene page");
//      gotoScene();
//
//    }else if(config.selectedIndex==2){
//      print("enter home page");
//      gotoHome();
//
//    }else if(config.selectedIndex==3){
//      print("enter tianqi page");
//      gotoTianqi();
//
//    }else if(config.selectedIndex==4){
//      print("enter tianqi page");
//      gotoHistory();
//
//    }else if(config.selectedIndex==5){
//      print("enter tianqi page");
//      gotoDevice();
//    }
//
//  }
//  void gotoTemperature(){
//    Navigator.of(context).pushNamed('/temperature');
//  }
//
//  void gotoScene(){
//    Navigator.of(context).pushNamed('/sceneselect');
//  }
//
//  void gotoHome(){
//    Navigator.of(context).pushNamed('/home');
//  }
//
//  void gotoTianqi(){
//    Navigator.of(context).pushNamed('/tianqi');
//  }
//  void gotoHistory(){
//    Navigator.of(context).pushNamed('/history');
//  }
//
//  void gotoDevice(){
//    Navigator.of(context).pushNamed('/device');
//  }


  @override
  Widget build(BuildContext context){


//    ThemeData theme = Theme.of(context);
//    List<TextPainter> primaryLabels;
//    List<TextPainter> secondaryLabels;
//    switch (config.mode) {
//      case _TimePickerMode.hour:
//        primaryLabels = _initHours(theme.textTheme);
//        secondaryLabels = _initHours(theme.accentTextTheme);
//        break;
//      case _TimePickerMode.minute:
//      //    primaryLabels = _initMinutes(theme.textTheme);
//      //    secondaryLabels = _initMinutes(theme.accentTextTheme);
//        break;
//    }
    return  new GestureDetector(

        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: new CustomPaint(
            key: const ValueKey<String>('time-picker-dial'), // used for testing.
            painter: new StaticMenuPainter(
//                primaryLabels: primaryLabels,
//                secondaryLabels: secondaryLabels,
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



class HistoryDataPage extends StatefulWidget {
  HistoryDataPage({
    Key key,
    this.initialIndex
  }) : super(key: key) {
    assert(initialIndex != null);
  }

  final int initialIndex;

  @override
  HistoryDataPageState createState() => new HistoryDataPageState();
}


class HistoryDataPageState extends State<HistoryDataPage> {
  @override
  void initState() {
    super.initState();
//    send();
//    wsService.onMessage(message).whenComplete(getMessage);
    //_selectedTime = config.initialTime;
    //final DateTime now = new DateTime.now();
    _selectedItem = config.initialIndex;
    //new TimeOfDay(hour: now.hour, minute: now.minute);
    print(_selectedItem);
    //_handleModeChanged(_mode);
    type = timeType.minute;
    date = now.subtract(new Duration(seconds: 60*_selectedItem));
//    Timer timer = new Timer(new Duration(seconds: 5),getMessage);
    getMessage();

    //config.initialTime=new TimeOfDay(hour: now.hour, minute: now.minute);
  }
//
  getMessage() async{


//    print('wss.data=${WebsocketService.data}');
//    if(WebsocketService.data!='') {
//      message = WebsocketService.data;
//      print('getmessage=$message');
//
//      print('message=$message');
//      var data = JSON.decode(message);
//      print('data=$data');
//      if (data['data'] != null) {
//        dataArr = data['data'];
//        print('dataArr=$dataArr');
//        for (int i = 0; i < dataArr.length; i++) {
//
//          Map map = dataArr[i];
//          print('map=$map');
//          double value = map['data']*1.0;
//          valueArr.add(value.roundToDouble());
//          if (value > maxValue) {
//            maxValue = value;
//          }
//        }
//      }
//      for (int i = 0; i < valueArr.length; i++) {
//        arr.add(valueArr[i] * 30 / maxValue) ;
//      }
//      setState((){});
//    }
    String docDir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('docDir=$docDir');
    String dataDir;
    switch(type){
      case timeType.minute:
      dataDir = docDir+'/historyminute.json';
      break;
      case timeType.hour:
      dataDir = docDir+'/historyhour.json';
      break;
      case timeType.day:
      dataDir = docDir+'/historyday.json';
      break;
      case timeType.month:
      dataDir = docDir+'/historymonth.json';
      break;
    }
    print('dataDir=$dataDir');
//    String dataDir = docDir+'historyminute.json';
    File file = new File(dataDir);
    await file.readAsString(encoding: UTF8).then((String fileData){
      print('fileData=$fileData');
      if(fileData!='') {
       arr.clear();
       dataArr.clear();
       valueArr.clear();

        message = fileData;
//      print('getmessage=$message');
//
        print('message=$message');
        Map data = JSON.decode(message);
        print('decodeData=$data');
        if (data['data'] != null) {
          dataArr = data['data'];
          print('dataArr=$dataArr');
          for (int i = 0; i < dataArr.length; i++) {

            Map map = dataArr[i];
            print('map=$map');
            double value = map['data']*1.0;
            valueArr.add(value.roundToDouble());
            if (value > maxValue) {
              maxValue = value;
            }
          }
        }
        for (int i = 0; i < 120; i++) {
          if(i>=valueArr.length){
            arr.add(0.0);
          }else {
            arr.add(valueArr[i] * 30 / maxValue);
          }
        }

      }
      setState((){});
      print('arr=$arr');
      print('dataArr=$dataArr');
      print('valueArr=$valueArr');
    });
    }

//        print('wss.data=${WebsocketService.data}');
//    if(WebsocketService.data!='') {


//  _TimePickerMode _mode = _TimePickerMode.hour;
//  TimeOfDay _selectedTime;
  int _selectedItem;
  Timer timer;



//String weekday;
//String month;
  DateTime now= new DateTime.now();
  DateTime date;


  // void _handleModeChanged(_TimePickerMode mode) {
  //   HapticFeedback.vibrate();
  //   setState(() {
  //     _mode = mode;
  //     print(_mode);
  //   });
  // }
  String  weekday(DateTime time){

    if(time.weekday==DateTime.MONDAY){
      return 'Monday';
    }else if(time.weekday==DateTime.TUESDAY){
      return 'Tuesday';
    }else if(time.weekday==DateTime.WEDNESDAY){
      return 'Wednesday';
    }else if(time.weekday==DateTime.THURSDAY){
      return 'Thursday';
    }else if(time.weekday==DateTime.FRIDAY){
      return 'Friday';
    }else if(time.weekday==DateTime.SATURDAY){
      return 'Saturday';
    }else if(time.weekday==DateTime.SUNDAY) {
      return 'Sunday';
    }

  }

  String  month(DateTime time){

    if(time.month==DateTime.JANUARY){
      return 'January';
    }else if(time.month==DateTime.FEBRUARY){
      return 'February';
    }else if(time.month==DateTime.MARCH){
      return 'March';
    }else if(time.month==DateTime.APRIL){
      return 'April';
    }else if(time.month==DateTime.MAY){
      return 'May';
    }else if(time.month==DateTime.JUNE){
      return 'June';
    }else if(time.month==DateTime.JULY) {
      return 'July';
    }else if(time.month==DateTime.AUGUST){
      return 'August';
    }else if(time.month==DateTime.SEPTEMBER){
      return 'September';
    }else if(time.month==DateTime.OCTOBER){
      return 'October';
    }else if(time.month==DateTime.NOVEMBER){
      return 'November';
    }else if(time.month==DateTime.DECEMBER){
      return 'December';
    }

  }
  DateTime dateTime(int index){
    if(index>120){
      index=120;
    }
    int len = valueArr.length;
    if(len==0){
      return now;
    }
    if(index>len){
      return now;
    }
    String time = dataArr[(index-1)%len]['time'];

    return DateTime.parse(time);
  }


  String saveMoney(DateTime time){
    return new math.Random().nextInt(300).toString();
  }

  String electric(int index){
    if(index>120){
      index=120;
    }
    int len = valueArr.length;
    if(len==0){
      return 'loading...';
    }
    if(index>len){
      return '0';
    }
    return valueArr[(index-1)%len].toString();
//    return new math.Random().nextInt(100).toString();
  }
  void _home(){

    Navigator.of(context).pop();
  }


  void _handleIndexChanged(int index) {
    setState(() {
      lastSelectedItem = _selectedItem;
      _selectedItem = index;
      if(_selectedItem==125){
        if(lastSelectedItem==124){
          print('type=$type');
          //waitting for optimize
          switch(type){
            case timeType.minute:type = timeType.hour;
            break;
            case timeType.hour:type = timeType.day;
            break;
            case timeType.day:type = timeType.month;
            break;
            case timeType.month:type = timeType.day;
            break;
          }
          getMessage();
          print('type=$type');
          print('DisplayHigherLevel');
        }else if(lastSelectedItem==126){
          print('type=$type');
          //waitting for optimize
          switch(type){
            case timeType.minute:type = timeType.month;
            break;
            case timeType.hour:type = timeType.minute;
            break;
            case timeType.day:type = timeType.hour;
            break;
            case timeType.month:type = timeType.day;
            break;
          }
          print('type=$type');
          print('DisplayLowerLevel');

        getMessage();
      }
      print(_selectedItem);


    }});
  }



  @override
  Widget build(BuildContext context) {
    Widget picker = new Container(
        child:
        new Padding(
            padding: const EdgeInsets.all(0.0),
            child: new AspectRatio(
                aspectRatio: 0.5,
                child: new StaticTimeTest(
//                    mode: _mode,
//                    selectedTime: _selectedTime,
//                    onChanged: _handleTimeChanged,

                    selectedIndex: _selectedItem,
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
        // new Text('$_selectedItem',style: new TextStyle(
        //     color: Colors.white,
        //     decorationColor:Colors.black87,
        //     fontSize: 20.0,
        //   ))
        )
    );
    Widget centerText=new Center(
        child:new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              new Padding(
                  padding: const EdgeInsets.only(top:80.0,bottom: 10.0),
                  child: new Text('${weekday(dateTime(_selectedItem))}',
                      style:new TextStyle(color: Colors.white,
                          fontFamily: 'Hepworth',
                          decorationColor:Colors.black87,
                          fontSize: 16.0,

                      ))),

              new Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                        padding: const EdgeInsets.only(top:0.0,bottom: 0.0),
                        child:  new Text('${month(dateTime(_selectedItem))}',
                            //textAlign: TextAlign.center,{(_animation.value * 31.0).toStringAsFixed(0)}
                            style: new TextStyle(
                                fontFamily: 'Hepworth',
                                color: Colors.white,
                                decorationColor:Colors.black87,
                                fontSize: 36.0,


                            ))),
                    new Padding(
                        padding: const EdgeInsets.only(top:0.0,left:20.0,bottom: 0.0),
                        child:  new Text('${dateTime(_selectedItem).day}',
                            //textAlign: TextAlign.center,{(_animation.value * 31.0).toStringAsFixed(0)}
                            style: new TextStyle(
                                fontFamily: 'Hepworth',
                                color: Colors.white,
                                decorationColor:Colors.black87,
                                fontSize: 36.0,


                            ))),
                  ]),

              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                        padding: const EdgeInsets.only(top:20.0,bottom: 0.0),
                        child:  new Text('${saveMoney(date)}',
                            //textAlign: TextAlign.center,{(_animation.value * 31.0).toStringAsFixed(0)}
                            style: new TextStyle(
                                fontFamily: 'Hepworth',
                                color: Colors.white,
                                decorationColor:Colors.black87,
                                fontSize: 36.0,


                            ))),
                    new Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom: 10.0),
                        child:  new Text(' ¥',
                            //textAlign: TextAlign.center,{(_animation.value * 31.0).toStringAsFixed(0)}
                            style: new TextStyle(
                                fontFamily: 'Hepworth',
                                color: Colors.white,
                                decorationColor:Colors.black87,
                                fontSize: 20.0,


                            ))),
                  ]),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom: 0.0),
                        child:  new Text('${electric(_selectedItem+1)}',
                            //textAlign: TextAlign.center,{(_animation.value * 31.0).toStringAsFixed(0)}
                            style: new TextStyle(
                                fontFamily: 'Hepworth',
                                color: Colors.white,
                                decorationColor:Colors.black87,
                                fontSize: 36.0,


                            ))),
                    new Padding(
                        padding: const EdgeInsets.only(top:20.0,bottom: 10.0),
                        child:  new Text(' kw',
                            //textAlign: TextAlign.center,{(_animation.value * 31.0).toStringAsFixed(0)}
                            style: new TextStyle(
                                fontFamily: 'Hepworth',
                                color: Colors.white,
                                decorationColor:Colors.black87,
                                fontSize: 20.0,


                            ))),
                  ]),
//                new Column(
//                    children: <Widget>[
//                      new GestureDetector(
//                      //onTap: _handleTap,
//                      //behavior: HitTestBehavior.opaque,
//                          child:
//                          new Padding(
//                              padding: const EdgeInsets.only(top:20.0,bottom: 0.0),
//                              child:new SizedBox(
//                                  width: 200.0,
//                                  height: 80.0,
//                                  child: new Text('$aqi',
//                                      textAlign: TextAlign.center,
//                                      style: new TextStyle(
//                                          color: Colors.white,
//                                          decorationColor:Colors.black87,
//                                          fontSize: 80.0,
//
//
//                                      ))))),],),



            ]
        ),


    );
//    return new Scaffold(
//        backgroundColor: Colors.black87,
//        body:new CustomMultiChildLayout(
//    return new CustomMultiChildLayout(
//            delegate: new MenuPageLayout(),
//            children: <Widget>[
//
//              new LayoutId(
//                  id: MenuPageLayout.centerElements,
////                  child: new Image.asset('Assets/select.png',
////                      fit: ImageFit.contain)),
////                  child:new Center(child: new Text('history',style:  new TextStyle(
////                      color: Colors.white)))),
//        child: centerText),
//              new LayoutId(
//                  id: MenuPageLayout.background,
//                  child:
////                  new Container(
////                      child:new Column(
////                          children: <Widget>[
////                  new Stack(
////                    children: <Widget>[
//
//                                picker,
////                    ]),
////text,
//
//                           // text
////                          ]),
////                  )
//
//              )
//
//            ]
//    );
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

                  child: centerText),
              new LayoutId(
                  id: LandspaceLayout.background,
                  child:
                  new GestureDetector(
                    onDoubleTap: (){
              Navigator.pop(context);
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
      case Orientation.portrait:
        print('statistics page:display portrait');
        return new CustomMultiChildLayout(
            delegate: new PortraitLayout(),
            children: <Widget>[

              new LayoutId(
                  id: PortraitLayout.centerElements,

                  child: centerText),
              new LayoutId(
                  id: PortraitLayout.background,
                  child:
                  new GestureDetector(
                    onDoubleTap: (){
              Navigator.pop(context);
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
