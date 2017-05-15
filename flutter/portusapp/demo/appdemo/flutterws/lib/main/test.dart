import 'recievews.dart';
// import 'dart:io';


 main() async{
var wsdata='setcontroller';
WebsocketService ws=new WebsocketService();
ws.send(wsdata);

//var aa=await ws.readJson("data/wsdata.json");
//print(aa);
}
