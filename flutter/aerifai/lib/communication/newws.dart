/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:        2017/03/20
*@LastUpdate:  2017/05/0
* this file is to protected for app ui to redirect api about websocket setting
*
*/
library newws;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';

class ZwaveWebsocketComunication {
  WebSocket ws;
  static ZwaveWebsocketComunication websocket;
  static bool IsBusy=false;
  static String  nodelist='{"error":0,"action":"REPLY","seq":1,"data":[{"NodeId":1,"BasicDeviceClass":2,"GenericDeviceClass":2,"SpecificDeviceClass":7,"CommandClass":"00000000"},{"NodeId":2,"BasicDeviceClass":4,"GenericDeviceClass":16,"SpecificDeviceClass":1,"CommandClass":"00000000"},{"NodeId":4,"BasicDeviceClass":4,"GenericDeviceClass":17,"SpecificDeviceClass":1,"CommandClass":"00000000"},{"NodeId":7,"BasicDeviceClass":4,"GenericDeviceClass":33,"SpecificDeviceClass":1,"CommandClass":"00000000"}]}';
  static int swichstate=0;
  static int addBackData;
  static int ligntstate=99;
  static double temperature=23.0;
  static int sensortem=23;
  static int pm=39;
  static int jogDir;
  static int jogPos;
    static var historydata='[{"nodetype":"meter","data":[{"data":77,"time":"2017-03-14 09:07:00"},{"data":623,"time":"2017-03-14 09:08:00"},{"data":399,"time":"2017-03-14 09:09:00"},{"data":968,"time":"2017-03-14 09:10:00"},{"data":799,"time":"2017-03-14 09:11:00"},{"data":737,"time":"2017-03-14 09:12:00"},{"data":909,"time":"2017-03-14 09:13:00"},{"data":311,"time":"2017-03-14 09:14:00"},{"data":430,"time":"2017-03-14 09:15:00"},{"data":103,"time":"2017-03-14 09:16:00"},{"data":753,"time":"2017-03-14 09:17:00"},{"data":367,"time":"2017-03-14 09:18:00"},{"data":547,"time":"2017-03-14 09:19:00"},{"data":219,"time":"2017-03-14 09:20:00"},{"data":168,"time":"2017-03-14 09:21:00"},{"data":88,"time":"2017-03-14 09:22:00"},{"data":108.5,"time":"2017-03-14 09:23:00"},{"data":129,"time":"2017-03-14 09:24:00"},{"data":395.5,"time":"2017-03-14 09:25:00"},{"data":662,"time":"2017-03-14 09:26:00"},{"data":405,"time":"2017-03-14 09:27:00"},{"data":662,"time":"2017-03-14 09:28:00"},{"data":517,"time":"2017-03-14 09:29:00"},{"data":465,"time":"2017-03-14 09:30:00"},{"data":912,"time":"2017-03-14 09:31:00"},{"data":706,"time":"2017-03-14 09:32:00"},{"data":725,"time":"2017-03-14 09:33:00"},{"data":132,"time":"2017-03-14 09:34:00"},{"data":970,"time":"2017-03-14 09:35:00"},{"data":918,"time":"2017-03-14 09:36:00"},{"data":629,"time":"2017-03-14 09:37:00"},{"data":628,"time":"2017-03-14 09:38:00"},{"data":644,"time":"2017-03-14 09:39:00"},{"data":647,"time":"2017-03-14 09:40:00"},{"data":19,"time":"2017-03-14 09:41:00"},{"data":20,"time":"2017-03-14 09:42:00"},{"data":903,"time":"2017-03-14 09:43:00"},{"data":625,"time":"2017-03-14 09:44:00"},{"data":806,"time":"2017-03-14 09:45:00"},{"data":640,"time":"2017-03-14 09:46:00"},{"data":21,"time":"2017-03-14 09:47:00"},{"data":9,"time":"2017-03-14 09:48:00"},{"data":994,"time":"2017-03-14 09:49:00"},{"data":75,"time":"2017-03-14 09:50:00"},{"data":732,"time":"2017-03-14 09:51:00"},{"data":65,"time":"2017-03-14 09:52:00"},{"data":568,"time":"2017-03-14 09:53:00"},{"data":664,"time":"2017-03-14 09:54:00"},{"data":143,"time":"2017-03-14 09:55:00"},{"data":575,"time":"2017-03-14 09:56:00"},{"data":290,"time":"2017-03-14 09:57:00"},{"data":967,"time":"2017-03-14 09:58:00"},{"data":363,"time":"2017-03-14 09:59:00"},{"data":714,"time":"2017-03-14 10:00:00"},{"data":913,"time":"2017-03-14 10:01:00"},{"data":796,"time":"2017-03-14 10:02:00"},{"data":356,"time":"2017-03-14 10:03:00"},{"data":738,"time":"2017-03-14 10:04:00"},{"data":751,"time":"2017-03-14 10:05:00"},{"data":46,"time":"2017-03-14 10:06:00"},{"data":913,"time":"2017-03-14 10:01:00"},{"data":796,"time":"2017-03-14 10:02:00"},{"data":356,"time":"2017-03-14 10:03:00"},{"data":738,"time":"2017-03-14 10:04:00"},{"data":751,"time":"2017-03-14 10:05:00"},{"data":46,"time":"2017-03-14 10:06:00"},{"data":913,"time":"2017-03-14 10:01:00"},{"data":796,"time":"2017-03-14 10:02:00"},{"data":356,"time":"2017-03-14 10:03:00"},{"data":738,"time":"2017-03-14 10:04:00"},{"data":751,"time":"2017-03-14 10:05:00"},{"data":46,"time":"2017-03-14 10:06:00"},{"data":913,"time":"2017-03-14 10:01:00"},{"data":796,"time":"2017-03-14 10:02:00"},{"data":356,"time":"2017-03-14 10:03:00"},{"data":738,"time":"2017-03-14 10:04:00"},{"data":751,"time":"2017-03-14 10:05:00"},{"data":46,"time":"2017-03-14 10:06:00"},{"data":913,"time":"2017-03-14 10:01:00"},{"data":796,"time":"2017-03-14 10:02:00"},{"data":356,"time":"2017-03-14 10:03:00"},{"data":738,"time":"2017-03-14 10:04:00"},{"data":751,"time":"2017-03-14 10:05:00"},{"data":46,"time":"2017-03-14 10:06:00"},{"data":913,"time":"2017-03-14 10:01:00"},{"data":796,"time":"2017-03-14 10:02:00"},{"data":356,"time":"2017-03-14 10:03:00"},{"data":738,"time":"2017-03-14 10:04:00"},{"data":751,"time":"2017-03-14 10:05:00"},{"data":46,"time":"2017-03-14 10:06:00"},{"data":232.5,"time":"2017-03-14 10:07:00"},{"data":419,"time":"2017-03-14 10:08:00"},{"data":641,"time":"2017-03-14 10:09:00"},{"data":595,"time":"2017-03-14 10:10:00"},{"data":812,"time":"2017-03-14 10:11:00"},{"data":370,"time":"2017-03-14 10:12:00"},{"data":319,"time":"2017-03-14 10:13:00"},{"data":955,"time":"2017-03-14 10:14:00"},{"data":498,"time":"2017-03-14 10:15:00"},{"data":980,"time":"2017-03-14 10:16:00"},{"data":999,"time":"2017-03-14 10:17:00"},{"data":403,"time":"2017-03-14 10:18:00"},{"data":356,"time":"2017-03-14 10:19:00"},{"data":98,"time":"2017-03-14 10:20:00"},{"data":824,"time":"2017-03-14 10:21:00"},{"data":612,"time":"2017-03-14 10:22:00"},{"data":400,"time":"2017-03-14 10:23:00"},{"data":668,"time":"2017-03-14 10:24:00"},{"data":667,"time":"2017-03-14 10:25:00"},{"data":203,"time":"2017-03-14 10:26:00"},{"data":699,"time":"2017-03-14 10:27:00"},{"data":601,"time":"2017-03-15 04:32:00"}],"nodeid":32817}]';

