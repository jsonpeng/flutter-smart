import 'package:flutter/material.dart';
import 'dart:math' as math;

class RemDevice extends StatefulWidget{

  @override
  RemDeviceState createState() => new RemDeviceState();
}


class RemDeviceState extends State<RemDevice>{


  @override
  Widget build(BuildContext context) {
    var orientation;
    orientation = MediaQuery.of(context).orientation;
   switch (orientation) {
     case Orientation.landscape:
     print("display landscape screen");
return new Scaffold(
  backgroundColor: Colors.black,
  body: new CustomMultiChildLayout(
    delegate: new LandspaceLayout(),
    children: <Widget>[

    new LayoutId(

    id: LandspaceLayout.background,
    child:new Image.asset('Assets/device-delete2.png',fit: ImageFit.contain),

),
    new LayoutId(
        id: LandspaceLayout.centerElements,
        child: new Container(
          child:
              new Column(
                children: [

                  new Padding(
                      padding: const EdgeInsets.only(top: 40.0),
          child: new Image.asset('Assets/device-delete1.png',fit:ImageFit.contain,width:420.0,height: 420.0 ),
        ),

                  new GestureDetector(
                    onTap: (){

                    },
                    child: new Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: new Text('CONFIRM',style: new TextStyle(
                          fontFamily: 'Hepworth',
                          color: Colors.white,
                          decorationColor:Colors.black87,
                          fontSize: 70.0,
                          fontWeight: FontWeight.w800),

                      ),
                    )
                  ),

                  new GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: new Padding(
                          padding: const EdgeInsets.all(35.0),
                          child: new Text('CANCEL',style: new TextStyle(
                              fontFamily: 'Hepworth',
                              color: Colors.white,
                              decorationColor:Colors.black87,
                              fontSize: 40.0,
                              fontWeight: FontWeight.w800),

                          ),
                      )
                  ),
    ])
        ),
    ),
    ]));
 break;
 case Orientation.portrait:
 print("display portrait screen");
 return new Scaffold(
   backgroundColor: Colors.black,
   body: new CustomMultiChildLayout(
     delegate: new PortraitLayout(),
     children: <Widget>[

     new LayoutId(

     id: PortraitLayout.background,
     child:new Image.asset('Assets/device-delete2.png',fit: ImageFit.contain),

 ),
     new LayoutId(
         id: PortraitLayout.centerElements,
         child: new Container(
           child:
               new Column(
                 children: [

                   new Padding(
                       padding: const EdgeInsets.only(top: 30.0),
           child: new Image.asset('Assets/device-delete1.png',fit:ImageFit.contain,width:200.0,height: 200.0 ),
         ),

                   new GestureDetector(
                     onTap: (){

                     },
                     child: new Padding(
                       padding: const EdgeInsets.all(0.0),
                       child: new Text('CONFIRM',style: new TextStyle(
                           fontFamily: 'Hepworth',
                           color: Colors.white,
                           decorationColor:Colors.black87,
                           fontSize: 40.0,
                           fontWeight: FontWeight.w800),

                       ),
                     )
                   ),

                   new GestureDetector(
                       onTap: (){
                         Navigator.of(context).pop();
                       },
                       child: new Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: new Text('CANCEL',style: new TextStyle(
                               fontFamily: 'Hepworth',
                               color: Colors.white,
                               decorationColor:Colors.black87,
                               fontSize: 20.0,
                               fontWeight: FontWeight.w800),

                           ),
                       )
                   ),
     ])
         ),
     ),
     ]));
 break;
  }

  }

}




/*
 * this is landspace screen display in flutter app size layout
 * only need add exdends a other class to show other size
 */
class LandspaceLayout extends MultiChildLayoutDelegate {
  LandspaceLayout();

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
          new BoxConstraints.tightFor(width: size.height, height: size.height));
      positionChild(background, new Offset((math.max(size.width, size.height) -
          math.min(size.width, size.height)) / 2, 0.0));
      layoutChild(centerElements,
          new BoxConstraints.expand(width: size.height, height: size.height));
      positionChild(centerElements, new Offset(
          (math.max(size.width, size.height) -
              math.min(size.width, size.height)) / 2, 0.0));
}
  @override
  bool shouldRelayout(LandspaceLayout oldDelegate) => false;

}


/*
 * this is portrait screen display in flutter app size layout
 * only need add exdends a other class to show other size
 */
class PortraitLayout extends MultiChildLayoutDelegate {
  PortraitLayout();

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
          new BoxConstraints.tightFor(width: size.width, height: size.width));
      positionChild(
          background, new Offset(0.0, (math.max(size.width, size.height) -
          math.min(size.width, size.height)) / 2));
      layoutChild(centerElements,
          new BoxConstraints.expand(width: size.width, height: size.width));
      positionChild(centerElements, new Offset(
          0.0, (math.max(size.width, size.height) -
          math.min(size.width, size.height)) / 2));

}
  @override
  bool shouldRelayout(PortraitLayout oldDelegate) => false;
}
