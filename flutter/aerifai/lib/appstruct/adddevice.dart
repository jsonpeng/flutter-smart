/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:              2017/03/20
*@LastUpdate:        2017/04/26
*
*This file is the add progress for device and varifiled the add device type
*
*/
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'base.dart';
import 'device.dart';
import '../communication/newws.dart';


class AddProgeress extends StatefulWidget {
  @override
  _AddProgeressState createState() => new _AddProgeressState();
}

class _AddProgeressState extends State<AddProgeress> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

  ZwaveWebsocketComunication.websocket.basicSetting(wsdata: "ADD_NODE");
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
  new Timer.periodic(new Duration(seconds: 10),varifyAddDevice);

  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }


  Timer varifytimer;

  void varifyAddDevice(Timer varifytimer){
    if (ZwaveWebsocketComunication.addBackData!=null){
      print("had added device success");
    Navigator.push(context, new MaterialPageRoute(
    builder: (BuildContext context) => new VarifiedPage(nodeclass: ZwaveWebsocketComunication.addBackData)));
  varifytimer.cancel();
  }else{
    print("fail to recieve device data");
  }
  }

void backToHome(){
  Navigator.pop(context);
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
    List<Widget> indicators = <Widget>[
      /*new SizedBox(
        width: 200.0,
        child: new LinearProgressIndicator()
      ),
      */
     // new LinearProgressIndicator(),
      //new LinearProgressIndicator(),
      //new LinearProgressIndicator(value: _animation.value),

        new Stack(
            children: <Widget>[
                new Center(
                    child:new Padding(
                        padding: const EdgeInsets.all(210.0),
                child:new Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 85.0,

                ))),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top:90.0),
            child:
            new SizedBox(
              width: 360.0,
              height: 360.0,
              child:
              new GestureDetector(
                onTap: (){
            backToHome();
                },
                child:
                  new CircularProgressIndicator(),
                )

            )),


        ],
    )]),
    ];
    return new Column(
      children: indicators
        .map((Widget c) => new Container(child: c, margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0)))
        .toList(),
    );
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
      body:
      new CustomMultiChildLayout(
          delegate: new LandspaceLayout(),
          children: <Widget>[

            new LayoutId(
                id: LandspaceLayout.background,
                child: new Image.asset('Assets/device_0.png',
                    fit: BoxFit.contain)),
            new LayoutId(
                id: LandspaceLayout.centerElements,
      child:
      new Padding(
        padding: const EdgeInsets.all(68.0),
        child: new Center(
          child: new DefaultTextStyle(
            style: Theme.of(context).textTheme.title,
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
      )
  )])
    );
     break;
case Orientation.portrait:
print("display portrait screen");
return new Scaffold(
backgroundColor: Colors.black,
  body:
  new CustomMultiChildLayout(
      delegate: new PortraitLayout(),
      children: <Widget>[

        new LayoutId(
            id: PortraitLayout.background,
            child: new Image.asset('Assets/device_0.png',
                fit: BoxFit.contain)),
          new LayoutId(
            id: PortraitLayout.centerElements,
  child:
  new Padding(
    padding: const EdgeInsets.all(68.0),
    child: new Center(
      child: new DefaultTextStyle(
        style: Theme.of(context).textTheme.title,
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
  )
)])
);

  }
  }
}




class VarifiedPage extends StatefulWidget{
  VarifiedPage({
    Key key,
    this.nodeclass
  }) : super(key: key) {
       assert(nodeclass != null);
  }
final int nodeclass;
  @override
  VarifiedPageState createState()=>new VarifiedPageState();
}

class VarifiedPageState  extends State<VarifiedPage>{
  Timer redirectDeviceTimer;
  String deviceImage;
  String deviceType;
@override
void initState(){
    super.initState();
    varifiedDeviceImage(config.nodeclass);
    ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'GET_NODELIST');
    String  allNodeList=ZwaveWebsocketComunication.nodelist;
  Map jsonNodeList=JSON.decode(allNodeList);
  var nodeLength=jsonNodeList['data'];
  int nodelength=nodeLength.length;
new Timer(new Duration(seconds:3),(){
  Navigator.push(context, new MaterialPageRoute(
  builder: (BuildContext context) => new DevicePage(initvalue:nodelength-2)));
});
}



void varifiedDeviceImage(int nodeclass){
  switch (nodeclass){
    case 16:
    deviceImage= 'Assets/device_02.png';
    deviceType="Binara";
    break;
    case 17:
    deviceImage= 'Assets/device_03.png';
    deviceType="Light";
    break;
    case 33:
    deviceImage= 'Assets/device_01.png';
    deviceType="Sensor";
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
      body:new GestureDetector(
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context) => new DevicePage(initvalue: 1)));
        },
        child:
      new CustomMultiChildLayout(
          delegate: new LandspaceLayout(),
          children: <Widget>[

            new LayoutId(
                id: LandspaceLayout.background,
                child: new Image.asset('Assets/device_0.png',
                    fit: BoxFit.contain)),
            new LayoutId(
                id: LandspaceLayout.centerElements,
      child:
new Stack(
children: [
new Column(

children: [

new Padding(
padding: const EdgeInsets.only(top:40.0),
child: new Text('$deviceType',style: new TextStyle(
  fontFamily: 'Hepworth',
  color: Colors.white,
  fontSize: 50.0,
)),
),


new Padding(
    padding: const EdgeInsets.only(top: 100.0),
child: new Image.asset('$deviceImage',fit:BoxFit.contain,width:300.0,height: 300.0),
),

new Padding(
    padding: const EdgeInsets.only(top: 100.0),
child: new Image.asset('Assets/device_varified.png',fit:BoxFit.contain,width:80.0,height: 80.0 ),
),
]
),
]
),
  )])
)
    );
     break;
}
  }
}
