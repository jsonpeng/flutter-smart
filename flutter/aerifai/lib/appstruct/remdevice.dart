/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:              2017/03/20
*@LastUpdate:        2017/04/17
*
*This file is the delete node progress for device and varifiled the  device type
*
*/
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'base.dart';
import 'menu.dart';
import 'device.dart';
import '../communication/newws.dart';


class RemDevice extends StatefulWidget{
  RemDevice({
    Key key,
    this.nodeclass
  }) : super(key: key) {
       assert(nodeclass != null);
  }
final int nodeclass;
  @override
  RemDeviceState createState() => new RemDeviceState();
}


class RemDeviceState extends State<RemDevice>{
  @override
  void initState(){
  super.initState();
  varifiedDevice(config.nodeclass);
  ZwaveWebsocketComunication.websocket.basicSetting(wsdata: "REMOVE_NODE");
  }
  Timer timer;
  void turnToDevice(Timer timer){
  //Navigator.pushNamed(context, '/device');
  Navigator.push(context, new MaterialPageRoute(
  builder: (BuildContext context) => new DevicePage(initvalue: 0)));
  timer.cancel();
  }

  String deviceClass;
  void varifiedDevice(int nodeclass){
    switch (nodeclass){
      case 16:
      deviceClass= 'Assets/device_02.png';
      break;
      case 17:
      deviceClass= 'Assets/device_03.png';
      break;
      case 33:
      deviceClass= 'Assets/device_01.png';
      break;
      Defalut:
      deviceClass= 'Assets/device_01.png';
      break;
    }
  }

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
    child:new Container(
       width: 720.0,
       decoration: new BoxDecoration(
       backgroundColor: Colors.yellow[700],
       borderRadius: new BorderRadius.all(const Radius.circular(4200.0),),
       ),


       ),
    //new Image.asset('Assets/device-delete2.png',fit: BoxFit.contain),
),
    new LayoutId(
        id: LandspaceLayout.centerElements,
        child: new Container(
          child:
              new Column(
                children: [
                  new Stack(
                    children: [
                      new Padding(
                          padding: const EdgeInsets.only(top: 90.0,left:50.0),
                  child: new Image.asset('$deviceClass',fit:BoxFit.contain,width:300.0,height: 300.0 ),
                  ),

                  new Padding(
                      padding: const EdgeInsets.only(top: 40.0),
          child: new Image.asset('Assets/device-delete1.png',fit:BoxFit.contain,width:420.0,height: 420.0 ),
        ),
                        ]
                        ),


                  new GestureDetector(
                    onTap: (){
                      ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'GET_NODELIST');
                      //Navigator.of(context).pushNamed('/device');
                      new Timer.periodic(new Duration(seconds: 1), turnToDevice);
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
     child:
     new Container(
        width: 720.0,
        decoration: new BoxDecoration(
        backgroundColor: Colors.yellow[700],
        borderRadius: new BorderRadius.all(const Radius.circular(4200.0),),
        )
        ),
     //new Image.asset('Assets/device-delete2.png',fit: BoxFit.contain),

 ),
     new LayoutId(
         id: PortraitLayout.centerElements,
         child: new Container(
           child:
               new Column(
                 children: [

                   new Padding(
                       padding: const EdgeInsets.only(top: 30.0),
           child: new Image.asset('Assets/device-delete1.png',fit:BoxFit.contain,width:200.0,height: 200.0 ),
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
