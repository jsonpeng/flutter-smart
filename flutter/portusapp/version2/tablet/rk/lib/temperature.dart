import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:math' as math;



const Duration _kDialAnimateDuration = const Duration(milliseconds: 200);

const double _kTwoPi = 2 * math.PI;

const int _itemNum = 31;



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

    double radius = size.shortestSide / 2.0;

    Offset center = new Offset(size.width / 2.0, size.height / 2.0);


    const double labelPadding = 24.0;
    //
    double labelRadius = radius - labelPadding;

    Offset getOffsetForTheta(double theta) {
      return center + new Offset(labelRadius * math.cos(theta),
          -labelRadius * math.sin(theta));
    }



    final Paint selectorPaint = new Paint()
      ..color = accentColor;
    //little circle centerpoint
    final Point focusedPoint = getOffsetForTheta(theta).toPoint();
    //little circle radius
    final double focusedRadius = labelPadding - 4.0;

    canvas.drawCircle(focusedPoint, focusedRadius, selectorPaint);

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

    double fraction = (index/_itemNum )%_itemNum;

    return (math.PI / 2.0 - math.PI/6 - fraction * _kTwoPi) % _kTwoPi;

  }

  int _getIndexForTheta(double theta) {

    double fraction = (0.15- (theta % _kTwoPi) / _kTwoPi) % 1.0;

      int index = (fraction * _itemNum).round() % _itemNum;

      return index;

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



class TemperatureLayout extends StatefulWidget {
  TemperatureLayout({
    Key key,
    this.initialvalue
  }) : super(key: key) {
    assert(initialvalue != null);
  }

  final int initialvalue;

  @override
  TemperatureLayoutState createState() => new TemperatureLayoutState();
}


class TemperatureLayoutState extends State<TemperatureLayout> {
  @override
  void initState() {
    super.initState();

    _selectedItem = config.initialvalue;

    print(_selectedItem);

  }


  int _selectedItem;
  Timer timer;






  void _handleTimeChanged(int index) {
    setState(() {
      _selectedItem = index;
      print(_selectedItem);



    });
  }



  @override
  Widget build(BuildContext context) {
    /*
    Widget picker = new Container(
        child:
        new Padding(
            padding: const EdgeInsets.all(0.0),
            child: new AspectRatio(
                aspectRatio: 1.0,
                child: new TimeTest(


                    selectedIndex: _selectedItem,
                    onChanged: _handleTimeChanged,
                ),

            )
        ),

    );
  */  
/*
    Widget text =new Padding(padding: const EdgeInsets.only(top:140.0,left:130.0,bottom: 0.0),
        child: new Text('$_selectedItem',style: new TextStyle(
            color: Colors.white,
            decorationColor:Colors.black87,
            fontSize: 80.0,
            fontWeight: FontWeight.w800))
    );
    */
    return
                  new Container(
                      child:new Column(
                          children: <Widget>[
// new Stack(
//     children: <Widget>[

                                //picker,


                            //text
                        //])
                          ]),
                  );






  }

}

class TemperaturePage extends StatefulWidget {
  TemperaturePage({Key key}) : super(key: key);

  @override
  _TemperaturePageState createState() => new _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
bool or =false;






/*
  void _home(){
      setState((){

          Navigator.of(context).pushNamed('/menu');
      });
  }
  */

  @override
  Widget build(BuildContext context) {

    return  new Scaffold(
        backgroundColor:Colors.black87,
    body: new CustomMultiChildLayout(
         delegate: new TemperaturePageLayout(),
         children: <Widget>[

           new LayoutId(
               id: TemperaturePageLayout.background,
               child: new Image.asset('Assets/temperature5.png',
                   fit: ImageFit.contain)),
            new LayoutId(
              id: TemperaturePageLayout.centerElements,



    child:
    // new Container(
    //
    //     child: new Column(
    //      mainAxisAlignment: MainAxisAlignment.center,
    //      children:<Widget>[

             new Stack(
                 children: <Widget>[

new Padding(
    padding: const EdgeInsets.only(top: 0.0,left: 0.0),
         child: new TemperatureLayout(initialvalue: 29),
     ),


/*
new Column(

    children:<Widget>[




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




]
),
*/
]),

// ]
//
//     ))
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