    static var devicedata='[{"nodetype":"meter","data":[{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":0,"time":"2017-03-15 04:32:00"},{"data":0,"time":"2017-03-14 09:07:00"},{"data":0,"time":"2017-03-14 09:08:00"},{"data":0,"time":"2017-03-14 10:27:00"},{"data":600,"time":"2017-03-15 04:32:00"},{"data":600,"time":"2017-03-14 09:07:00"},{"data":600,"time":"2017-03-14 09:08:00"},{"data":600,"time":"2017-03-14 10:27:00"},{"data":600,"time":"2017-03-15 04:32:00"},{"data":600,"time":"2017-03-15 04:32:00"},{"data":600,"time":"2017-03-14 09:07:00"},{"data":600,"time":"2017-03-14 09:08:00"},{"data":600,"time":"2017-03-14 10:27:00"},{"data":600,"time":"2017-03-15 04:32:00"},{"data":600,"time":"2017-03-15 04:32:00"},{"data":600,"time":"2017-03-14 09:07:00"},{"data":600,"time":"2017-03-14 09:08:00"},{"data":600,"time":"2017-03-14 10:27:00"},{"data":600,"time":"2017-03-15 04:32:00"},{"data":600,"time":"2017-03-15 04:32:00"},{"data":600,"time":"2017-03-14 09:07:00"},{"data":600,"time":"2017-03-14 09:08:00"},{"data":600,"time":"2017-03-14 10:27:00"},{"data":600,"time":"2017-03-15 04:32:00"}],"nodeid":32817}]';
  static String server = "ws://127.0.0.1:8360/ws?uid=1488963192";

