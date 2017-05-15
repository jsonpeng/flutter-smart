import 'package:flutter/material.dart';
import 'base.dart';
import 'dart:math' as math;
import '../communication/newws.dart';

class RemDevice extends StatefulWidget{
  RemDevice({
    Key key,
    this.nodeid
  }) : super(key: key) {
       assert(nodeid != null);
  }
final int nodeid;
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
                      padding: const EdgeInsets.only(top: 30.0),
          child: new Image.asset('Assets/device-delete1.png',fit:ImageFit.contain,width:200.0,height: 200.0 ),
        ),

                  new GestureDetector(
                    onTap: (){
ZwaveWebsocketComunication ws=new ZwaveWebsocketComunication();
ws.basicSetting("REMOVE_NODE");
  Navigator.of(context).pushNamed('/device');
                    },
                    child: new Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: new Text('CONFIRM',style: new TextStyle(
                          fontFamily: 'Hepworth',
                          color: Colors.white,
                          decorationColor:Colors.black87,
                          fontSize: 40.0),

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
                            ),

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
                           fontSize: 40.0
                          ),
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
                               fontSize: 20.0),

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
