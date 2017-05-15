library websocket;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

WebSocket ws;

class WebsocketService {

 // var datafile = "data/wsdata.json";

  void set(String wsdata) {
    String server = "ws://192.168.10.10:8360/ws?uid=1487904132"; //args[0];

    //Open the websocket and attach the callbacks
    WebSocket.connect(server).then((WebSocket socket) {
      ws = socket;
      ws.listen(onMessage, onDone: connectionClosed);
      switch (wsdata) {
          case "addnode":
            print(
                'client send :{"action": "request", "device": "gateway", "data": {"nodeid":1, "cmd":"COMMAND_NODE_ADD","para":{"mode":"NODE_ADD_ANY"}}}');
            ws.add(
                '{"action": "request", "device": "gateway", "data": {"nodeid":1, "cmd":"COMMAND_NODE_ADD","para":{"mode":"NODE_ADD_ANY"}}}');
            break;
            case "remnode":
              print(
                  'client send :{"action": "request", "device": "gateway", "data": {"nodeid":1, "cmd":"COMMAND_NODE_REMOVE","para":{"mode":"NODE_ADD_ANY"}}}');
              ws.add(
                  '{"action": "request", "device": "gateway", "data": {"nodeid":1, "cmd":"COMMAND_NODE_REMOVE","para":{"mode":"NODE_ADD_ANY"}}}');
              break;

        case "discorvory":
          print(
              'client send :{"action": "request", "device": "gateway", "data":{ "nodeid":0, "cmd":"COMMAND_NODE_INFO_CACHED_GET"}}');
          ws.add(
              '{"action": "request", "device": "gateway", "data":{"nodeid":0, "cmd":"COMMAND_NODE_INFO_CACHED_GET"}}');
          break;
        case "setcontroller":
          print(
              'client send :{"action": "request", "device": "gateway", "data":{"nodeid":1, "cmd":"COMMAND_NODE_INFO_SET", "para":{"ip":"192.168.10.190", "psk":"123456789012345678901234567890AA"}}}');
          ws.add(
              '{"action": "request", "device": "gateway", "data":{ "nodeid":1, "cmd":"COMMAND_NODE_INFO_SET", "para":{"ip":"192.168.10.190", "psk":"123456789012345678901234567890AA"}}}');
          break;
          case "getnodelist":
          print('client send :{"action": "request", "device": "gateway", "data":{"nodeid":1, "cmd":"COMMAND_NODE_LIST_GET", "para":{"ip":"192.168.10.190","psk":"123456789012345678901234567890AA"}}}');
          ws.add('{"action": "request", "device": "gateway", "data":{"nodeid":1, "cmd":"COMMAND_NODE_LIST_GET", "para":{"ip":"192.168.10.190","psk":"123456789012345678901234567890AA"}}}');
          break;
          case "gethistory":
           DateTime now = new DateTime.now();
          print('client send by:$now');
          ws.add('{"action": "request", "device": "multisensor", "data":{"nodeid":32817, "cmd":"COMMAND_METER_HISTORY_GET","para":{"sensortype":35, "scale":1, "cycle":"hour"}}}');
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

  void binaraSwitchSetting(String switchstate,int nodeid){
    String server = "ws://192.168.10.10:8360/ws?uid=1487904132"; //args[0];

    WebSocket.connect(server).then((WebSocket socket) {
      ws = socket;
      ws.listen(onMessage, onDone: connectionClosed);
      switch (switchstate) {
        case "on":
          print(
              'clent send:{"action":"request","device":"binaryswitch","data":{"nodeid":$nodeid,"cmd":"COMMAND_SWITCH_BINARY_SET","para":{"value":"on"}}}');
          ws.add(
              '{"action":"request","device":"binaryswitch","data":{"nodeid":$nodeid,"cmd":"COMMAND_SWITCH_BINARY_SET","para":{"value":"on"}}}');
          break;
        case "off":
          print(
              'clent send:{"action":"request","device":"binaryswitch","data":{"nodeid":$nodeid,"cmd":"COMMAND_SWITCH_BINARY_SET","para":{"value":"off"}}}');
          ws.add(
              '{"action":"request","device":"binaryswitch","data":{"nodeid":$nodeid,"cmd":"COMMAND_SWITCH_BINARY_SET","para":{"value":"off"}}}');
          break;
      }
    });
}

   void lightchange(double lightlevel){
       String server = "ws://192.168.10.10:8360/ws?uid=1487904132"; //args[0];

       //Open the websocket and attach the callbacks
       WebSocket.connect(server).then((WebSocket socket) {
         ws = socket;
         ws.listen(onMessage, onDone: connectionClosed);
         print('client send:{"action": "request", "device": "multilevelswitch", "data":{"nodeid":32817, "cmd":"COMMAND_SWITCH_MULTILEVEL_SET", "para":{"value":$lightlevel}}}');
         ws.add('{"action": "request", "device": "multilevelswitch", "data":{"nodeid":32817, "cmd":"COMMAND_SWITCH_MULTILEVEL_SET", "para":{"value":$lightlevel}}}');
             });

   }

  void connectionClosed() {
    print('Websobket Connection to server closed');
  }



  Future<File> _getGatewayFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('$dir/gateway.json');
    return new File('$dir/gateway.json');
  }

  Future<File> _getNodeListFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('$dir/nodelist.json');
    return new File('$dir/nodelist.json');
  }

  Future<File> _getNodeNumFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    print('$dir/nodenum.json');
    return new File('$dir/nodenum.json');
  }


  Future<String> onMessage(message) async {
//need zhushi in flutter run
      var recive=JSON.decode(message);
      if (recive['data'][0]['gatewayip'] !=null){

        var gateway=recive['data'][0]['gatewayip'];
      print("success  gateway to "+gateway);
await (await _getGatewayFile()).writeAsString('$gateway');
  }else if(recive['result']=="save file ok"){
      print("ws save gatewaty success");
  }else if(recive['data'][0]['nscmd'] !=null){
      List<String> a=recive['data'];
      print(a.length);
     // print("nodelist successful:${recive['data']}");
     await (await _getNodeNumFile()).writeAsString('${a.length}');
await (await _getNodeListFile()).writeAsString('$recive');
  }else {
 DateTime now = new DateTime.now();
print("get history time:" +'$now');


  }
      print("net receive:" + message);
    return (await '$message');
  }



}