  //static WebSocket ws=WebSocket.connect(server);
/*
 * basicSet for node ,is all const paremeter
 *
 */
static ZwaveWebsocketComunication zc ;
static ZwaveWebsocketComunication singleSinglen() {
  if (zc == null) {
    ZwaveWebsocketComunication zc =  new ZwaveWebsocketComunication();
    print('zc:'+'$zc');
  }
  return zc;
}

  void connectServer(){
    WebSocket.connect(server).then((socket){
      ws=socket;
      ws.listen(onMessage, onDone: connectionClosed);
    });
}

  void basicSetting({int nodeid,String wsdata,double lightlevel,String historyparameter}) {
    if(IsBusy){
      return;
    }else{
      IsBusy=true;
    }
      switch (wsdata) {
        case "GET_NODELIST":
          DateTime now = new DateTime.now();
          print('$now  [GET_NODELIST]  client send :{"action": "request", "device": "gateway","seq":1, "cmd":"COMMAND_NODE_LIST_GET"}');
          ws.add('{"action": "request", "device": "gateway","seq":1, "cmd":"COMMAND_NODE_LIST_GET"}');
          break;
        case "ADD_NODE":
          DateTime now = new DateTime.now();
          print('$now  [ADD_NODE]  client send :{"action": "request", "device": "gateway","seq":2,"cmd":"COMMAND_NODE_ADD"}');
          ws.add('{"action": "request", "device": "gateway","seq":2,"cmd":"COMMAND_NODE_ADD"}');
          break;
        case "REMOVE_NODE":
          DateTime now = new DateTime.now();
          print('$now  [REMOVE_NODE]  client send:{"action": "request", "device": "gateway","seq":3, "cmd":"COMMAND_NODE_REMOVE"}');
          ws.add('{"action": "request", "device": "gateway","seq":3, "cmd":"COMMAND_NODE_REMOVE"}');
          break;
          case "GET_SWITCHSTATE":
          DateTime now = new DateTime.now();
          print('$now  [GET_SWITCHSTATE]  client send:{"action": "request", "device": "binaryswitch", "cmd":"COMMAND_SWITCH_BINARY_GET","seq":4,"para":{"nodeId":$nodeid}}');
          ws.add('{"action": "request", "device": "binaryswitch", "cmd":"COMMAND_SWITCH_BINARY_GET","seq":4,"para":{"nodeId":$nodeid}}');
          break;
          case "SET_SWITCH_ON":
          DateTime now = new DateTime.now();
          print('$now  [SWITCH_ON] client send:{"action": "request", "device": "binaryswitch","cmd":"COMMAND_SWITCH_BINARY_SET","seq":5,"para":{"nodeId":$nodeid,"statu":255}}');
          ws.add('{"action": "request", "device": "binaryswitch","cmd":"COMMAND_SWITCH_BINARY_SET","seq":5,"para":{"nodeId":$nodeid,"statu":255}}');
          break;
          case "SET_SWITCH_OFF":
          DateTime now = new DateTime.now();
          print('$now  [SWITCH_OFF] client send:{"action": "request", "device": "binaryswitch","cmd":"COMMAND_SWITCH_BINARY_SET","seq":5,"para":{"nodeId":$nodeid,"statu":0}}');
          ws.add('{"action": "request", "device": "binaryswitch","cmd":"COMMAND_SWITCH_BINARY_SET","seq":5,"para":{"nodeId":$nodeid,"statu":0}}');
          break;
       case  "GET_LIGHTSTATE":
         DateTime now =new DateTime.now();
         print('$now  [GET_LIGHTSWITCHSTATE]  {"action": "request", "device": "multilevelswitch","cmd":"COMMAND_SWITCH_MULTI_GET","seq":6,"para":{"nodeId":$nodeid}}');
         ws.add('{"action": "request", "device": "multilevelswitch","cmd":"COMMAND_SWITCH_MULTI_GET","seq":6,"para":{"nodeId":$nodeid}}');
         break;
        case "SET_LIGHTSWITCHLEVEL":
         DateTime now = new DateTime.now();
         print('$now [SET_LIGHTSWITCHLEVEL]  {"action": "request", "device": "multilevelswitch","cmd":"COMMAND_SWITCH_MULTI_SET","seq":7,"para":{"nodeId":$nodeid,"value":$lightlevel}}');
         ws.add('{"action": "request", "device": "multilevelswitch","cmd":"COMMAND_SWITCH_MULTI_SET","seq":7,"para":{"nodeId":$nodeid,"value":$lightlevel}}');
         break;
        case "GET_HISTORYPARAMETER":
         DateTime now = new DateTime.now();
         print('$now  [GET_HISTORYDATA]  {"action": "request", "device": "history", "cmd":"COMMAND_METER_HISTORY_GET","seq":8,"para":{"nodeId":$nodeid,"sensortype":4,"cycle":"$historyparameter"}}');
         ws.add('{"action": "request", "device": "history", "cmd":"COMMAND_METER_HISTORY_GET","seq":8,"para":{"nodeId":$nodeid,"sensortype":4,"cycle":"$historyparameter"}}');
         break;
        case "GET_TEMPERATURE":
           DateTime now = new DateTime.now();
           print('$now  [GET_TEMPERATURE] {"action": "request", "device": "multisensor", "cmd":"COMMAND_GET","seq":9,"para":{"nodeId":$nodeid,"sensortype":1,"scale":0}}');
           ws.add('{"action": "request", "device": "multisensor", "cmd":"COMMAND_GET","seq":9,"para":{"nodeId":$nodeid,"sensortype":1,"scale":0}}');
           break;
           case "GET_HUM":
           DateTime now = new DateTime.now();
           print('$now  [GET_HUM] {"action": "request", "device": "multisensor", "cmd":"COMMAND_GET","seq":10,"para":{"nodeId":$nodeid,"sensortype":5,"scale":2}}');
           ws.add('{"action": "request", "device": "multisensor", "cmd":"COMMAND_GET","seq":10,"para":{"nodeId":$nodeid,"sensortype":5,"scale":2}}');
           break;
           case "SENSOR_GET_PM":
           DateTime now = new DateTime.now();
           print('$now  [SENSOR_GET_PM] {"action": "request", "device": "localsensor","seq":11, "cmd":"COMMAND_GET_PM2.5"}');
           ws.add('{"action": "request", "device": "localsensor","seq":11, "cmd":"COMMAND_GET_PM2.5"}');
           break;
           case "SYSTEM_POWER_OFF":
           DateTime now = new DateTime.now();
           print('$now  [SYSTEM_POWER_OFF] {"action": "request", "device": "localsensor","seq":12, "cmd":"COMMAND_POWER_OFF"}');
           ws.add('{"action": "request", "device": "localsensor","seq":12, "cmd":"COMMAND_POWER_OFF"}');
           break;
           case "SYSTEM_REBOOT":
           DateTime now = new DateTime.now();
           print('$now  [SYSTEM_REBOOT]  {"action": "request", "device": "localsensor","seq":13, "cmd":"COMMAND_REBOOT"}');
           ws.add('{"action": "request", "device": "localsensor","seq":13, "cmd":"COMMAND_REBOOT"}');
           break;
           case "GET_POWER":
             DateTime now = new DateTime.now();
             print(
                 '$now  [GET_POWER]  client send:{"action": "request", "device": "electricmeter", "cmd":"COMMAND_GET","seq":14,"para":{"nodeId":$nodeid,"scale":2}}');
             ws.add('{"action": "request", "device": "electricmeter", "cmd":"COMMAND_GET","seq":14,"para":{"nodeId":$nodeid,"scale":2}}');
             break;
           case "GET_ELECTRICMETER":
             DateTime now = new DateTime.now();
             print('$now  [GET_ELECTRICMETER]  client send:{"action": "request", "device": "electricmeter", "cmd":"COMMAND_GET","seq":15,"para":{"nodeId":$nodeid,"scale":0}}');
             ws.add('{"action": "request", "device": "electricmeter", "cmd":"COMMAND_GET","seq":15,"para":{"nodeId":$nodeid,"scale":0}}');
             break;
             case "SENSOR_GET_TEMPERATURE":
               DateTime now = new DateTime.now();
               print('$now  [SENSOR_GET_TEMPERATURE]  client send:{"action": "request", "device": "localsensor","seq":16,"cmd":"COMMAND_TEMPERATURE"}');
               ws.add('{"action": "request", "device": "localsensor","seq":16,"cmd":"COMMAND_TEMPERATURE"}');
               break;
              case "SYSTEM_GET_JOG":
              DateTime now = new DateTime.now();
              print('$now  [SYSTEM_GET_JOG]  client send:{"action": "request", "device": "localsensor","seq":17,"cmd":"COMMAND_DIR_POS"}');
              ws.add('{"action": "request", "device": "localsensor","seq":17,"cmd":"COMMAND_DIR_POS"}');
              break;
  //{"action": "request", "device": "gateway","seq":1, "cmd":"COMMAND_GATEWAY_SET"}
  case "SET_RESET_NETWORK":
  DateTime now = new DateTime.now();
  print('$now  [SET_RESET_NETWORK]  client send:{"action": "request", "device": "gateway","seq":18, "cmd":"COMMAND_GATEWAY_SET"}');
  ws.add('{"action": "request", "device": "gateway","seq":18, "cmd":"COMMAND_GATEWAY_SET"}');
  break;
        case "close":
          ws.close();
          print('close success');
          exit(0);
          break;
        default:
          print('don not know');
      }
     IsBusy=false;
  }


