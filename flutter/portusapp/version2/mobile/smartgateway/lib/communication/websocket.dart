library websocket;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

WebSocket ws;

class WebsocketService {
  static String switchstate;
    String server = "ws://192.168.10.10:8360/ws?uid=1489127641"; //args[0];
  void set(String wsdata) {
    //Open the websocket and attach the callbacks
    WebSocket.connect(server).then((WebSocket socket) {
      ws = socket;

      ws.listen(onMessage, onDone: connectionClosed);
      switch (wsdata) {
        case "addnode":
  DateTime now = new DateTime.now();
          print(
              '$now  [ADD_NODE]  client send :{"action": "request", "device": "gateway", "data": {"nodeid":1, "cmd":"COMMAND_NODE_ADD","para":{"mode":"NODE_ADD_ANY"}}}');
          ws.add(
              '{"action": "request", "device": "gateway", "data": {"nodeid":1, "cmd":"COMMAND_NODE_ADD","para":{"mode":"NODE_ADD_ANY"}}}');
          break;
        case "remnode":
          DateTime now = new DateTime.now();
          print(
              '$now  [REM_NODE]  client send :{"action": "request", "device": "gateway", "data": {"nodeid":1, "cmd":"COMMAND_NODE_REMOVE","para":{"mode":"NODE_ADD_ANY"}}}');
          ws.add(
              '{"action": "request", "device": "gateway", "data": {"nodeid":1, "cmd":"COMMAND_NODE_REMOVE","para":{"mode":"NODE_ADD_ANY"}}}');
          break;

        case "discorvory":
          DateTime now = new DateTime.now();
          print(
              '$now  [DISCORVORY]  client send :{"action": "request", "device": "gateway", "data":{ "nodeid":0, "cmd":"COMMAND_NODE_INFO_CACHED_GET"}}');
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
          DateTime now = new DateTime.now();
          print('$now  [GETNODELIST]  client send :{"action": "request", "device": "gateway", "data":{"nodeid":1, "cmd":"COMMAND_NODE_LIST_GET", "para":{"ip":"192.168.10.190","psk":"123456789012345678901234567890AA"}}}');
          ws.add('{"action": "request", "device": "gateway", "data":{"nodeid":1, "cmd":"COMMAND_NODE_LIST_GET", "para":{"ip":"192.168.10.190","psk":"123456789012345678901234567890AA"}}}');
          break;
        case "gethistory":
          //DateTime now = new DateTime.now();
        //  print('client send by:$now');
          ws.add('{"action": "request", "device": "multisensor", "data":{"nodeid":32817, "cmd":"COMMAND_METER_HISTORY_GET","para":{"sensortype":35, "scale":1, "cycle":"minute"}}}');
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
  void binaraSwitchSetting(int nodeid,String switchstate){
  //  String server = "ws://192.168.10.10:8360/ws?uid=1489111956"; //args[0];
    WebSocket.connect(server).then((WebSocket socket) {
      ws = socket;
      ws.listen(onMessage, onDone: connectionClosed);


          print(
              'clent send:{"action":"request","device":"binaryswitch","data":{"nodeid":$nodeid,"cmd":"COMMAND_SWITCH_BINARY_SET","para":{"value":"$switchstate"}}}');
          ws.add(
              '{"action":"request","device":"binaryswitch","data":{"nodeid":$nodeid,"cmd":"COMMAND_SWITCH_BINARY_SET","para":{"value":"$switchstate"}}}');


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


//32817
void historyManage(int nodeid,String historyparameter){
  WebSocket.connect(server).then((WebSocket socket) {
    ws = socket;
    ws.listen(onMessage, onDone: connectionClosed);
      DateTime now = new DateTime.now();
    print('$now  [GETHISTORYDATA]  client send:{"action": "request", "device": "multisensor", "data":{"nodeid":$nodeid, "cmd":"COMMAND_METER_HISTORY_GET","para":{"sensortype":35, "scale":1, "cycle":"$historyparameter"}}}');
    ws.add('{"action": "request", "device": "multisensor", "data":{"nodeid":$nodeid, "cmd":"COMMAND_METER_HISTORY_GET","para":{"sensortype":35, "scale":1, "cycle":"$historyparameter"}}}');

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
    print('according net server recive :$message');
    // if(message!='') {
    //   data = message;
    //
    // }
      var recive=JSON.decode(message);
        List dataType=recive['data'];

    if (recive['data'] != null) {

    //  print('dataArr=$dataType');
//      for (int i = 0; i < dataType.length; i++) {

//        Map map = dataType[i];
      Map map = dataType[0];
        print('map=$map');

        if(map['time']!=null) {
          DateTime time = DateTime.parse(map['time']);
          if(time.minute!=0){
            //print('savedMinuteFile');
            await (await _getHistoryMinuteFile()).writeAsString('$message');
          }else if(time.hour!=0){
          //  print('savedHourFile');
            await (await _getHistoryHourFile()).writeAsString('$message');
          }else if(time.day!=0){
          //  print('savedDayFile');
            await (await _getHistoryDayFile()).writeAsString('$message');
          }else{
          //  print('savedMonthFile');
            await (await _getHistoryMonthFile()).writeAsString('$message');
          }
        }
    }
      else if (recive['data'][0]['gatewayip'] !=null){

        var gateway=recive['data'][0]['gatewayip'];
      print("success  gateway to "+gateway);
await (await _getGatewayFile()).writeAsString('$gateway');
  }else if(recive['result']=="save file ok"){
      print("ws save gatewaty success");
  }else if(recive['data'][0]['nscmd'] !=null) {
        //List<String> a=recive['data'];
        print(dataType.length);
        // print("nodelist successful:${recive['data']}");
        await (await _getNodeNumFile()).writeAsString('${dataType.length}');
        await (await _getNodeListFile()).writeAsString('$recive');
      }
    return (await '$message');
  }
}
