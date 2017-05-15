import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base.dart';
import 'dart:io';
import 'dev.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math' as math;



const Duration _kDialAnimateDuration = const Duration(milliseconds: 200);

const double _kTwoPi = 2 * math.PI;


const int _itemNum = 7;


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
// the distance to yuanxin
    double radius = size.shortestSide / 2.0+8.0;

    Offset center = new Offset(size.width / 2.0, size.height / 2.0);


    //triangle side length
  const double sideLength = 50.0;
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
    //device[7]=1.2;
     new Timer.periodic(new Duration(seconds:1),turntoTem);
          // Navigator.of(context).pushNamed('/temperature');
        });

    }else if(config.selectedIndex==1){
      print("enter scene page");
//device[1]=1.2;
        new Timer.periodic(new Duration(seconds:1),turntoScene);
     //Navigator.of(context).pushNamed('/sceneselect');

    }else if(config.selectedIndex==2){
      print("enter home page");
      //device[2]=1.2;
     // Navigator.of(context).pushNamed('/home');
    new Timer.periodic(new Duration(seconds:1),turntoAqi);

    }else if(config.selectedIndex==3){
      print("enter tianqi page");
      //device[3]=1.2;
      //Navigator.of(context).pushNamed('/tianqi');
      new Timer.periodic(new Duration(seconds:1),turntoTianQi);

    }else if(config.selectedIndex==4){
      print("enter setting page");
      //device[4]=1.2;
    // Navigator.of(context).pushNamed('/history');
    new Timer.periodic(new Duration(seconds:1),turntoSetting);

    }else if(config.selectedIndex==5){
      print("enter history page");
      //device[5]=1.2;
// Navigator.of(context).pushNamed('/history');
new Timer.periodic(new Duration(seconds:1),turntoHistory);
    }else if(config.selectedIndex==6){
      print("enter device page");
      //device[6]=1.2;
// Navigator.of(context).pushNamed('///device');
new Timer.periodic(new Duration(seconds:1),turntoDevice);
    }

  }

void turntoTem(Timer timer){
     Navigator.of(context).pushNamed('/temperature');
     timer.cancel();

}

void turntoScene(Timer timer){
    Navigator.of(context).pushNamed('/sceneselect');
     timer.cancel();
}

void turntoAqi(Timer timer){
    Navigator.of(context).pushNamed('/home');
     timer.cancel();
}

