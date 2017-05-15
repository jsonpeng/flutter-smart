/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:  2017/05/11

*this file  In flutter applications to monitor android events,
*in flutter applications can invoke the native android interface and the SDK college
*
*/

package com.yourcompany.mobileapp;

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
  private static final String VIDEO_CHANNEL = "mobileMovie";
  private FlutterView flutterView;

  @Override
  public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);

      new FlutterMethodChannel(getFlutterView(), VIDEO_CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, Response response) {
            if (call.method.equals("playTemperature")) {
                    playMovie("file:///sdcard/temperature.mp4");
            } else {
              response.notImplemented();
            }
          }
        }
    );
  }

  private void playMovie(String s){
              final Intent intent = new Intent(MainActivity.this, VideoActivity.class);
              intent.setAction(Intent.ACTION_VIEW);
              intent.setDataAndType(Uri.parse(s), URLConnection.guessContentTypeFromName(s));
              startActivity(intent);
            }
}
