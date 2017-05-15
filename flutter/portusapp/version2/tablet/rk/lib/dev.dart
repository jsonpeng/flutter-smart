import 'package:flutter/material.dart';
import 'dart:math' as math;

enum TabsDemoStyle {
  iconsAndText,
  iconsOnly,
  textOnly
}

class _Page {
  _Page({  this.icon});
  final IconData icon;
}

final List<_Page> _allPages = <_Page>[

  new _Page(icon: Icons.home),


];


class _DeviceImage{
    const _DeviceImage({  this.imageAsset });
// final String title;
 final String imageAsset;
}


final List<_DeviceImage> _allDevicePages=<_DeviceImage>[
    new _DeviceImage(imageAsset: "a"),
];

class DevPage extends StatefulWidget {
//  static const String routeName = '/scrollable-tabs';

  @override
  DevPageState createState() => new DevPageState();
}
var  _devicetype="";
class DevPageState extends State<DevPage> with SingleTickerProviderStateMixin {
  //TabController _controller;
  TabsDemoStyle _demoStyle = TabsDemoStyle.iconsOnly;
bool _showDeviceType=true;
double device01font=86.0;
double device02font=86.0;
double device03font=86.0;
var device01color=Colors.white30;
var device02color=Colors.white30;
var device03color=Colors.white30;
void _device01(){
    setState((){
        print("01success");
        device01font=126.0;
        _devicetype="AC";
        device01color=Colors.white;
    });

}

void _device02(){
    setState((){
        print("02success");
        device02font=126.0;
        _devicetype="Lamp";
        device02color=Colors.white;
    });
}

void _device03(){
    setState((){
        print("03success");
        device03font=126.0;
        _devicetype="Binara";
        device03color=Colors.white;
    });
}

void _adddevice(){
        setState((){
Navigator.pushNamed(context, "/adddevice");
        });
}

void _removeDevice(){

  setState((){
    Navigator.pushNamed(context, "/remdevice");
  });

}
void _backToHome(){
  setState((){
    Navigator.pop(context);
  });

}

