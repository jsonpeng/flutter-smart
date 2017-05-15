library wstest;


import 'dart:io';
import 'dart:async';


 var aa;
 class WebsocketService {



   Future send(String wsdata) async {

    WebSocket.connect('ws://192.168.10.10:8360/ws?uid=1484703129').then((socket) async {

        //{"action": "request", "device": "gateway", "data":{ "nodeid":1, "cmd":"COMMAND_NODE_INFO_SET", "para":{"ip":"192.168.10.121", "psk":"123456789012345678901234567890AA"}}}
      //socket.add(wsdata);
      switch (wsdata){
          case "discorvory":
          //print('client send :{"action": "request", "device": "gateway", "data":{ "nodeid":0, "cmd":"COMMAND_NODE_INFO_CACHED_GET"}}');
          socket.add('{"action": "request", "device": "gateway", "data":{ "nodeid":0, "cmd":"COMMAND_NODE_INFO_CACHED_GET"}}');
          break;
          case "setcontroller":
              //print('client send :{"action": "request", "device": "gateway", "data":{ "nodeid":1, "cmd":"COMMAND_NODE_INFO_SET", "para":{"ip":"192.168.10.121", "psk":"123456789012345678901234567890AA"}}}');
          socket.add('{"action": "request", "device": "gateway", "data":{ "nodeid":1, "cmd":"COMMAND_NODE_INFO_SET", "para":{"ip":"192.168.10.111", "psk":"123456789012345678901234567890AA"}}}');
          break;
          default:
          //print('don not know ');
          socket.close();
          exit(0);
      }

     socket.listen((onData) async{
    Completer completer = new Completer();
                  // String reply=onData;
               //print(onData);
              //AA aa=new AA();
              //aa=onData;
              aa=onData;
                completer.complete(aa);

                return aa;
               //print(aa);
               //return data;
          });
              });
    return aa;

  }


}

 main() async{

WebsocketService ws=new WebsocketService();
var wsdata='setcontroller';
var bb=await ws.send(wsdata);
print(bb);
//print("success rec:"+aa);



}
