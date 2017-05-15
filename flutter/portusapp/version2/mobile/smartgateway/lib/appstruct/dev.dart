import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'base.dart';
import 'menu.dart';
import 'adddevice.dart';
import 'remdevice.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import '../communication/websocket.dart';
import '../communication/newws.dart';

ZwaveWebsocketComunication wsclass=new ZwaveWebsocketComunication();
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

Future<File> _getLocalFile() async {
  // get the path to the document directory.
  String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
  print('$dir/nodelist.json');
  return new File('$dir/nodelist.json');
}

Future<String> _readNodeListFile() async {
  try {
    File file = await _getLocalFile();
    // read the variable as a string from the file.
    String contents = await file.readAsString();
    return contents;
  } on FileSystemException {
    return "";
  }
}

class  BasicDevPage extends StatefulWidget{

  @override
  BasicDevPageState createState() => new BasicDevPageState();
}

class BasicDevPageState extends State<BasicDevPage>{

  void _backToHome(){
    setState((){
      //Navigator.pop(context);
      Navigator.push(context, new MaterialPageRoute(
                                builder: (BuildContext context) => new TimePickerDialog(initvalue: 6)));
    });

  }

  @override
  Widget build(BuildContext context) {
    var orientation;
    orientation = MediaQuery.of(context).orientation;
   switch (orientation) {
     case Orientation.landscape:
       print('device page:display landscape screen');
  return new Scaffold(
  backgroundColor: Colors.black,

  body:new GestureDetector(
  onDoubleTap: (){
  _backToHome();
  },
  child:
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
    new Center(
      child:
    new GestureDetector(
        onTap: (){
          Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => new AddProgeress(nodeid:1)));
        },
    child: new Icon(
        Icons.add_circle_outline,
        color: Colors.white,
        size: 105.0,
    ))
    ),
  )])
  )
  );
  break;
  case Orientation.portrait:
  print("device page:display portrait screen");
  return new Scaffold(
  backgroundColor: Colors.black,

  body:new GestureDetector(
  onDoubleTap: (){
  _backToHome();
  },
  child:
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

  new Column(
  children: <Widget>[




  ])

  )])
  )
  );
  break;
  }

  }
}


class DevPage extends StatefulWidget {
//  static const String routeName = '/scrollable-tabs';

  @override
  DevPageState createState() => new DevPageState();
}
var  _devicetype="";
class DevPageState extends State<DevPage> with SingleTickerProviderStateMixin {
  //TabController _controller;

bool _showDeviceImage=true;
bool _showLight=false;
bool _showBinaraSwitch=false;
bool switchValue = false;
bool _showDeviceType=true;
double device01font=56.0;
double device02font=56.0;
double device03font=56.0;
double _discreteValue=20.0;
var device01color=Colors.white30;
var device02color=Colors.white30;
var device03color=Colors.white30;
void _device01(){
    setState((){
        print("01success");
        device01font=96.0;
        _devicetype="AC";
        device01color=Colors.white;
    });

}

void _device02(){
    setState((){
        print("02success");
        device02font=96.0;
        _devicetype="Binara";
        device02color=Colors.white;

    });
}

void _device03(){
    setState((){
        print("03success");
        device03font=96.0;
        _devicetype="Light";
        device03color=Colors.white;
    });
}

void _adddevice(int nodeid){
        setState((){
           Navigator.push(context, new MaterialPageRoute(
       builder: (BuildContext context) => new AddProgeress(nodeid:nodeid)));
        });
}

void _removeDevice(int nodeid){

  setState((){
  //  Navigator.pushNamed(context, "/remdevice");
  Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) => new RemDevice(nodeid:nodeid)));
  });

}
void _backToHome(){
  setState((){
    //Navigator.pop(context);
    Navigator.push(context, new MaterialPageRoute(
                              builder: (BuildContext context) => new TimePickerDialog(initvalue: 6)));
  });

}
bool switchstate;
getSwitchState() {
  switch(ZwaveWebsocketComunication.swichstate){
case 255:
switchstate=true;
break;
case 0:
switchstate=false;
break;
default :
switchstate =false;
break;
  }
  print("switchstate:"+'$switchstate');
  return  switchstate;
}

String allNodeList;
List<Widget> device_binaryswitch=<Widget>[];
List<Widget> multiswitch=<Widget>[];

