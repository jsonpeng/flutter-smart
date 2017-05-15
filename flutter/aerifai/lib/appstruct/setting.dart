/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:            2017/03/30
*@LastUpdate:      2017/05/08
*This file is mainly used for debugging system Settings,
*such as the demo video demo switch machine restart gateway college, etc
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'base.dart';
import 'menu.dart';
import '../communication/newws.dart';



const PlatformMethodChannel settingMethodChannel =const PlatformMethodChannel('video');

 Future<Null> _openAllVideo() async {
   int result = await settingMethodChannel.invokeMethod('playMovie');
  print('get result :$result');
 }

 Future<Null> _setWifi() async {
   int result = await settingMethodChannel.invokeMethod('setWifi');
        print('get result :$result');
 }


class SystemSetting extends StatefulWidget{

@override
SystemSettingState createState()=>new SystemSettingState();

}

class SystemSettingState extends State<SystemSetting>{
  @override
  void initState() {
    super.initState();
    //_reboots();
  }

  void _reboots(){
Navigator.pushNamed(context, '/reboot');
      // Navigator.push(context, new MaterialPageRoute(
      //       builder: (BuildContext context) => new ReBoot()));
  }

//Widget settingPage =


@override
  Widget build(BuildContext context) {
    var orientation;
    orientation = MediaQuery.of(context).orientation;
    switch (orientation) {
     case Orientation.landscape:
     print("SettingPage:Landscape Screen");
        return  new Scaffold(
        backgroundColor:Colors.black87,
        body:new GestureDetector(
          onDoubleTap: (){
            Navigator.push(context, new MaterialPageRoute(
                    builder: (BuildContext context) => new MenuPage(initvalue: 4)));
          },
        child:
        new CustomMultiChildLayout(
           delegate: new LandspaceLayout(),
           children: <Widget>[
             new LayoutId(
                 id: LandspaceLayout.background,
                 child:new Container()),
              new LayoutId(
                id: LandspaceLayout.centerElements,
                        child:new GestureDetector(
                          onDoubleTap: (){
                            Navigator.push(context, new MaterialPageRoute(
                                    builder: (BuildContext context) => new MenuPage(initvalue: 4)));
                          },
                        child:new Stack(
                        children: [
                          new Padding(
                            padding: const EdgeInsets.only(top:50.0,left: 160.0),
                          child:
                          new Column(
                        children:
                        [
                          new Center(
                          child:new GestureDetector(
                          onTap: (){
                            _setWifi();
                          },
                          child:
                          new Padding(
                           padding: const EdgeInsets.all(20.0),
                           child:
                           new Row(
                             children: [

                               new Icon(
                                   Icons.wifi,
                                   color:Colors.white,
                                   size:55.0,
                               ),
                          new Padding(
                           padding: const EdgeInsets.only(left:50.0),
                          child:new Text('WifiSetting',style: new TextStyle(
                           color: Colors.white,
                           fontFamily: 'Hepworth',
                           fontSize: 56.0
                          ))),
                          ]
                          )),
                          )
                          ),

                         new Center(
                        child:new GestureDetector(
                        onTap: (){
                          print("show demo movie");
                          //UrlLauncher.launch('http://www.portushome.com/static/flutterapp/version2/app.apk');
                          _openAllVideo();
                        },
                        child:
                        new Padding(
                          padding: const EdgeInsets.all(20.0),
                          child:
                          new Row(
                            children: [
                              new Icon(
                                  Icons.airplay,
                                  color:Colors.white,
                                  size:55.0,
                              ),
                        new Padding(
                          padding: const EdgeInsets.only(left:50.0),
                        child:new Text('DemoShow',style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'Hepworth',
                          fontSize: 56.0
                        ))),
                        ]
                        )),
                        )
                        ),

                        new GestureDetector(
                        onTap: (){
                          ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_RESET_NETWORK');
                          ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'GET_NODELIST');
                          print("reset network");

                        },
                        child:
                        new Center(
                        child:
                        new Padding(
                          padding: const EdgeInsets.all(20.0),
                          child:
                          new Row(
                            children: [
                              new Icon(
                                  Icons.autorenew,
                                  color:Colors.white,
                                  size:55.0,
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(left:50.0),
                              child:
                        new Text('ResetNetwork',style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'Hepworth',
                          fontSize: 56.0
                        ))),
                        ])),
                        )
                        ),




                        new Center(
                        child:new GestureDetector(
                        onTap: (){
                          ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SYSTEM_REBOOT');
                          print("reboot sysytem");
                          _reboots();
                        },
                        child:
                        new Padding(
                          padding: const EdgeInsets.all(20.0),
                          child:
                          new Row(
                            children: [
                              new Icon(
                                  Icons.autorenew,
                                  color:Colors.white,
                                  size:55.0,
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(left:50.0),
                              child:
                        new Text('ReBoot',style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'Hepworth',
                          fontSize: 56.0
                        ))),
                        ])),
                        )
                        ),

                        new Center(
                        child:new GestureDetector(
                        onTap: (){
                          ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SYSTEM_POWER_OFF');
                          print("ShutDown sysytem");
                          _reboots();
                        },
                        child:
                        new Padding(
                          padding: const EdgeInsets.all(20.0),
                          child:
                          new Row(
                            children: [

                              new Icon(
                                  Icons.block,
                                  color:Colors.white,
                                  size:55.0,
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(left:50.0),
                              child:
                        new Text('ShutDown',style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'Hepworth',
                          fontSize: 56.0
                        ))),
                        ])),
                        )
                        ),

                        new Center(
                        child:new GestureDetector(
                        onTap: (){
                          print("update app");
                          UrlLauncher.launch('http://www.portushome.com/static/flutterapp/version2/app.apk');
                        },
                        child:
                        new Padding(
                          padding: const EdgeInsets.all(20.0),
                          child:
                          new Row(

                            children: [
                              new Icon(
                                  Icons.update,
                                  color:Colors.white,
                                  size:55.0,
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(left:50.0),
                              child:
                        new Text('Update',style: new TextStyle(
                          color: Colors.white,
                          fontFamily: 'Hepworth',
                          fontSize: 56.0
                        ))),
                        ])),
                        )
                        ),
                        ]
                        ))
                        ],
                        ),
        ))
      ])));
        break;

        case Orientation.portrait:
         print("SettingPage:Portrait Screen");
         return  new Scaffold(
         backgroundColor:Colors.black87,
         body:new GestureDetector(
         child:
         new CustomMultiChildLayout(
            delegate: new PortraitLayout(),
            children: <Widget>[
              new LayoutId(
                  id: PortraitLayout.background,
                  child:new Container()),
               new LayoutId(
                 id: PortraitLayout.centerElements,
                         child:new Stack(
                         children: [
                           new Padding(
                             padding: const EdgeInsets.only(top:50.0,left: 160.0),
                           child:
                           new Column(
                         children:
                         [
                           new Center(
                           child:new GestureDetector(
                           onTap: (){
                             _setWifi();
                           },
                           child:
                           new Padding(
                            padding: const EdgeInsets.all(20.0),
                            child:
                            new Row(
                              children: [

                                new Icon(
                                    Icons.wifi,
                                    color:Colors.white,
                                    size:55.0,
                                ),
                           new Padding(
                            padding: const EdgeInsets.only(left:50.0),
                           child:new Text('WifiSetting',style: new TextStyle(
                            color: Colors.white,
                            fontFamily: 'Hepworth',
                            fontSize: 56.0
                           ))),
                           ]
                           )),
                           )
                           ),

                          new Center(
                         child:new GestureDetector(
                         onTap: (){
                           print("show demo movie");
                           //UrlLauncher.launch('http://www.portushome.com/static/flutterapp/version2/app.apk');
                           _openAllVideo();
                         },
                         child:
                         new Padding(
                           padding: const EdgeInsets.all(20.0),
                           child:
                           new Row(
                             children: [
                               new Icon(
                                   Icons.airplay,
                                   color:Colors.white,
                                   size:55.0,
                               ),
                         new Padding(
                           padding: const EdgeInsets.only(left:50.0),
                         child:new Text('DemoShow',style: new TextStyle(
                           color: Colors.white,
                           fontFamily: 'Hepworth',
                           fontSize: 56.0
                         ))),
                         ]
                         )),
                         )
                         ),

                         new GestureDetector(
                         onTap: (){
                           ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SET_RESET_NETWORK');
                           print("reset network");

                         },
                         child:
                         new Center(
                         child:
                         new Padding(
                           padding: const EdgeInsets.all(20.0),
                           child:
                           new Row(
                             children: [
                               new Icon(
                                   Icons.autorenew,
                                   color:Colors.white,
                                   size:55.0,
                               ),
                               new Padding(
                                 padding: const EdgeInsets.only(left:50.0),
                               child:
                         new Text('ResetNetwork',style: new TextStyle(
                           color: Colors.white,
                           fontFamily: 'Hepworth',
                           fontSize: 56.0
                         ))),
                         ])),
                         )
                         ),




                         new Center(
                         child:new GestureDetector(
                         onTap: (){
                           ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SYSTEM_REBOOT');
                           print("reboot sysytem");
                           _reboots();
                         },
                         child:
                         new Padding(
                           padding: const EdgeInsets.all(20.0),
                           child:
                           new Row(
                             children: [
                               new Icon(
                                   Icons.autorenew,
                                   color:Colors.white,
                                   size:55.0,
                               ),
                               new Padding(
                                 padding: const EdgeInsets.only(left:50.0),
                               child:
                         new Text('ReBoot',style: new TextStyle(
                           color: Colors.white,
                           fontFamily: 'Hepworth',
                           fontSize: 56.0
                         ))),
                         ])),
                         )
                         ),

                         new Center(
                         child:new GestureDetector(
                         onTap: (){
                           ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SYSTEM_POWER_OFF');
                           print("ShutDown sysytem");
                           _reboots();
                         },
                         child:
                         new Padding(
                           padding: const EdgeInsets.all(20.0),
                           child:
                           new Row(
                             children: [

                               new Icon(
                                   Icons.block,
                                   color:Colors.white,
                                   size:55.0,
                               ),
                               new Padding(
                                 padding: const EdgeInsets.only(left:50.0),
                               child:
                         new Text('ShutDown',style: new TextStyle(
                           color: Colors.white,
                           fontFamily: 'Hepworth',
                           fontSize: 56.0
                         ))),
                         ])),
                         )
                         ),

                         new Center(
                         child:new GestureDetector(
                         onTap: (){
                           print("update app");
                           UrlLauncher.launch('http://www.portushome.com/static/flutterapp/version2/app.apk');
                         },
                         child:
                         new Padding(
                           padding: const EdgeInsets.all(20.0),
                           child:
                           new Row(

                             children: [
                               new Icon(
                                   Icons.update,
                                   color:Colors.white,
                                   size:55.0,
                               ),
                               new Padding(
                                 padding: const EdgeInsets.only(left:50.0),
                               child:
                         new Text('Update',style: new TextStyle(
                           color: Colors.white,
                           fontFamily: 'Hepworth',
                           fontSize: 56.0
                         ))),
                         ])),
                         )
                         ),
                         ]
                         ))
                         ],
                         ),
         )
       ])));
        break;
}
  }
}



