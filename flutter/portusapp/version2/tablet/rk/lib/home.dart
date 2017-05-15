import 'package:flutter/material.dart';
import 'communication/websocket.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
//import 'dart:convert';
import 'package:flutter/scheduler.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var imagefile ="Assets/home.png";

  double  homeImageSize=1.0;
  double font =280.0;
  bool _showOutAqi = false;
  bool _showHomeAnimation=true;


  AnimationController _animation = new AnimationController(
      vsync:const TestVSync(),
      duration: new Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 280.0
    );

    void _startAnimation() {

  _animation.forward(from:0.0);

}


 start() async{
      WebsocketService ws=new WebsocketService();
        ws.set("discorvory");
        ws.set("getnodelist");
        _readFile().then((String value) {
            //print(value);
        // var values=JSON.decode(value);
        //JSON.decode(value);
        print('success read:'+value);
            // print(values);
           // print(_counter);
            //_writetofile();
        });
     // jsondata= await ws.readJson(datafile);
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


//String _counter="";
  void initState() {
      super.initState();

     //start();

  }

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('$dir/nodelist.json');
    return new File('$dir/nodelist.json');
  }

  Future<String> _readFile() async {
    try {
      File file = await _getLocalFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      return contents;
    } on FileSystemException {
      return "";
    }
  }

  void _homestate() {
    setState((){

//imagefile="Assets/home2.png";
homeImageSize=0.5;
 _startAnimation();
//_startAnimation();
_showOutAqi=true;
_showHomeAnimation=true;

    });

  }
 Timer timer;
  void _home(){
      setState((){
          Navigator.of(context).pushNamed('/menu');
         // Navigator.push(context, new MaterialPageRoute(
                                    //builder: (BuildContext context) => new TimePickerDialog(timer:timer,Turntohome: true)));
      });
  }

  void _back(){
      setState((){
        _showHomeAnimation=false;
        homeImageSize=1.0;
        _showOutAqi=false;
          //Navigator.of(context).pushNamed('/home');

         // Navigator.push(context, new MaterialPageRoute(
                                    //builder: (BuildContext context) => new TimePickerDialog(timer:timer,Turntohome: true)));
      });
  }





  @override
  Widget build(BuildContext context) {
      List<Widget> chips = <Widget>[


      ];

      List<Widget> homeAnimation=<Widget>[];

      //List<Widget> aqi=<Widget>[];
/*
      if (!_showOutAqi) {
        chips.add(
     new Container(
                    child:
          new GestureDetector(
               onTap: (){
                  _home();
              },
              child:new Text('AQI',style: new TextStyle(
               color: Colors.white,
               decorationColor:Colors.black87,
               fontSize: 50.0,
               fontWeight: FontWeight.w800),
           textAlign: TextAlign.center)),
           decoration: new BoxDecoration(
             backgroundColor: Colors.black,
           ),
       ),
               //onDeleted: _home,
        );
      }
*/
      if (_showOutAqi) {
        chips.add(
    new Container(
                    child:
          new GestureDetector(
               onTap: (){
                  _home();
              },
              child:new Text('129',style: new TextStyle(
               fontFamily: 'Hepworth',
               color: Colors.white,
               decorationColor:Colors.black87,
               fontSize: 70.0,
               fontWeight: FontWeight.w800),
           textAlign: TextAlign.center)),
           decoration: new BoxDecoration(
             backgroundColor: Colors.black,
           ),
       ),
               //onDeleted: _home,
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



    return  new Scaffold(
        backgroundColor:Colors.black87,
    body:new CustomMultiChildLayout(
         delegate: new HomePageLayout(),
         children: <Widget>[

           new LayoutId(

               id: HomePageLayout.background,
               child:new Transform(
                   child:

               new Image.asset('$imagefile',
                   fit: ImageFit.contain),

  alignment: FractionalOffset.center,
                        transform: new Matrix4.identity()
                          ..scale(homeImageSize),
               )),

            new LayoutId(
              id: HomePageLayout.centerElements,


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
     alignment: const FractionalOffset(2.7,2.7),
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

       new GestureDetector(
                onTap: (){
                    _home();
                },
                onDoubleTap: (){
                _homestate();
                },
                onLongPress :(){
                _back();
                },

        child:new Center(
      // padding: const EdgeInsets.all(0.0),
        child:new Text('39',style: new TextStyle(
            fontFamily: 'Hepworth',
             color: Colors.white,
             decorationColor:Colors.black87,
             fontSize: font,
             fontWeight: FontWeight.w800),
textAlign: TextAlign.center,
         ))),





]
),


]
    )),
alignment: FractionalOffset.center,
transform: new Matrix4.identity()
                            ..scale(homeImageSize),
)])

),





]));
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
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;
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


class HomePageLayout extends MultiChildLayoutDelegate {
  HomePageLayout();

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
  bool shouldRelayout(HomePageLayout oldDelegate) => false;
}