updateDeviceView() async{
  _readNodeListFile().then((String value) {
  allNodeList=value;
  Map jsonNodeList=JSON.decode(allNodeList);
  var nodeLength=jsonNodeList['data'];
   int nodelength=nodeLength.length;
  //print(nodelength);
  for(int i=0;i<nodeLength.length;i++){
 if(jsonNodeList['data'][i]['GenericDeviceClass']==16){
  //print(jsonNodeList['data'][i]['NodeId']);
  //map.add(jsonNodeList['data'][i]['NodeId']);
    device_binaryswitch.add(
        new GestureDetector(
            onTap: (){
                _device02();
            },
            onLongPress: (){
              _removeDevice(jsonNodeList['data'][i]['NodeId']);
            },
            onDoubleTap: (){
              setState((){
                  wsclass.binaraSwitchSetting(jsonNodeList['data'][i]['NodeId'], "GET_SWITCHSTATE");
                  print("02success");
                    getSwitchState();
                  device02font=96.0;
                  _devicetype="Binara";
                  device02color=Colors.white;
                  _showBinaraSwitch=true;
                  _showDeviceImage=false;
              });
            },
            child:new Padding(
              padding: const EdgeInsets.all(0.0),
              child:new Image.asset('Assets/device_02.png',color:device02color,
        fit: ImageFit.contain,width:device02font,height: device02font))),
    );
  }else if(jsonNodeList['data'][i]['GenericDeviceClass']==33){
  multiswitch.add(
    new GestureDetector(
        onTap:(){
            _device03();
        },
        onDoubleTap: (){
          setState((){
              print("03success");
              device03font=96.0;
              _devicetype="Light";
              device03color=Colors.white;
              _showDeviceImage=false;
              _showLight=true;
          });
        },
        onLongPress: (){
           _removeDevice(69);
        },
        child:
    new Padding(
        padding: const EdgeInsets.all(0.0),
    child:
    new Image.asset('Assets/device_03.png',color:device03color,
        fit: ImageFit.contain,width:device03font,height: device03font))),
      );
    }
  }
      });
}

  @override
  void initState() {
    super.initState();
    updateDeviceView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> binaraswitch=<Widget>[];
    List<Widget> chips = <Widget>[];
    List<Widget> deviceImage=<Widget>[];
    List<Widget> lightControl=<Widget>[];

    Widget devicedetail =
              new Padding(
        padding: const EdgeInsets.only(top: 30.0),
                  child:
new Row(
  children: [
              new Row(
                      children: device_binaryswitch.map((Widget widget) {
                        return new Row(
                          children: [
                            new Padding(
                                padding: const EdgeInsets.all(30.0),
                            child:
                widget
              )
              ]
                        );
                      }).toList(),

),

          new Row(
                  children: multiswitch.map((Widget widget) {
                  return new Row(
            children:[
              new Padding(
                  padding: const EdgeInsets.all(30.0),
              child:
              widget
            )
                  ]
                  );
                  }).toList(),

),
new Center(
  child:
new Padding(
    padding: const EdgeInsets.all(30.0),
child:
new GestureDetector(
    onTap: (){
        _adddevice(1);
    },

child: new Icon(
    Icons.add_circle_outline,
    color: Colors.white,
    size: 105.0,

))
)),
    ]
              ));

      if (_showDeviceType) {
        chips.add(
    new Column(
    children: <Widget>[
            new Padding(
           padding: const EdgeInsets.only(top: 40.0),
            child:new Text('$_devicetype',  style: new TextStyle(
                fontFamily: 'Hepworth',
              color: Colors.white,
                fontSize: 30.0,

              ))  ),
              new Padding(
             padding: const EdgeInsets.only(top:0.0,bottom: 0.0,left:0.0),
              child:new Text('one',  style: new TextStyle(
                  fontFamily: 'Hepworth',
              color: Colors.white30,
                  fontSize: 20.0,
                ))
             ),
    ])


        );
      }
      if (_showBinaraSwitch) {

        binaraswitch.add(
new BinaraSwitch(nodeid:20,swichstate: switchstate),
        );
      }


      if(_showLight){
        lightControl.add(
new LightSwitch(nodeid: 1,lightstate: 10.0),
        );

      }

      if (_showDeviceImage) {
        deviceImage.add(
          new SizedBox(
              width: 300.0,
              height: 250.0,
              child:
              new Padding(
                  padding: const EdgeInsets.only(top:0.0,bottom: 20.0),
                  child:
              new Padding(
                  padding: const EdgeInsets.all(0.0),
          child: new TabBar(
          isScrollable: true,
          tabs: _allPages.map((_Page page) {
               return devicedetail;
          }).toList(),
          )))
        ));

      }



              var orientation;
              orientation = MediaQuery.of(context).orientation;
             switch (orientation) {
               case Orientation.landscape:
                 print('device page:display landscape screen');
    return new Scaffold(
        backgroundColor: Colors.black,

      body:new GestureDetector(
        onDoubleTap: (){
      _backToHome();
        },
        child:
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

new Column(
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

        new Column(
          children: deviceImage.map((Widget widget) {
            return new Container(
    child:
              new Padding(
        padding: const EdgeInsets.only(top: 0.0),
                  child: widget)
            );
          }).toList()
        ),


        new Column(
          children: binaraswitch.map((Widget widget) {
            return new Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
                  child: widget);
          }).toList()
        ),

        new Column(
          children: lightControl.map((Widget widget) {
            return  new Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
                  child: widget);
          }).toList()
        ),
])

)])
  )
    );
