import "dart:io";
//import "package:websockets/websockets.dart";
var aa;
  wssend(String wsdata) async {
  WebSocket ws = await WebSocket.connect("ws://192.168.10.10:8360/ws?uid=1484703129");
  //ws.listen(print);
 Future<String> ws.listen((msg) async{
      aa=msg;
     print("Server received:"+aa);

     //ws.add("Server received: $evt");
     return '$aa';
   });
   switch (wsdata){
       case "discorvory":
       print('client send :{"action": "request", "device": "gateway", "data":{ "nodeid":0, "cmd":"COMMAND_NODE_INFO_CACHED_GET"}}');
       ws.add('{"action": "request", "device": "gateway", "data":{ "nodeid":0, "cmd":"COMMAND_NODE_INFO_CACHED_GET"}}');
       break;
       case "setcontroller":
     print('client send :{"action": "request", "device": "gateway", "data":{ "nodeid":1, "cmd":"COMMAND_NODE_INFO_SET", "para":{"ip":"192.168.10.111", "psk":"123456789012345678901234567890AA"}}}');
       ws.add('{"action": "request", "device": "gateway", "data":{ "nodeid":1, "cmd":"COMMAND_NODE_INFO_SET", "para":{"ip":"192.168.10.111", "psk":"123456789012345678901234567890AA"}}}');
       break;
       default:
       print('don not know ');
       ws.close();
       exit(0);
   }

}

 getwsdata() async{
     return aa;
 }
