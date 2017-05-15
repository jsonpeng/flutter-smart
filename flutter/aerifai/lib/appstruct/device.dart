/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:        2017/03/20
*@LastUpdate:  2017/05/11
*
*This file is the app mainly device page for control the all Zwave Device
*
*/

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'menu.dart';
import 'base.dart';
import '../communication/newws.dart';
import '../communication/jogcontrol.dart';
import 'adddevice.dart';
import 'remdevice.dart';
import 'devicelayout.dart';

class _DeviceImage {
  _DeviceImage({
    this.devname,this.devtype,this.devid,
    this.devimg,this.devcolor,this.devsize,
    this.devstate,this.ligthtstate,this.varifiedLight,this.varifiedBinara,
    this.startJogLightControl,this.startJogBinaraControl
  });
  String devname;
  int devtype;
  int devid;
  String devimg;
  Color  devcolor;
  double devsize;
  int devstate;
  int ligthtstate;
  int currentNodeid;
  bool varifiedLight;
  bool varifiedBinara;
  bool startJogLightControl;
  bool startJogBinaraControl;
}

 List<_DeviceImage> allDevicePage = <_DeviceImage>[];
 List<int> jogControlDevice=[];
 /*
 * add device type like this
  new _DeviceImage(devname:'switch',devtype:16,devid:1,devimg: 'Assets/device_02.png',devcolor: Colors.white30,devsize: 66.0,devstate: 255),
   new _DeviceImage(devname:'sensor',devtype:33,devid:2,devimg: 'Assets/device_01.png',devcolor: Colors.white30,devsize: 66.0,devstate: 0),
   new _DeviceImage(devname:'lights',devtype:17,devid:3,devimg: 'Assets/device_03.png',devcolor: Colors.white30,devsize: 66.0,devstate: 0),
   new _DeviceImage(devname:'added',devtype:1,devid:4,devimg: 'Assets/device_07.png',devcolor: Colors.white,devsize: 66.0,devstate: 0),
 */

class DevicePage extends StatefulWidget {
  DevicePage({
    Key key,
    this.initvalue
  }) : super(key: key) {
       assert(initvalue != null);
  }
   int initvalue;
  @override
  DevicePageState createState() => new DevicePageState();
}

