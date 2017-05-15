/*
 * this file is to protected for app ui to redirect api about websocket setting
 *
 */
library newws;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

WebSocket ws;

class ZwaveWebsocketComunication {
  static var swichstate;
  static var addBackData;
    String server = "ws://192.168.10.99:8360/ws?uid=1488963192";
/*
 * basicSet for node ,is all const paremeter
 *
 */
  void basicSetting(String wsdata) {
    //Open the websocket and attach the callbacks
    WebSocket.connect(server).then((WebSocket socket) {
      ws = socket;

      ws.listen(onMessage, onDone: connectionClosed);
      switch (wsdata) {
        case "GET_NODELIST":
          DateTime now = new DateTime.now();
          print('$now  [GET_NODELIST]  client send :{"action": "request", "device": "gateway","seq":1, "cmd":"COMMAND_NODE_LIST_GET"}');
          ws.add('{"action": "request", "device": "gateway","seq":1, "cmd":"COMMAND_NODE_LIST_GET"}');
          break;
        case "ADD_NODE":
          DateTime now = new DateTime.now();
          print(
              '$now  [ADD_NODE]  client send :{"action": "request", "device": "gateway","seq":2,"cmd":"COMMAND_NODE_ADD"}');
          ws.add(
              '{"action": "request", "device": "gateway","seq":2,"cmd":"COMMAND_NODE_ADD"}');
          break;
          case "REMOVE_NODE":
          DateTime now = new DateTime.now();
          print(
              '$now  [REMOVE_NODE]  client send:{"action": "request", "device": "gateway", "cmd":"COMMAND_NODE_REMOVE",seq":3}');
          ws.add('{"action": "request", "device": "gateway","cmd":"COMMAND_NODE_REMOVE",seq":3}');
          break;
        case "close":
          ws.close();
          print('close success');
          exit(0);
          break;
        default:
          print('don not know');
      }
    });

  }


void basicNodeSetting(int nodeid,String setstate){
WebSocket.connect(server).then((WebSocket socket){
  ws=socket;
ws.listen(onMessage,onDone: connectionClosed);

switch(setstate){

case "GET_POWER":
DateTime now = new DateTime.now();
print(
    '$now  [GET_POWER]  client send:{"action": "request", "device": "electricmeter", "cmd":"COMMAND_GET","seq":6,"para":{"nodeId":15,"scale":2}}');
ws.add('{"action": "request", "device": "electricmeter", "cmd":"COMMAND_GET","seq":6,"para":{"nodeId":$nodeid,"scale":2}}');
break;
case "GET_ELECTRICMETER":
DateTime now = new DateTime.now();
print(
    '$now  [GET_ELECTRICMETER]  client send:{"action": "request", "device": "electricmeter", "cmd":"COMMAND_GET","seq":7,"para":{"nodeId":15,"scale":0}}');
ws.add('{"action": "request", "device": "electricmeter", "cmd":"COMMAND_GET","seq":7,"para":{"nodeId":$nodeid,"scale":0}}');
break;

}
});
}


  void binaraSwitchSetting(int nodeid,String switchstate){
  //  String server = "ws://192.168.10.10:8360/ws?uid=1489111956"; //args[0];
    WebSocket.connect(server).then((WebSocket socket) {
      ws = socket;
      ws.listen(onMessage, onDone: connectionClosed);
switch(switchstate){
case "GET_SWITCHSTATE":
DateTime now = new DateTime.now();
print('$now  [GET_SWITCHSTATE]  client send:{"action": "request", "device": "binaryswitch", "cmd":"COMMAND_SWITCH_BINARY_GET","seq":4,"para":{"nodeId":$nodeid}}');
ws.add('{"action": "request", "device": "binaryswitch", "cmd":"COMMAND_SWITCH_BINARY_GET","seq":4,"para":{"nodeId":$nodeid}}');
break;
case "SWITCH_ON":
DateTime now = new DateTime.now();
print('$now  [SWITCH_ON] client send:{"action": "request", "device": "binaryswitch","cmd":"COMMAND_SWITCH_BINARY_SET","seq":5,"para":{"nodeId":$nodeid,"statu":255}}');
ws.add('{"action": "request", "device": "binaryswitch","cmd":"COMMAND_SWITCH_BINARY_SET","seq":5,"para":{"nodeId":$nodeid,"statu":255}}');
break;
case "SWITCH_OFF":
DateTime now = new DateTime.now();
print('$now  [SWITCH_OFF] client send:{"action": "request", "device": "binaryswitch","cmd":"COMMAND_SWITCH_BINARY_SET","seq":5,"para":{"nodeId":$nodeid,"statu":0}}');
ws.add('{"action": "request", "device": "binaryswitch","cmd":"COMMAND_SWITCH_BINARY_SET","seq":5,"para":{"nodeId":$nodeid,"statu":0}}');
break;
}
    });
  }

