import 'package:flutter/material.dart';
import 'base.dart';
import 'menu.dart';
//import 'dart:async';
//import 'communication/websocket.dart';
import 'dart:math' as math;



const Duration _kDialAnimateDuration = const Duration(milliseconds: 100);


const double _kTwoPi = 2 * math.PI;


const int _itemNum = 3;
bool _shownight=true;
bool _showparty=false;
bool _showadd=false;

class SceneMenuPainter extends CustomPainter {
  const SceneMenuPainter({

    this.backgroundColor,
    this.accentColor,
    this.theta
  });


  final Color backgroundColor;
  final Color accentColor;
  final double theta;

  @override
  void paint(Canvas canvas, Size size) {

    double radius = size.shortestSide / 2.0+18.0;

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
  bool shouldRepaint(SceneMenuPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor
        || oldPainter.accentColor != accentColor
        || oldPainter.theta != theta;
  }
}


class SceneTimeTest extends StatefulWidget{
  SceneTimeTest({

    this.selectedIndex,
    this.onChanged
  }) {
     assert(selectedIndex != null);
  }


  final int selectedIndex;

  final ValueChanged<int> onChanged;



  SceneTimeTestState createState()=>new SceneTimeTestState();


}


class SceneTimeTestState  extends State<SceneTimeTest> with SingleTickerProviderStateMixin{

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
  void didUpdateConfig(SceneTimeTest oldConfig) {

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
    // double fraction = (0.25-0.5/_itemNum - (theta % _kTwoPi) / _kTwoPi) %
    // 1.0;
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
     setState((){


    });

    //super.initState();



}