bool showTemperatureSensor=false;
Timer devicetimer;
class DevicePageState extends State<DevicePage> with TickerProviderStateMixin {
  int currentid;
  int chooseid;
  TabController _controller;
  String allNodeList;
  int binaraNodeId;
  int lightNodeId;
  int sensorNodeId;
  bool startJogLightControl=false;
  bool startJogBinaraControl=false;
  bool varifiedBinaraSwichState;
  bool varifiedLightSwichState;
  @override
  void initState() {
    super.initState();
    updateDeviceView();
    JogControl.jogItem=config.initvalue;
    print("jogItem:${JogControl.jogItem}");
    JogControl.jogNum=4;
    _controller = new TabController(initialIndex:config.initvalue,vsync:this,length: allDevicePage.length);
  //test for jog control light
  /*
  new Timer(new Duration(seconds: 3), (){
    setState((){
startJogLightControl=true;
    });
    });
    */
      //_DeviceImage  deviceimg;
    //print("devicestate:${deviceimg.devstate}");
    //devicetimer=new Timer.periodic(new Duration(milliseconds: 500), deviceJog);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  updateDeviceView() async{
    allDevicePage.clear();
    allNodeList=ZwaveWebsocketComunication.nodelist;
    Map jsonNodeList=JSON.decode(allNodeList);
    var nodeLength=jsonNodeList['data'];
    //int nodelength=nodeLength.length;
    //print(nodelength);
    for(int i=0;i<nodeLength.length;i++){
    if(jsonNodeList['data'][i]['GenericDeviceClass']==16){
    ZwaveWebsocketComunication.websocket.basicSetting(nodeid:jsonNodeList['data'][i]['NodeId'],wsdata: "GET_SWITCHSTATE");
    binaraNodeId=jsonNodeList['data'][i]['NodeId'];
    allDevicePage.add(
        new _DeviceImage(devname:'switch',devtype:16,devid:binaraNodeId,devimg: 'Assets/device_02.png',devcolor: Colors.white30,devsize: 66.0,devstate: ZwaveWebsocketComunication.swichstate,varifiedLight: false,varifiedBinara:true,startJogLightControl:false,startJogBinaraControl:true),
    );
    jogControlDevice.add(16);
    }else if(jsonNodeList['data'][i]['GenericDeviceClass']==17){
      lightNodeId=jsonNodeList['data'][i]['NodeId'];
      allDevicePage.add(
      new _DeviceImage(devname:'lights',devtype:17,devid:lightNodeId,devimg: 'Assets/device_03.png',devcolor: Colors.white30,devsize: 66.0,devstate: 0,varifiedLight: true,varifiedBinara:false,startJogLightControl:true,startJogBinaraControl: false),
);
ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'GET_LIGHTSTATE',nodeid:jsonNodeList['data'][i]['NodeId']);
  jogControlDevice.add(17);
      }else if(jsonNodeList['data'][i]['GenericDeviceClass']==33){
        sensorNodeId=jsonNodeList['data'][i]['NodeId'];
        ZwaveWebsocketComunication.websocket.basicSetting(nodeid:jsonNodeList['data'][i]['NodeId'],wsdata: 'GET_TEMPERATURE');
allDevicePage.add(
      new _DeviceImage(devname:'sensor',devtype:33,devid:sensorNodeId,devimg: 'Assets/device_01.png',devcolor: Colors.white30,devsize: 66.0,devstate: 0,varifiedLight: false,varifiedBinara:false,startJogLightControl:false,startJogBinaraControl: false),
);
  jogControlDevice.add(33);
      }

    }
    allDevicePage.add(
        new _DeviceImage(devname:'added',devtype:1,devid:4000,devimg: 'Assets/device_07.png',devcolor: Colors.white30,devsize: 66.0,devstate: 0,varifiedLight: false,varifiedBinara:false,startJogLightControl:false,startJogBinaraControl: false),
    );
      jogControlDevice.add(1);
    allDevicePage.add(
        new _DeviceImage(devname:'delete',devtype:2,devid:4000,devimg: 'Assets/device-delete1.png',devcolor: Colors.white30,devsize: 66.0,devstate: 0,varifiedLight: false,varifiedBinara:false,startJogLightControl:false,startJogBinaraControl: false),
    );
      jogControlDevice.add(2);
  }

