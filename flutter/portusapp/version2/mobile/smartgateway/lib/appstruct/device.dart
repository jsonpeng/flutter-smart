import 'package:flutter/material.dart';
import 'dart:io';
//import 'dart:convert';
import 'dart:async';
import 'package:smartgateway/communication/websocket.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';


const Duration _kDialAnimateDuration = const Duration(milliseconds: 100);


const double _kTwoPi = 2 * math.PI;


int _itemNum=5;
Future<String> _readFile() async {
  // try {
  File file = await _getNodeNumFile();
  // read the variable as a string from the file.
  String contents = await file.readAsString();
  //_itemNum=contents;
  return contents;
  //} on FileSystemException {
  //return "";
  //}
}
Future<File> _getNodeNumFile() async {
  // get the path to the document directory.
  String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
  print('$dir/nodenum.json');
  return new File('$dir/nodenum.json');
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

    double radius = size.shortestSide / 2.0+15.0;

    Offset center = new Offset(size.width / 2.0, size.height / 2.0);


    //triangle side length
    const double sideLength = 40.0;
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
    _readFile().then((String value) {
      //setState(() {
      _itemNum=int.parse(value)+1;
      print("success num:$_itemNum");
      //});
    });
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
    updatestate();

  }

  void updatestate(){

//     if(config.selectedIndex!=3){
//       print("should get nodelist");
//
// WebsocketService ws=new WebsocketService();
// ws.set('getnodelist');
//     }
  }



  @override
  Widget build(BuildContext context){




    return  new GestureDetector(

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


    );

  }


}



class Common extends StatefulWidget {
  Common({
  Key key,
  this.initialvalue,
  }) : super(key: key) {
    assert(initialvalue != null);
  }
  final int initialvalue;


  @override
  CommonState createState() => new CommonState();
}


class CommonState extends State<Common> {

  double _discreteValue=20.0;
  var devicefile="Assets/add.png";
  @override
  void initState() {
    super.initState();
    _selectedItem = config.initialvalue;
    print(_selectedItem);
  }
  bool showslider=false;
  bool showswitch=false;
  bool switchValue = false;
  int _selectedItem;
  //Timer timer;
  void _adddevice(){
    setState((){
      WebsocketService ws=new WebsocketService();
      ws.set("addnode");
    });
  }

void _removenode(){
    setState((){
      WebsocketService ws=new WebsocketService();
      ws.set("remnode");
    });
}

  void _home(){
    setState((){
      //print("this is home");
      Navigator.of(context).pop();
      //_discreteValue = 27.0;
      // Navigator.of(context).pushNamed('/menu');
    });
  }