void turntoSetting(Timer timer){
    //Navigator.of(context).pushNamed('/setting');
     timer.cancel();
}
void turntoTianQi(Timer timer){
    Navigator.of(context).pushNamed('/tianqi');
     timer.cancel();
}
void turntoHistory(Timer timer){
    Navigator.of(context).pushNamed('/history');
     timer.cancel();
}
void turntoDevice(Timer timer){
  var allNodeList;
  _readNodeListFile().then((String value) {
  allNodeList=value;
  Map jsonNodeList=JSON.decode(allNodeList);
  var nodeLength=jsonNodeList['data'];
   int nodelength=nodeLength.length;
   if(nodelength>=2 && jsonNodeList['data'][1]['GenericDeviceClass']!=0){
     print("menupage:have added nodelist");
    Navigator.of(context).pushNamed('/device');
     timer.cancel();
}else{
  print("menupage:need added nodelist");
  Navigator.push(context, new MaterialPageRoute(
    builder: (BuildContext context) => new BasicDevPage()));
       timer.cancel();
}
});
}

  @override
  Widget build(BuildContext context){




    return  new Stack(
        children: [

    new  GestureDetector(

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



class TimePickerDialog extends StatefulWidget {
  TimePickerDialog({
    Key key,
    this.initvalue
  }) : super(key: key) {
       assert(initvalue != null);
  }
  final int initvalue;



  @override
  TimePickerDialogState createState() => new TimePickerDialogState();
}


class TimePickerDialogState extends State<TimePickerDialog> {
  @override
  void initState() {
    super.initState();
    _selectedItem = config.initvalue;
    print(_selectedItem);
  }

  List<double> device=[0.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0];
  int _selectedItem;
  Timer timer;


  void turntoTem(Timer timer){
       Navigator.of(context).pushNamed('/temperature');
       timer.cancel();

  }

  void turntoScene(Timer timer){
      Navigator.of(context).pushNamed('/sceneselect');
       timer.cancel();
  }

  void turntoAqi(Timer timer){
      Navigator.of(context).pushNamed('/home');
       timer.cancel();
  }

  void turntoSetting(Timer timer){
      //Navigator.of(context).pushNamed('/setting');
       timer.cancel();
  }
  void turntoTianQi(Timer timer){
      Navigator.of(context).pushNamed('/tianqi');
       timer.cancel();
  }

  void turntoHistory(Timer timer){
      Navigator.of(context).pushNamed('/history');
       timer.cancel();
  }

  void turntoDevice(Timer timer){
    var allNodeList;
    _readNodeListFile().then((String value) {
    allNodeList=value;
    Map jsonNodeList=JSON.decode(allNodeList);
    var nodeLength=jsonNodeList['data'];
     int nodelength=nodeLength.length;
     if(nodelength>=2 && jsonNodeList['data'][1]['GenericDeviceClass']!=0){
       print("menupage:have added nodelist");
      Navigator.of(context).pushNamed('/device');
       timer.cancel();
  }else{
    print("menupage:need added nodelist");
    Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => new BasicDevPage()));
         timer.cancel();
  }
  });
  }
  
  void _handleIndexChanged(int index) {
    setState(() {
      _selectedItem = index;
      print(_selectedItem);
    if (_selectedItem==1){
      print("increase 1");
      device[1]=1.2;
      device[2]=1.0;
      device[3]=1.0;
      device[4]=1.0;
      device[5]=1.0;
      device[6]=1.0;
      device[7]=1.0;
    }else if(_selectedItem==2){
        print("increase 2");
          device[2]=1.2;
          device[1]=1.0;
          device[3]=1.0;
          device[4]=1.0;
          device[5]=1.0;
          device[6]=1.0;
          device[7]=1.0;
    }else if(_selectedItem==3){
        print("increase 3");
          device[3]=1.2;
          device[1]=1.0;
          device[2]=1.0;
          device[4]=1.0;
          device[5]=1.0;
          device[6]=1.0;
          device[7]=1.0;
    }else if(_selectedItem==4){
        print("increase 4");
          device[4]=1.2;
          device[1]=1.0;
          device[2]=1.0;
          device[3]=1.0;
          device[5]=1.0;
          device[6]=1.0;
          device[7]=1.0;
    }else if(_selectedItem==5){
        print("increase 5");
          device[5]=1.2;
          device[1]=1.0;
          device[2]=1.0;
          device[4]=1.0;
          device[3]=1.0;
          device[6]=1.0;
          device[7]=1.0;
    }else if(_selectedItem==6){
        print("increase 6");
          device[6]=1.2;
          device[1]=1.0;
          device[2]=1.0;
          device[4]=1.0;
          device[5]=1.0;
          device[3]=1.0;
          device[7]=1.0;
    }else if(_selectedItem==7){
        print("increase 7");
          device[7]=1.2;
          device[1]=1.0;
          device[2]=1.0;
          device[4]=1.0;
          device[5]=1.0;
          device[6]=1.0;
          device[3]=1.0;
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
                    selectedIndex: _selectedItem,
                    onChanged: _handleIndexChanged,
                ),
            )
        ),
    );

    Widget menuView =
    new Container(
        child:
        new Column(
       children: [
    new Padding(
    padding: const EdgeInsets.only(top:20.0,left: 50.0),
    child:
           new Row(
               children: [
                   new GestureDetector(
                       onTap: (){
                        turntoTem(timer);
                       },
                      child:
                   new Padding(
                       padding: const EdgeInsets.only(top:30.0,left: 30.0),
                       child:
                   new Transform(


                               //padding: const EdgeInsets.all(20.0),
                           child: new Image.asset('Assets/menu-tem.png',width: 82.0,height: 82.0),
                           //alignment: FractionalOffset.center,
                           transform: new Matrix4.identity()
                                                       ..scale(device[7]),

                   ))),
                   new GestureDetector(
                       onTap: (){
                           turntoScene(timer);
                       },
                       child:
                   new Padding(
                       padding: const EdgeInsets.only(left:40.0,top:10.0),
                   child: new Transform(

                           child: new Image.asset('Assets/menu-scene.png',width: 82.0,height: 82.0),
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
                               turntoDevice(timer);
                              },
                             child:
                          new Padding(
                              padding: const EdgeInsets.only(top:10.0,left:30.0,bottom:0.0),
                              child:
                          new Transform(
                                      //padding: const EdgeInsets.all(20.0),
                                  child: new Image.asset('Assets/menu-device.png',width: 82.0,height: 82.0),
                                  //alignment: FractionalOffset.center,
                                  transform: new Matrix4.identity()
                                                              ..scale(device[6]),

                          ))),
                          new GestureDetector(
                              onTap: (){
                                  turntoAqi(timer);
                              },
                              child:
                          new Padding(
                              padding: const EdgeInsets.only(left:145.0,bottom: 20.0),
                          child: new Transform(
                                  child: new Image.asset('Assets/menu-aqi.png',fit:ImageFit.contain,width: 82.0,height: 82.0),
                                  //alignment: FractionalOffset.center,
                                  transform: new Matrix4.identity()
                                                              ..scale(device[2]),

                          ))),
                      ]
                  )),

                  new Padding(
                  padding: const EdgeInsets.only(top:0.0,left:60.0),
                  child:
                  new Stack(
                    children: [
                         new Row(
                             children: [
                                 new GestureDetector(
                                     onTap: (){
                                      turntoHistory(timer);
                                     },
                                    child:
                                 new Padding(
                                     padding: const EdgeInsets.only(left:0.0,top:0.0,bottom: 20.0),
                                     child:
                                 new Transform(
                                             //padding: const EdgeInsets.all(20.0),
                                         child: new Image.asset('Assets/menu-history.png',width: 82.0,height: 82.0),
                                         //alignment: FractionalOffset.center,
                                         transform: new Matrix4.identity()
                                                                     ..scale(device[5]),
                                 ))),
                                 new Stack(
                                     children: [
                                 new GestureDetector(
                                     onTap: (){
                                         turntoSetting(timer);
                                     },
                                     child:
                                 new Padding(
                                     padding: const EdgeInsets.only(left:20.0,top:60.0),
                                 child: new Transform(
                                         child: new Image.asset('Assets/menu-setting1.png',width: 56.0,height: 56.0),
                                         //alignment: FractionalOffset.center,
                                         transform: new Matrix4.identity()
                                                                     ..scale(device[4]),

                                 ))),
                                 new GestureDetector(
                                     onTap: (){
                                         turntoSetting(timer);
                                     },
                                     child:
                                 new Padding(
                                     padding: const EdgeInsets.only(left:60.0,top:60.0),
                                 child: new Transform(
                                         child: new Image.asset('Assets/menu-setting2.png',width: 26.0,height: 26.0),
                                         //alignment: FractionalOffset.center,
                                         transform: new Matrix4.identity()
                                                                     ..scale(device[4]),
                                 ))),
                             ]),
                                 new GestureDetector(
                                     onTap: (){
                                         turntoTianQi(timer);
                                     },
                                     child:
                                 new Padding(
                                     padding: const EdgeInsets.only(left:5.0,bottom:40.0),
                                 child: new Transform(
                                         child: new Image.asset('Assets/menu-tianqi.png',width: 82.0,height: 82.0),
                                         //alignment: FractionalOffset.center,
                                         transform: new Matrix4.identity()
                                                                     ..scale(device[3]),
                                 )
                               ),
                               ),
                             ]
                            )
                          ]
                        )
                       ),
       ],
        ),
        width:300.0,
        height:300.0,
    );
    var orientation;
    orientation = MediaQuery.of(context).orientation;
   switch (orientation) {
     case Orientation.landscape:
       print('menu page:display landscape screen');
    return new Scaffold(
        backgroundColor: Colors.black87,
        body:new GestureDetector(
          onDoubleTap: (){
      turntoAqi(timer);
          },
          child:
        new CustomMultiChildLayout(
            delegate: new LandspaceLayout(),
            children: <Widget>[
              new LayoutId(
                  id: LandspaceLayout.background,
                  child: new Image.asset('Assets/menu.png',
                      fit: ImageFit.contain)),
              new LayoutId(
                  id: LandspaceLayout.centerElements,
                  child:new Stack(
                      children: [
                          picker,
                 menuView,
                      ]
                  ),
              )
            ])
          )
    );
    break;
    case Orientation.portrait:
      print('menu page:display portrait screen');
      return new Scaffold(
          backgroundColor: Colors.black87,
          body:new GestureDetector(
            onDoubleTap: (){
        turntoAqi(timer);
            },
            child:
          new CustomMultiChildLayout(
              delegate: new PortraitLayout(),
              children: <Widget>[
                new LayoutId(
                    id: PortraitLayout.background,
                    child: new Image.asset('Assets/menu.png',
                        fit: ImageFit.contain)),
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
            )
      );
      break;
}
  }
}