jogControlDeviceFunction(int jognum){
  setState((){
  if(jognum !=16 && jognum !=17 && jognum !=33){
    //binaraSwichTimer?.cancel();
    startJogLightControl=false;
    startJogBinaraControl=false;
    print("don't need jogcontrol");
  }else if(jognum==16){
print("start binaraswich control");
startJogLightControl=false;
startJogBinaraControl=true;
varifiedBinaraSwichState=true;
//binaraSwichTimer=new Timer.periodic(new Duration(milliseconds: 250), binaraSwichControl);
  }else if(jognum==17){
//  binaraSwichTimer?.cancel();
print("start mutilevelswitch control");
startJogLightControl=true;
startJogBinaraControl=false;
varifiedLightSwichState=true;
  }else if(jognum==33){
print("start mutisensor control");

  }
});
}
Timer binaraSwichTimer;
binaraSwichControl(Timer binaraSwichTimer,{int nodeid}){
  setState((){
  ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SYSTEM_GET_JOG');
     int temp;
     int jogPos = ZwaveWebsocketComunication.jogPos;
     int jogDirx= ZwaveWebsocketComunication.jogDir;
    //first get data
    if((state == 1) && (jogPos == newJogPos)){
      if (flag >=4){
      newJogPos = -1;
      state =0;
      flag = 0;
      oldJogPos=jogPos;
      oldJogDirx=jogDirx;
      return;
    }else{
      flag++;
      return;
    }
  }else{
    flag=0;
  }
    //set new pos and direct
    newJogPos = jogPos;
    newJogDirx= jogDirx;
    //compare direct
    if( newJogDirx != oldJogDirx){
      oldJogPos=jogPos;
      oldJogDirx = jogDirx;
      flag=0;
      return;
    }

    if(oldJogDirx==0){
          if(newJogPos-oldJogPos>JogControl.jogNum){
              oldJogPos=newJogPos;
              oldJogDirx=newJogDirx;
              // JogControl.jogItem--;
  ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'SET_SWITCH_ON',nodeid:binaraNodeId);
  startJogBinaraControl=true;
              state = 1;

        }else if(newJogPos<oldJogPos){
             temp=newJogPos;
             if(newJogPos+24-oldJogPos>JogControl.jogNum){
                // JogControl.jogItem--;
  ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'SET_SWITCH_ON',nodeid:binaraNodeId);
  startJogBinaraControl=true;
                  oldJogPos=temp;
                 oldJogDirx=newJogDirx;
                 state = 1;
         }
       }
    }
    else if(oldJogDirx==1){
        if(newJogPos-oldJogPos<= -JogControl.jogNum){
            oldJogPos=newJogPos;
            oldJogDirx = newJogDirx;
            // JogControl.jogItem++;
  ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'SET_SWITCH_OFF',nodeid:binaraNodeId);
  startJogBinaraControl=false;
           state = 1;
        }else if(newJogPos>oldJogPos){
          temp=newJogPos;
          if(newJogPos-24-oldJogPos<= -JogControl.jogNum){
          // JogControl.jogItem++;
  ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'SET_SWITCH_OFF',nodeid:binaraNodeId);
    startJogBinaraControl=false;
          oldJogPos=temp;
          oldJogDirx = newJogPos;
          state =1;
           }
         }
    }
  });
}

  deviceJog(Timer devicetimer) {
      jogControlDeviceFunction(jogControlDevice[JogControl.jogItem]);
      }

  _handleIndexChanged(int index){
  setState((){
    JogControl.jogItem = index;
      //devicetimer?.cancel();
      Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => new DevicePage(initvalue: JogControl.jogItem)));
  });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> deviceImage=<Widget>[];
    List<Widget> devicetype=<Widget>[];
    List<Widget> temperatureSensor=<Widget>[];

if (showTemperatureSensor){
  temperatureSensor.add(
    new TemSensor(),
  );
}

devicetype.add(
  new SizedBox(
    width: 180.0,
    child:
  new TabBar(
    unselectedLabelColor:Colors.orange[500],
    indicatorColor: Colors.black87,
    controller: _controller,
    isScrollable: true,
    tabs: allDevicePage.map((_DeviceImage page) {
      return new Container(
        key: new ObjectKey(page.devname),
        padding: const EdgeInsets.all(12.0),
        child:new Column(
          children: [
        new Padding(
            padding: const EdgeInsets.only(top:10.0),
          child:new Text('${page.devname}',  style: new TextStyle(
              fontFamily: 'Hepworth',
            color: Colors.white,
              fontSize: 60.0,
            )
          )
        ),
            new Padding(
           padding: const EdgeInsets.only(top:0.0,bottom: 0.0,left:0.0),
            child:new Text('one',  style: new TextStyle(
                fontFamily: 'Hepworth',
            color: Colors.white30,
                fontSize: 30.0,
              )
            )
           ),
         ]
       )
     );
}).toList(),
))
);