  void _handleIndexChanged(int index) {
    setState(() {
      _selectedItem = index;
      print(_selectedItem);

      if(_selectedItem==0){
        showswitch=true;
        showslider=false;
        devicefile="Assets/menu.png";
      }else if(_selectedItem==1){
        showslider=true;
        showswitch=false;
        devicefile="Assets/home.png";
      }else if(_selectedItem==2){
        showswitch=true;
        showslider=false;
        devicefile="Assets/temperature5.png";
      }else if(_selectedItem==3){
        showslider=false;
        showswitch=false;
        devicefile="Assets/add.png";
      }else if(_selectedItem==4){
        showswitch=true;
        showslider=false;
        devicefile="Assets/tianqi.png";
      }else if(_selectedItem==5){
        showslider=false;
        showswitch=true;
        devicefile="Assets/sun.png";
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = <Widget>[


    ];

    if(showswitch){
      chips.add(
          new Center(
              child: new Padding(
                padding: const EdgeInsets.only(top:240.0),
                child: new Switch(
                    activeColor: Colors.yellow[600],
                    value: switchValue,
                    onChanged: (bool value) {
                      setState(() {
                        switchValue = value;
                        if (switchValue==true){
                          print("switch on");
                          WebsocketService ws=new WebsocketService();
                          ws.set("switchon");
                        }else if(switchValue==false){
                          print("switch off");
                                WebsocketService ws=new WebsocketService();
                          ws.set("switchoff");

                        }
                      });
                    }
                ),
              )

          ));
    }

    if(showslider){
      chips.add(
          new Container(
              child: new Column(
                  children: <Widget>[
                    new Center(
                        child: new Padding(
                            padding: const EdgeInsets.only(top:240.0),
                            child: new Slider(
                                activeColor:Colors.yellow[400],
                                value: _discreteValue,
                                min: 0.0,
                                max: 100.0,
                                divisions: 100,
                                label: '${_discreteValue.round()}',
                                thumbOpenAtMin: true,
                                onChanged: (double value) {
                                  setState(() {
                                     _discreteValue = value;
                                    //print(_discreteValue);
                                    WebsocketService ws=new WebsocketService();
                                    //int wsdata=int.parse('$_discreteValue');
                                    ws.lightchange(_discreteValue);

                                  });
                                }
                            ))),
                  ]
              )));

    }
    Widget picker = new Container(
      child:
      new Padding(
          padding: const EdgeInsets.all(0.0),
          child: new AspectRatio(
            aspectRatio: 1.0,
            child: new TimeTest(
              selectedIndex: _selectedItem,
              onChanged: _handleIndexChanged,
            ),
          )
      ),

    );

    // Widget text =new Padding(padding: const EdgeInsets.only(top:0.0,bottom: 0.0),
    //     child: new Text('$_selectedItem',style: new TextStyle(
    //         color: Colors.white,
    //         decorationColor:Colors.black87,
    //         fontSize: 20.0,
    //         fontWeight: FontWeight.w800))
    // );

    Widget device =new Column(
        children: <Widget>[
          new Padding(
              padding: const EdgeInsets.only(top:0.0),
              child: new GestureDetector(
                  onTap: (){
                    _home();
                  },

                  child: new Icon(
                    Icons.arrow_back,
                    color: Colors.white,

                  ))),
          new Center(
              child: new GestureDetector(
                  onTap: (){
                    _adddevice();
                  },
                  onLongPress:(){
                   _removenode();
                  },

                  child: new Padding(
                    padding: const EdgeInsets.only(top:100.0),
                    child: new Image.asset('$devicefile',fit: ImageFit.contain,width: 120.0,height: 120.0),
                  ))),



        ]
    );



    return new Column(
        children: <Widget>[
          new Stack(
              children: <Widget>[
                picker,
                device,
                new Column(
                    children: chips.map((Widget widget) {
                      return new Container(

                          child: new Padding(
                              padding: const EdgeInsets.only(top:0.0),
                              child: widget)
                      );
                    }).toList()
                ),
              ]
          ),
        ]);

  }
}


class DevicePage extends StatefulWidget {
  DevicePage({Key key}) : super(key: key);

  @override
  _DevicePageState createState() => new _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  bool or =false;


  //double _discreteValue = 29.0;



  @override
  Widget build(BuildContext context) {

    return  new Scaffold(
        backgroundColor:Colors.black87,
        body:new CustomMultiChildLayout(
            delegate: new TemperaturePageLayout(),
            children: <Widget>[

              new LayoutId(
                  id: TemperaturePageLayout.background,
                  child: new Image.asset('Assets/all.png',
                      fit: ImageFit.contain)),
              new LayoutId(
                  id: TemperaturePageLayout.centerElements,



                  child:new Container(

                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget>[

                            new Stack(
                                children: <Widget>[

                                  new Padding(
                                    padding: const EdgeInsets.only(top: 0.0,left: 0.0),
                                    child: new Common(initialvalue: 3),
                                  ),





                                ]),







                          ]

                      ))
              )])
    );



  }
}


class TemperaturePageLayout extends MultiChildLayoutDelegate {
  TemperaturePageLayout();

  static final String background = 'background';
  static final String centerElements = 'centerElements';

  // Horizontally: the feature product image appears on the left and
  // occupies 50% of the available width; the feature product's
  // description apepars on the right and occupies 50% of the available
  // width + unitSize. The left and right widgets overlap and the right
  // widget is stacked on top.
  @override
  void performLayout(Size size) {
    layoutChild(background,
        new BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(background, Offset.zero);
    layoutChild(centerElements,
        new BoxConstraints.expand(width: size.width, height: size.height));
    positionChild(centerElements, Offset.zero);
  }

  @override
  bool shouldRelayout(TemperaturePageLayout oldDelegate) => false;
}