  void connectionClosed() {
    ws.close();
    print('Websobket Connection to server closed');
    connectServer();
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
    await (await _getHistoryMinuteFile()).writeAsString('$historydata');
    await (await _getHistoryHourFile()).writeAsString('$devicedata');
      var recive=JSON.decode(message);
      //var dataType=recive['data'];
if(recive['seq']==1 && recive['error']==0){
print("success recieve nodelist");
nodelist='$message';
//await (await _getNodeListFile()).writeAsString("$message");
}else if(recive['seq']==1 && recive['error']==1){
print("failed recieve nodelist");
//await (await _getNodeListFile()).writeAsString("$message");
}else if(recive['seq']==2){
  addBackData=recive['data']['GenericDeviceClass'];
  print(addBackData);
}else if(recive['seq']==4 && recive['error']==0){
swichstate=recive['data'];
print(swichstate);
}else if(recive['seq']==4 && recive['error']==1){
    print('get switch error');
  swichstate=0;
}else if(recive['seq']==6 &&recive['error']==0){
ligntstate=recive['data'];
print(ligntstate);
}else if(recive['seq']==6 &&recive['error']==1){
ligntstate=0;
print(ligntstate);
}/*
else if(recive['seq']==8){
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
}*/
else if(recive['seq']==9){
var tem=recive['data'];
temperature=double.parse('$tem');
}else if(recive['error']!=1 && recive['seq']==11){
pm=recive['data'];
print("PM2.5:"+'$pm');
}else if( recive['error']==1 && recive['seq']==11){
pm=0;
}else if(recive['seq']==16 && recive['error']==0){
sensortem=recive['data'];
}else if(recive['seq']==16 && recive['error']==1){
sensortem=23;
}else if(recive['seq']==17 && recive['error']==0){
jogDir=int.parse(recive['data'][0]);
jogPos=int.parse(recive['data'][1]);
print(jogDir);
print(jogPos);
// according net server recive :{"error":1,"action":"REPLY","seq":0,"data":"error command"}
}else if(recive['error']==1 && recive['data']=="error command"){
ws.close();
}
    //IsBusy =false;
    return (await '$message');
  }

}