class ReBoot extends StatefulWidget{

  @override
  ReBootState createState()=>new ReBootState();
}

class ReBootState extends State<ReBoot>  with SingleTickerProviderStateMixin {
  AnimationController _controller;
    Animation<double> _animation;

    @override
    void initState() {
      super.initState();

      _controller = new AnimationController(
        duration: const Duration(milliseconds: 6000),
        vsync: this,
      )..forward();

      _animation = new CurvedAnimation(
        parent: _controller,
        curve: new Interval(0.0, 0.9, curve: Curves.fastOutSlowIn),
        reverseCurve: Curves.fastOutSlowIn
      )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.dismissed)
          _controller.forward();
        else if (status == AnimationStatus.completed)
          _controller.reverse();
      });
    }

    @override
    void dispose() {
      _controller.stop();
      super.dispose();
    }

    void _handleTap() {
      setState(() {
        // valueAnimation.isAnimating is part of our build state
        if (_controller.isAnimating) {
          _controller.stop();
        } else {
          switch (_controller.status) {
            case AnimationStatus.dismissed:
            case AnimationStatus.forward:
              _controller.forward();
              break;
            case AnimationStatus.reverse:
            case AnimationStatus.completed:
              _controller.reverse();
              break;
          }
        }
      });
    }

    Widget _buildIndicators(BuildContext context, Widget child) {
      final List<Widget> indicators = <Widget>[

        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SizedBox(
              width: 60.0,
              height:60.0,
              child:
            new CircularProgressIndicator(),)
            // new SizedBox(
            //     width: 20.0,
            //     height: 20.0,
            //     child: new CircularProgressIndicator(value: _animation.value)
            // ),
          ],
        ),
      ];
      return new Column(
        children: indicators
          .map((Widget c) => new Container(child: c, margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0)))
          .toList(),
      );
    }

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
      backgroundColor: Colors.black,
        body: new Center(
          child: new SingleChildScrollView(
              child: new GestureDetector(
                onTap: _handleTap,
                behavior: HitTestBehavior.opaque,
                child: new Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                  child: new AnimatedBuilder(
                    animation: _animation,
                    builder: _buildIndicators
                  )
                )
              )

          )
        )
      );
    }


}
