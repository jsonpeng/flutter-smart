import 'package:flutter/material.dart';
import 'base.dart';
import 'dev.dart';
import 'dart:math' as math;
import '../communication/newws.dart';

class AddProgeress extends StatefulWidget {
  AddProgeress({
    Key key,
    this.nodeid
  }) : super(key: key) {
       assert(nodeid != null);
  }
final int nodeid;
  @override
  _AddProgeressState createState() => new _AddProgeressState();
}

class _AddProgeressState extends State<AddProgeress> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    ZwaveWebsocketComunication ws=new ZwaveWebsocketComunication();
    ws.basicSetting("ADD_NODE");
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

void backToHome(){
//  Navigator.pop(context);
 Navigator.push(context, new MaterialPageRoute(
                      builder: (BuildContext context) => new DevPage()));
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
        new Stack(

            children: <Widget>[
                new Center(
                    child:new Padding(
                        padding: const EdgeInsets.all(45.0),
                child:new Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 45.0,

                ))),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
            new SizedBox(
              width: 150.0,
              height: 150.0,
              child:
              new GestureDetector(
                onTap: (){
            backToHome();
                },
                child:
                  new CircularProgressIndicator(),
                )

            ),


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
                child: new Image.asset('Assets/device.png',
                    fit: ImageFit.contain)),
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
            child: new Image.asset('Assets/device.png',
                fit: ImageFit.contain)),
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
