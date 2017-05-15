import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'communication/websocket.dart';

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
    WebsocketService ws=new WebsocketService();
    ws.set("addnode");
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
                        padding: const EdgeInsets.all(155.0),
                child:new Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 85.0,

                ))),
      new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(top:50.0),
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
