/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:        2017/04/17
*@LastUpdate:  2017/04/18
* this file is to protected for jog control for flutter view
*
*/
import 'dart:async';
import 'newws.dart';

class JogControl {
  static int jogNum;
  static int jogItem;
  Timer jogtimer;

  void startJogListening(){

  new Timer.periodic(new Duration(milliseconds:500),jogDealWith);

  }


   jogDealWith(Timer jogtimer){

    ZwaveWebsocketComunication.websocket.basicSetting(wsdata: 'SYSTEM_GET_JOG');

}



}