break;
case Orientation.portrait:
print("device page:display portrait screen");
return new Scaffold(
    backgroundColor: Colors.black,

  body:new GestureDetector(
    onDoubleTap: (){
  _backToHome();
    },
    child:
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

new Column(
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

    new Column(
      children: deviceImage.map((Widget widget) {
        return new Container(
child:
          new Padding(
    padding: const EdgeInsets.only(top: 0.0),
              child: widget)
        );
      }).toList()
    ),


    new Column(
      children: binaraswitch.map((Widget widget) {
        return new Padding(
    padding: const EdgeInsets.only(bottom: 0.0),
              child: widget);
      }).toList()
    ),

    new Column(
      children: lightControl.map((Widget widget) {
        return new Padding(
    padding: const EdgeInsets.only(bottom: 0.0),
              child: widget);
      }).toList()
    ),
])
)])
)
);
break;
}
  }
}

class BinaraSwitch extends StatefulWidget{
  BinaraSwitch({
    Key key,
    this.nodeid,
    this.swichstate
  }) : super(key: key) {
       assert(swichstate != null);
  }
  final int nodeid;
   bool swichstate;

   @override
   BinaraSwitchState createState() => new BinaraSwitchState();
 }


class BinaraSwitchState extends State<BinaraSwitch>{

void initState(){
   super.initState();

}
  @override
   Widget build(BuildContext context) {
  return new Column(
      children: [
  new Padding(
  padding: const EdgeInsets.all(60.0),
  child: new CupertinoSwitch(
      value: config.swichstate,
      onChanged: (bool value) {
        setState(() {
          config.swichstate = value;
          if (config.swichstate==true){
            print("switch on");
            wsclass.binaraSwitchSetting(config.nodeid, "SWITCH_ON");
          }else if(config.swichstate==false){
            print("switch off");
            wsclass.binaraSwitchSetting(config.nodeid, "SWITCH_OFF");
          }
        });
      }
  ),
  ),

  new GestureDetector(
  onTap: (){
    Navigator.push(context, new MaterialPageRoute(
        builder: (BuildContext context) => new DevPage()));
  },
  child:
  new Padding(
  padding: const EdgeInsets.only(top:0.0),
  child:
  new Icon(
    Icons.arrow_back,
    color: Colors.white,
    size:30.0,
  ),
  )),

  ]);
  }
}



class LightSwitch extends StatefulWidget{
  LightSwitch({
    Key key,
    this.nodeid,
    this.lightstate
  }) : super(key: key) {
       assert(nodeid != null);
  }
  final int nodeid;
   double lightstate;

   @override
   LightSwitchState createState() => new LightSwitchState();


 }


class LightSwitchState extends State<LightSwitch>{
@override
void initState(){
}

  @override
   Widget build(BuildContext context) {
return           new Column(
            children: [
        new Padding(
        padding: const EdgeInsets.all(60.0),
        child: new Slider(
            activeColor:Colors.yellow[400],
            value: config.lightstate,
            min: 0.0,
            max: 100.0,
            divisions: 100,
            label: '${config.lightstate.round()}',
            thumbOpenAtMin: true,
            onChanged: (double value) {
              setState(() {
                 config.lightstate = value;
                //print(config.lightstate);
                WebsocketService ws=new WebsocketService();
                //int wsdata=int.parse('$config.lightstate');
                ws.lightChangeLevel(config.nodeid,config.lightstate);

              });
            }
        )
        ),

        new GestureDetector(
        onTap: (){
        Navigator.of(context).pushNamed('/device');

        },
        child:
        new Padding(
        padding: const EdgeInsets.only(top:0.0),
        child:
        new Icon(
          Icons.arrow_back,
          color: Colors.white,
          size:30.0,
        ),
        )),
]);
  }
}