  @override
  Widget build(BuildContext context){




    return  new GestureDetector(

        onPanStart: _handlePanStart,
        onPanUpdate: _handlePanUpdate,
        onPanEnd: _handlePanEnd,
        child: new CustomPaint(
            key: const ValueKey<String>('time-picker-dial'), // used for testing.
            painter: new SceneMenuPainter(

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
    double font=66.0;
  @override
  void initState() {
    super.initState();
    _selectedItem = config.initialvalue;
    print(_selectedItem);
  }


  int _selectedItem;
  //Timer timer;


  void _handleIndexChanged(int index) {
    setState(() {
      _selectedItem = index;
      print(_selectedItem);

      if (_selectedItem ==3){

              print("enter movie night");
              _shownight=true;
               _showparty=false;
               _showadd=false;
           }else if(_selectedItem ==1){
        print("enter party time");
                   _shownight=false;
                    _showadd=false;
                    _showparty=true;
               }else if(_selectedItem ==2){
                   print("enter morning time");
                   _shownight=false;
                    _showadd=true;
                    _showparty=false;
               }

    });
  }




  @override
  Widget build(BuildContext context) {
      List<Widget> chips = <Widget>[


      ];

      if (_shownight) {
        chips.add(

new Column(
   children: <Widget>[
            new Center(
              child: new Padding(
                padding: const EdgeInsets.only(top: 120.0),
            child:new Text('SLOW',  style: new TextStyle(
              color: Colors.white,
                fontSize: font,
                //fontStyle: FontStyle.italic,
                fontFamily: 'Hepworth',
              ))
            )
          ),
              new Center(

              child:new Text('WAKE UP',  style: new TextStyle(
              color: Colors.white,
                  fontSize: font,
                  //fontStyle: FontStyle.italic,
                  fontFamily: 'Hepworth',
                ))



             ),
])


        );
      }
      if (_showadd) {
        chips.add(

new Column(
   children: <Widget>[
     new GestureDetector(
onTap: (){
Navigator.pushNamed(context, '/device');

},
child:
     new Center(
       child:
            new Padding(
           padding: const EdgeInsets.only(top:100.0,bottom: 0.0,left:0.0,right: 0.0),
            child:
            new Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 185.0,
            ),
              )
            )),

])


        );
      }


      if (_showparty) {
        chips.add(

new Column(
   children: <Widget>[
            new Padding(
           padding: const EdgeInsets.only(top:120.0,bottom: 0.0,left:60.0,right: 0.0),
            child:new Text('PARTY',  style: new TextStyle(
              color: Colors.white,
                fontSize: font,
                fontFamily: 'Hepworth',
              ))  ),
              new Padding(
             padding: const EdgeInsets.only(top:0.0,bottom: 0.0,left:120.0),
              child:new Text('TIME',  style: new TextStyle(
              color: Colors.white,
                  fontSize: font,
                  fontFamily: 'Hepworth',
                ))



             ),
])


        );
      }
    Widget picker = new Container(
        child:
        new Padding(
            padding: const EdgeInsets.all(0.0),
            child: new AspectRatio(
                aspectRatio: 1.0,
                child: new SceneTimeTest(
                    selectedIndex: _selectedItem,
                    onChanged: _handleIndexChanged,
                ),
            )
        ),

    );

    Widget text =new Padding(padding: const EdgeInsets.only(top:0.0,bottom: 0.0),
        child: new Text('$_selectedItem',style: new TextStyle(
            color: Colors.white,
            decorationColor:Colors.black87,
            fontSize: 20.0))
    );

    return
                new Stack(
                    children: <Widget>[
                picker,
                //text,

                new Column(
                  children: chips.map((Widget widget) {
                    return new Container(

                      child: new Padding(
                padding: const EdgeInsets.only(top:0.0),
                          child: widget)
                    );
                  }).toList()
                ),

]);




}
}

class SceneSelectPage extends StatefulWidget{
    SceneSelectPage({Key key,}):super(key: key){}

    @override
    _SceneSelectPageState createState() =>new _SceneSelectPageState();


}

class _SceneSelectPageState extends State<SceneSelectPage>{





@override
void initState() {
    super.initState();
//    _shownight=true;



     }
/*
void _device(){
    setState((){
//            print("this is device");
//font=100.0;
    Navigator.of(context).pushNamed('/sceneadd');
    });

}

*/


   @override
   Widget build(BuildContext context){
     var orientation;
     orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
      case Orientation.landscape:

     return new Scaffold(
         backgroundColor: Colors.black87,
     body: new GestureDetector(
       onDoubleTap: (){
         Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new TimePickerDialog(initvalue: 1)));
       },
       child:new CustomMultiChildLayout(
          delegate: new LandspaceLayout(),
          children: <Widget>[

            new LayoutId(
                id: LandspaceLayout.background,
                child: new Image.asset('Assets/menu.png',
                    fit: ImageFit.contain)),
             new LayoutId(
               id: LandspaceLayout.centerElements,
     child:
     new Container(

    child:new Column(

    mainAxisAlignment: MainAxisAlignment.center,
    children:<Widget>[

                new Center(

                        child:
                new Common(initialvalue: 0)),

 ]
      ))),
    ])
)
  );
    break;
    case Orientation.portrait:

    return new Scaffold(
       backgroundColor: Colors.black87,
    body: new GestureDetector(
      onDoubleTap: (){
        Navigator.push(context, new MaterialPageRoute(
         builder: (BuildContext context) => new TimePickerDialog(initvalue: 1)));
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
    child:
    new Container(

    child:new Column(

    mainAxisAlignment: MainAxisAlignment.center,
    children:<Widget>[

              new Center(

                      child:
              new Common(initialvalue: 0)),

    ]
    ))),
    ])
)
  );
    break;

  }
   }
}





class SceneSet extends StatefulWidget{
    SceneSet({Key key,}):super(key: key){}

    @override
    _SceneSetState createState() =>new _SceneSetState();
}

class _SceneSetState extends State<SceneSet>{
    @override
    Widget build(BuildContext context){
   return new Container(
child:new Text('redirict set'),

   );

    }
}