return new Scaffold(
backgroundColor: Colors.black,

body:new GestureDetector(
onDoubleTap: (){
// Navigator.pop(context);
//devicetimer?.cancel();
startJogLightControl=false;
startJogBinaraControl=false;
Navigator.push(context, new MaterialPageRoute(
      builder: (BuildContext context) => new MenuPage(initvalue: 6)));
},
child:
new CustomMultiChildLayout(
  delegate: new LandspaceLayout(),
  children: <Widget>[
    new LayoutId(
        id: LandspaceLayout.background,
        child:
        // new TabBarView(
        //   controller: _controller,
        //   children: allDevicePage.map((_DeviceImage page) {
        //     return
             new DeviceLayout(
          initialIndex: 51,
          startLightControl: startJogLightControl,
          lightid: lightNodeId,
          lightstate:ZwaveWebsocketComunication.ligntstate,
          binaraSwitchShow: startJogBinaraControl,
          binaraid:binaraNodeId,
          binaraSwitchstate:ZwaveWebsocketComunication.swichstate,
          selectVarifiedBinaraSwitchState:varifiedBinaraSwichState,
          selectVarifiedLightSwitchState:varifiedLightSwichState
      //   );
      // }).toList()
    ),

        /*new TabBarView(
            controller: _controller,
            children: allDevicePage.map((_DeviceImage page) {
        return new Image.asset('Assets/device_${page.devstate}.png',
          fit: BoxFit.contain);
        }).toList(),
      )
      */
    ),

    new LayoutId(
        id: LandspaceLayout.centerElements,
child:
new Stack(

  children:[
    new TabBarView(
      controller: _controller,
      children: allDevicePage.map((_DeviceImage page) {
        return new GestureDetector(
              onTap:(){
          setState((){
            currentid=page.devid;
            chooseid=page.devid;
            print("currentid:$currentid");
            print("chooseid:$chooseid");
            //By touching the detection current state, if the current state of 0 represents the switch is closed, so click on the open action
            switch(page.devstate){
          case 0:
          if(page.devtype==16){
        jogControlDeviceFunction(16);
  print('switch on');
  //ZwaveWebsocketComunication.websocket.basicSetting(nodeid: page.devid,wsdata:'SET_SWITCH_ON');
}else if(page.devtype==17){
    //devicetimer?.cancel();
    jogControlDeviceFunction(17);
  //  Navigator.push(context, new MaterialPageRoute(  builder: (BuildContext context) => new LightSwitch(nodeid: page.devid,lightstate: 98.0))
  //);

      }else if(page.devtype==33){
print('enter sensor');
jogControlDeviceFunction(33);
//showTemperatureSensor=true;
Navigator.push(context, new MaterialPageRoute(  builder: (BuildContext context) => new TemSensor()));
        }else if(page.devtype==1){
          jogControlDeviceFunction(1);
          //devicetimer?.cancel();
        Navigator.push(context, new MaterialPageRoute(  builder: (BuildContext context) => new AddProgeress()));
      }else if(page.devtype==2){
        jogControlDeviceFunction(2);
          //devicetimer?.cancel();
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) =>new RemDevice(nodeclass: page.devtype)));
        }else{
          print('don not know');
        }
        page.devstate=255;
          break;
          case 255:
          if(page.devtype==16){
            jogControlDeviceFunction(16);
  print('switch off');
  //ZwaveWebsocketComunication.websocket.basicSetting(nodeid: page.devid,wsdata:'SET_SWITCH_OFF');
        }else if(page.devtype==17){
            jogControlDeviceFunction(17);
        //  jogControlDeviceFunction(jogControlDevice[JogControl.jogItem]);
          //  devicetimer?.cancel();
          //  Navigator.push(context, new MaterialPageRoute(  builder: (BuildContext context) => new LightSwitch(nodeid: page.devid,lightstate: 98.0)));

              }else if(page.devtype==33){
                jogControlDeviceFunction(33);
print('enter sensor');
showTemperatureSensor=false;
        }else if(page.devtype==1){
            jogControlDeviceFunction(1);
          //  devicetimer?.cancel();
        Navigator.push(context, new MaterialPageRoute(  builder: (BuildContext context) => new AddProgeress()));
        }else if(page.devtype==2){
            jogControlDeviceFunction(2);
            //devicetimer?.cancel();
        Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) =>new RemDevice(nodeclass: page.devtype)));
          }else{
          print('don not know');
        }
          page.devstate=0;
          break;
            }
          });
              },
              onLongPress: (){
                  //devicetimer?.cancel();
                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context) =>new RemDevice(nodeclass: page.devtype)));
              },
              child:
        new Container(
           key: new ObjectKey(page.devimg),
           padding: const EdgeInsets.all(220.0),
           child:
     new Stack(
       children: [
         new Container(
           width: 20.0,
           height: 20.0,
           child:
           new Image.asset('${page.devimg}',color:Colors.white,
      width:66.0,height: 66.0)),
      new Padding(
        padding: const EdgeInsets.only(top:60.0,left:80.0),
        child:
      new Align(
                 alignment: new FractionalOffset(0.0,1.8),
                 child: new Row(
      children: [
        new Padding(
          padding: const EdgeInsets.all(10.0),
          child:
            new Image.asset('Assets/device_04.png',
          width: 10.0)
        ),

        new Padding(
          padding: const EdgeInsets.all(10.0),
          child:  new Image.asset('Assets/device_switchstate_${page.devstate}.png',
          width:30.0)
        ),

          new Padding(
            padding: const EdgeInsets.all(10.0),
            child:new Image.asset('Assets/device_04.png',
          width: 10.0)),

        ],
      )
    )
      )

    ]
    ),
  ));

      }).toList()
    ),

    new Column(
      children: temperatureSensor.map((Widget widget) {
        return new Container(
    child:
    new Padding(
      padding: const EdgeInsets.only(top:0.0),
     child:widget
     )
        );
      }).toList()
    ),

