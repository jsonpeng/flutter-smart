import 'websocket.dart';

main() async{
    //var wsdata="discorvory";
    //var datafile="data/wsdata.json";
WebsocketService ws=new WebsocketService();
ws.lightchange(1.0);
//var a=await ws.readData(datafile);
//print("success read data:$a");
}
