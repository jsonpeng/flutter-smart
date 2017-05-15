import 'newws.dart';
import 'dart:async';
ZwaveWebsocketComunication ws= new ZwaveWebsocketComunication();
  Timer autotimer;
 main() async{

ws.connectServer();
ZwaveWebsocketComunication.websocket=ws;

//new Timer(new Duration(milliseconds: 300), (){
   //ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'GET_NODELIST');
//});
autotimer=new Timer.periodic(new Duration(seconds: 3),autoGotTem);

}


autoGotTem(Timer autotimer){
   ZwaveWebsocketComunication.websocket.basicSetting(wsdata:'REMOVE_NODE');
}