  @override
  void initState() {
    super.initState();
    //_controller = new TabController(vsync: this, length: _allPages.length);
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  void changeDemoStyle(TabsDemoStyle style) {
    setState(() {
      _demoStyle = style;
    });
  }

  @override
  Widget build(BuildContext context) {
      List<Widget> chips = <Widget>[


      ];
      if (_showDeviceType) {
        chips.add(

    new Column(
    children: <Widget>[
            new Padding(
           padding: const EdgeInsets.only(top: 40.0),
            child:new Text('$_devicetype',  style: new TextStyle(
                fontFamily: 'Hepworth',
              color: Colors.white,
                fontSize: 60.0,
                fontStyle: FontStyle.italic,
              ))  ),
              new Padding(
             padding: const EdgeInsets.only(top:0.0,bottom: 0.0,left:0.0),
              child:new Text('one',  style: new TextStyle(
                  fontFamily: 'Hepworth',
              color: Colors.white30,
                  fontSize: 30.0,
                  fontStyle: FontStyle.italic,
                ))



             ),
    ])


        );
      }

          Widget devicedetail =new Container(
              child:new Padding(
                  padding: const EdgeInsets.all(10.0),
              child: new Row(
                  children: <Widget>[
                      new GestureDetector(
                          onTap: (){
                              _device01();
                          },
                          onDoubleTap: (){
                            _backToHome();
                          },
                          onLongPress: (){
                            _removeDevice();
                          },

                      child:
                      new Padding(
                          padding: const EdgeInsets.all(30.0),
                      child:new Image.asset('Assets/device_01.png',color:device01color,
                          fit: ImageFit.contain,width: device01font,height: device01font))),


          new GestureDetector(
              onTap: (){
                  _device02();
              },
              onLongPress: (){
                _removeDevice();
              },
              onDoubleTap: (){
                _backToHome();
              },
              child:
                          new Padding(
                              padding: const EdgeInsets.all(30.0),
                          child:
                          new Image.asset('Assets/device_02.png',color:device02color,
                              fit: ImageFit.contain,width:device02font,height: device02font))),

                              new GestureDetector(
                                  onTap: (){
                                      _device03();
                                  },
                                  onDoubleTap: (){
                                    _backToHome();
                                  },
                                  onLongPress: (){
                                     _removeDevice();
                                  },
                                  child:
                              new Padding(
                                  padding: const EdgeInsets.all(30.0),
                              child:
                              new Image.asset('Assets/device_03.png',color:device03color,
                                  fit: ImageFit.contain,width:device03font,height: device03font))),


                                  new Padding(
                                      padding: const EdgeInsets.all(30.0),
                                  child:
                                  new GestureDetector(
                                      onTap: (){
                                          //_device();
                                          _adddevice();
                                      },

                                  child: new Icon(
                                      Icons.add_circle_outline,
                                      color: Colors.white,
                                      size: 95.0,
                                  ))),

          ]
                      )

              )

          //body:new Tab(icon: new Icon())
              );
              var orientation;
              orientation = MediaQuery.of(context).orientation;
             switch (orientation) {
               case Orientation.landscape:
                 print('display landscape screen');
    return new Scaffold(
        backgroundColor: Colors.black,

      body:new CustomMultiChildLayout(
          delegate: new LandspaceLayout(),
          children: <Widget>[

            new LayoutId(
                id: LandspaceLayout.background,
                child: new Image.asset('Assets/device.png',
                    fit: ImageFit.contain)),
            new LayoutId(
                id: LandspaceLayout.centerElements,
child:new Column(
    children: <Widget>[
        new Column(
          children: chips.map((Widget widget) {
            return new Container(



    child:
              new Padding(
        padding: const EdgeInsets.only(top: 0.0),
                  child: widget)
            );
          }).toList()
        ),

new Padding(
  padding: const EdgeInsets.all(120.0),
  child:
        new SizedBox(
            width: 500.0,
            height: 250.0,
            child:
            new Padding(
                padding: const EdgeInsets.only(top:0.0,bottom: 20.0),
                child:
            new Padding(
                padding: const EdgeInsets.all(0.0),
     child: new TabBar(
         //labelColor:Colors.black,
        //controller: _controller,
        isScrollable: true,
        tabs: _allPages.map((_Page page) {
          switch(_demoStyle) {
            case TabsDemoStyle.iconsAndText:
             // return new Tab(text: page.text, icon: new Icon(page.icon));
            case TabsDemoStyle.iconsOnly:
             // return new Tab(icon: new Icon(page.icon));
             return devicedetail;
            case TabsDemoStyle.textOnly:
            //  return new Tab(text: page.text);
          }
        }).toList(),
    )))
)),

])

)])

    );
break;
case Orientation.portrait:
print("display portrait screen");
return new Scaffold(
    backgroundColor: Colors.black,

  body:new CustomMultiChildLayout(
      delegate: new PortraitLayout(),
      children: <Widget>[

        new LayoutId(
            id: PortraitLayout.background,
            child: new Image.asset('Assets/device.png',
                fit: ImageFit.contain)),
        new LayoutId(
            id: PortraitLayout.centerElements,
child:new Column(
children: <Widget>[
    new Column(
      children: chips.map((Widget widget) {
        return new Container(



child:
          new Padding(
    padding: const EdgeInsets.only(top: 0.0),
              child: widget)
        );
      }).toList()
    ),

    new Padding(
      padding: const EdgeInsets.all(120.0),
      child:
    new SizedBox(
        width: 500.0,
        height: 250.0,
        child:
        new Padding(
            padding: const EdgeInsets.only(top:0.0,bottom: 20.0),
            child:
        new Padding(
            padding: const EdgeInsets.all(0.0),
 child: new TabBar(
     //labelColor:Colors.black,
    //controller: _controller,
    isScrollable: true,
    tabs: _allPages.map((_Page page) {
      switch(_demoStyle) {
        case TabsDemoStyle.iconsAndText:
         // return new Tab(text: page.text, icon: new Icon(page.icon));
        case TabsDemoStyle.iconsOnly:
         // return new Tab(icon: new Icon(page.icon));
         return devicedetail;
        case TabsDemoStyle.textOnly:
        //  return new Tab(text: page.text);
      }
    }).toList(),
)))
)),

])

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
