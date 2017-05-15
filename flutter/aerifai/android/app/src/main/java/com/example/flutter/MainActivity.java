/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:        2017/03/20
*@LastUpdate:  2017/04/13
*this file  In flutter applications to monitor android events,
*in flutter applications can invoke the native android interface and the SDK college
*
*/

package com.example.flutter;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.graphics.Bitmap;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.view.MotionEvent;
import android.view.InputDevice;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.widget.MediaController;
import android.widget.VideoView;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.view.FlutterMain;
import io.flutter.view.FlutterView;
import io.flutter.plugin.common.FlutterEventChannel;
import io.flutter.plugin.common.FlutterEventChannel.EventSink;
import io.flutter.plugin.common.FlutterEventChannel.StreamHandler;
import io.flutter.plugin.common.FlutterMethodChannel;
import io.flutter.plugin.common.FlutterMethodChannel.MethodCallHandler;
import io.flutter.plugin.common.FlutterMethodChannel.Response;
import io.flutter.plugin.common.MethodCall;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLConnection;
import java.util.UUID;

public class MainActivity extends FlutterActivity {
  private static final String VIDEO_CHANNEL = "video";
  private FlutterView flutterView;

  @Override
  public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      //setContentView(R.layout.hello_services_layout);
// add an channel to communication with flutterview and android native channel
      new FlutterMethodChannel(getFlutterView(), VIDEO_CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, Response response) {
            if (call.method.equals("playMovie")) {
            //  int batteryLevel = getBatteryLevel();
              //if (batteryLevel != -1) {
                    playMovie("file:///sdcard/all.mp4");
              //  response.success(batteryLevel);
            }else if(call.method.equals("playWeather")){
                   playMovie("file:///sdcard/weather.mp4");
            } else {
              response.notImplemented();
            }
          }







        }
    );



  }

    /*add jog encoder in it to replace the ws listener event
      @Override
      public boolean onGenericMotionEvent(MotionEvent event) {
      //The input source is a pointing device associated with a display.
      //输入源为可现实的指针设备，如：mouse pointing device(鼠标指针),stylus pointing device(尖笔设备)
      if (0 != (event.getSource() & InputDevice.SOURCE_CLASS_POINTER)) {
        switch (event.getAction()) {
        // process the scroll wheel movement...处理滚轮事件
        case MotionEvent.ACTION_SCROLL:
        Log.e("fortest::onGenericMotionEvent", "MotionEvent.ACTION_SCROLL" );
        //获得垂直坐标上的滚动方向,也就是滚轮向下滚
        if( event.getAxisValue(MotionEvent.AXIS_VSCROLL) < 0.0f){
          Log.i("fortest::onGenericMotionEvent", "down" );

              }
          //获得垂直坐标上的滚动方向,也就是滚轮向上滚
          else{
            Log.i("fortest::onGenericMotionEvent", "up" );

            }
            return true;
          }
        }
        return false;
      }
*/
  private void playMovie(String s){
              final Intent intent = new Intent(MainActivity.this, VideoActivity.class);
              intent.setAction(Intent.ACTION_VIEW);
              intent.setDataAndType(Uri.parse(s), URLConnection.guessContentTypeFromName(s));
              startActivity(intent);
}
/*
  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }
  */




}