new Padding(
  padding: const EdgeInsets.only(top: 30.0),
  child:
new Column(
    children: <Widget>[
      new Column(
        children: devicetype.map((Widget widget) {
          return new Container(
            child:new Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: widget
            )
          );
        }).toList()
      ),
new Column(
  children: deviceImage.map((Widget widget) {
    return new Container(
child:
new Padding(
  padding: const EdgeInsets.only(top:0.0),
 child:widget
 )
    );
  }).toList()
),

])),
]),
)])
)
);


}
}




class TemSensor extends StatefulWidget{
  @override
TemSensorState createState() => new TemSensorState();
}

class TemSensorState extends State<TemSensor>{
  Widget text1=

  new Center(
      child:
new Padding(
padding: const EdgeInsets.only(left: 0.0,top: 50.0),
child:
      new Text('${ZwaveWebsocketComunication.temperature.round()}',style: new TextStyle(
        fontFamily: 'Hepworth',
          color: Colors.white,
          decorationColor:Colors.black87,
          fontSize: 420.0
        )))
  );

Widget text3=new Center(
child: new Padding(
padding: const EdgeInsets.only(left:520.0,bottom: 80.0,top: 0.0),
child: new Text('°',style: new TextStyle(
fontFamily: 'Hepworth',
color: Colors.white,
decorationColor:Colors.black87,
fontSize: 165.0,
)),
),

);



@override
 Widget build(BuildContext context) {
   return  new  GestureDetector(
onTap: (){
  Navigator.pop(context);
  },
     child:new Stack(
                   children: [
                           text1,
                           text3,
                         ]
                 )
               );
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
//startLight();
}

Timer timer;
void startLight(){
  for(double i=0.0;i<=99.0;i++){
    print(i);
     start(i);
}
}

void start(double value){
  //devws.basicSetting(nodeid:config.nodeid,value);
}


  @override
   Widget build(BuildContext context) {
return    new Scaffold(
backgroundColor: Colors.black,
  body:      new Center(
    child: new Column(
            children: [
        new Padding(
        padding: const EdgeInsets.all(140.0),
        child:
        new Transform(
          transform: new Matrix4.identity()
                                      ..scale(2.5),
          child:
          new Padding(
            padding: const EdgeInsets.only(top:100.0,bottom: 0.0,right: 185.0),
              child:
        new Slider(
            activeColor:Colors.yellow[400],
            value:config.lightstate,
            min: 0.0,
            max: 99.0,
            divisions: 5,
            //label: '${config.lightstate.round()}',
            onChanged: (double value) {
            //  print("label:${config.lightstate.round()}'");
              setState(() {
                 config.lightstate= value;
                //print(config.lightstate);
                //int devwsdata=int.parse('$config.lightstate');
              //  ZwaveWebsocketComunication.websocket.basicSetting(wsdata:"SET_LIGHTSWITCHLEVEL",nodeid:config.nodeid,lightlevel:config.lightstate);

              });
            }
        )))
        ),

        new GestureDetector(
        onTap: (){
      //  Navigator.of(context).pushNamed('/device');
  Navigator.pop(context);
        },
        child:
        new Padding(
        padding: const EdgeInsets.only(top:100.0),
        child:
        new Icon(
          Icons.arrow_back,
          color: Colors.white,
          size:30.0,
        ),
        )),
])));
  }
}
