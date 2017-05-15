library ws;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
WebSocket ws;

class WebsocketService {

  var datafile = "data/wsdata.json";

  void set(String wsdata) {
    String server = "ws://192.168.10.10:8360/ws?uid=1484703129"; //args[0];

    //Open the websocket and attach the callbacks
    WebSocket.connect(server).then((WebSocket socket) {
      ws = socket;
      ws.listen(onMessage, onDone: connectionClosed);
      switch (wsdata) {
        case "discorvory":
          print(
              'client send :{"action": "request", "device": "gateway", "data":{ "nodeid":0, "cmd":"COMMAND_NODE_INFO_CACHED_GET"}}');
          ws.add(
              '{"action": "request", "device": "gateway", "data":{ "nodeid":0, "cmd":"COMMAND_NODE_INFO_CACHED_GET"}}');
          break;
        case "setcontroller":
          print(
              'client send :{"action": "request", "device": "gateway", "data":{ "nodeid":1, "cmd":"COMMAND_NODE_INFO_SET", "para":{"ip":"192.168.10.191", "psk":"123456789012345678901234567890AA"}}}');
          ws.add(
              '{"action": "request", "device": "gateway", "data":{ "nodeid":1, "cmd":"COMMAND_NODE_INFO_SET", "para":{"ip":"192.168.10.191", "psk":"123456789012345678901234567890AA"}}}');
          break;
        case "close":
          ws.close();
          print('close success');
          exit(0);
          break;
          case "switchon":
          print("switchon success");
          ws.add(
              '{"action":"request","device":"binaryswitch","data":{"nodeid":30,"cmd":"COMMAND_SWITCH_BINARY_SET","para":{"value":"on"}}}');
                break;
          case "switchoff":
            print("switchoff success");
            ws.add(
                '{"action":"request","device":"binaryswitch","data":{"nodeid":30,"cmd":"COMMAND_SWITCH_BINARY_SET","para":{"value":"off"}}}');
                  break;
        default:
          print('don not know ');
      }
    });
    //   return data;
  }

  void connectionClosed() {
    print('Websobket Connection to server closed');
  }

  Future<String> onMessage(message) async {
    //print(message);
    //File file = new File(datafile);

    // if (!await file.exists()) {
    //   file = await file.create();
    // }
    //file = await file.writeAsBytes(UTF8.encode("$message"));
    //print("save json success:" + UTF8.decode(await file.readAsBytes()));
    print(message);
    return (await '$message');
  }



 Future<String> readJson(datafile) async{
 //var completer = new Completer();
  File file =new File(datafile);


// completer.complete(data);

return (await UTF8.decode(await  file.readAsBytes()));

}



 Future<String> readData(datafile) {

      var aa=new File(datafile).readAsString().then((String contents){return contents;});

      return aa;

  }

  }