  void lightChangeLevel(int nodeid,double lightlevel){
//    String server = "ws://192.168.10.10:8360/ws?uid=1487904132"; //args[0];
    String server =  "ws://192.168.10.10:8360/ws?uid=1489127641";
    //Open the websocket and attach the callbacks
    WebSocket.connect(server).then((WebSocket socket) {
      ws = socket;
      ws.listen(onMessage, onDone: connectionClosed);
      print('client send:{"action": "request", "device": "multilevelswitch", "data":{"nodeid":$nodeid, "cmd":"COMMAND_SWITCH_MULTILEVEL_SET", "para":{"value":$lightlevel}}}');
      ws.add('{"action": "request", "device": "multilevelswitch", "data":{"nodeid":$nodeid, "cmd":"COMMAND_SWITCH_MULTILEVEL_SET", "para":{"value":$lightlevel}}}');
    });
  }

void historyManage(int nodeid,String historyparameter){
  WebSocket.connect(server).then((WebSocket socket) {
    ws = socket;
    ws.listen(onMessage, onDone: connectionClosed);
      DateTime now = new DateTime.now();
    print('$now  [GETHISTORYDATA]  client send:{"action": "request", "device": "multisensor", "data":{"nodeid":$nodeid, "cmd":"COMMAND_METER_HISTORY_GET","para":{"sensortype":35, "scale":1, "cycle":"$historyparameter"}}}');
    ws.add('{"action": "request", "device": "multisensor", "data":{"nodeid":$nodeid, "cmd":"COMMAND_METER_HISTORY_GET","para":{"sensortype":35, "scale":1, "cycle":"$historyparameter"}}}');

  });
}


void multiSensorSetting(int nodeid,String sensorType){
  WebSocket.connect(server).then((WebSocket socket){
    ws=socket;
  ws.listen(onMessage,onDone: connectionClosed);

  switch(sensorType){

  case "GET_TEMPERATURE":
  DateTime now = new DateTime.now();
  print(
      '$now  [GET_TEMPERATURE]  client send:":{"action": "request", "device": "multisensor", "cmd":"COMMAND_GET","seq":8,"para":{"nodeId":$nodeid,"sensortype":1,"scale":0}}');
  ws.add('{"action": "request", "device": "multisensor", "cmd":"COMMAND_GET","seq":8,"para":{"nodeId":$nodeid,"sensortype":1,"scale":0}}');
  break;
  case "GET_HUM":
  DateTime now = new DateTime.now();
  print(
      '$now  [GET_HUM]  client send:{"action": "request", "device": "multisensor", "cmd":"COMMAND_GET","seq":9,"para":{"nodeId":$nodeid,"sensortype":5,"scale":2}}');
  ws.add('{"action": "request", "device": "multisensor", "cmd":"COMMAND_GET","seq":9,"para":{"nodeId":$nodeid,"sensortype":5,"scale":2}}');
  break;

  }
  });

}



  void connectionClosed() {
    print('Websobket Connection to server closed');
  }



  Future<File> _getGatewayFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('save at : $dir/gateway.json');
    return new File('$dir/gateway.json');
  }

  Future<File> _getNodeListFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('save at : $dir/nodelist.json');
    return new File('$dir/nodelist.json');
  }

  Future<File> _getNodeNumFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('save at : $dir/nodenum.json');
    return new File('$dir/nodenum.json');
  }

  Future<File> _getHistoryMinuteFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('save at : $dir/historyminute.json');
    return new File('$dir/historyminute.json');
  }

  Future<File> _getHistoryHourFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('save at : $dir/historyhour.json');
    return new File('$dir/historyhour.json');
  }
  Future<File> _getHistoryMonthFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('save at : $dir/historymonth.json');
    return new File('$dir/historymonth.json');
  }

  Future<File> _getHistoryDayFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('save at : $dir/historyday.json');
    return new File('$dir/historyday.json');
  }

  Future<String> onMessage(message) async {
  DateTime now = new DateTime.now();

    print('$now  according net server recive :$message');

      var recive=JSON.decode(message);
      var dataType=recive['data'];
if(recive['seq']==1){
print("success recieve nodelist");
await (await _getNodeListFile()).writeAsString("$message");
}else if(recive['seq'==2]){
  print("success recieve add command");
  addBackData=message;
  print(addBackData);

}else if(recive['seq']==4){
swichstate=recive['data'];
}

    return (await '$message');
  }

}
