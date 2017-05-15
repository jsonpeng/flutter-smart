// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
package com.example.flutter;

//import com.example.flutter.CustomView;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.graphics.Bitmap;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.widget.MediaController;
import android.widget.VideoView;
import io.flutter.view.FlutterMain;
import io.flutter.view.FlutterView;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLConnection;
import java.util.UUID;

public class MainActivity extends Activity {
    private static final String TAG = "MainActivity";

    private FlutterView flutterView;
    private FlutterView.MessageResponse _response;

    MediaPlayer mediaPlayer;

    private void initPlayer() {

    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FlutterMain.ensureInitializationComplete(getApplicationContext(), null);
        setContentView(R.layout.hello_services_layout);

        flutterView = (FlutterView) findViewById(R.id.flutter_view);
        flutterView.runFromBundle(FlutterMain.findAppBundlePath(getApplicationContext()), null);
   /*
隐藏媒体播放
   */
   //MediaController mc=new MediaController(this);
  // mc.setVisibility(View.INVISIBLE);
   //videoView.setMediaController(mc);

//CustomView VideoView=new CustomView();
        final VideoView videoView =
                (VideoView) findViewById(R.id.videoView);

        videoView.setZOrderOnTop(true);

        // attach a mediacontroller
        MediaController mediaController = new MediaController(MainActivity.this,false);
      mediaController.setAnchorView(videoView);
    //mediaController.setVisibility(View.INVISIBLE);
        videoView.setMediaController(null);
      //  videoView.setLayoutParams(new LayoutParams(300,300));




        flutterView.addOnMessageListenerAsync("openVideoActivity",
                new FlutterView.OnMessageListenerAsync() {
                    @Override
                    public void onMessage(FlutterView flutterView, String s, FlutterView.MessageResponse messageResponse) {
                        final Intent intent = new Intent(MainActivity.this, VideoActivity.class);
                        intent.setAction(Intent.ACTION_VIEW);
                        intent.setDataAndType(Uri.parse(s), URLConnection.guessContentTypeFromName(s));
                        startActivity(intent);
                        System.out.println("pengyun start activity");
                    }
                });

        flutterView.addOnMessageListenerAsync("playVideo",
                new FlutterView.OnMessageListenerAsync() {
                    @Override
                    public void onMessage(FlutterView flutterView, String param, FlutterView.MessageResponse messageResponse) {
                        _response = messageResponse;
                        if (!videoView.isPlaying()) {
                            videoView.setVisibility(videoView.VISIBLE);
                          //Uri videoUri=Uri.fromFile(param);
                          videoView.setVideoPath(param);
                            //videoView.setVideoPath(param);
                            System.out.println("pengyun start movie");
                            videoView.start();
                            videoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {

    @Override
    public void onCompletion(MediaPlayer videoView) {
    // TODO Auto-generated method stub
    videoView.start();
    videoView.setLooping(true);
    }
});
                        } else
                            videoView.pause();
                    }


                });



        flutterView.addOnMessageListenerAsync("stopVideo",
                new FlutterView.OnMessageListenerAsync() {
                    @Override
                    public void onMessage(FlutterView flutterView, String s, FlutterView.MessageResponse messageResponse) {
                        _response = messageResponse;
                        // if (videoView.isPlaying())
                       // videoView.stopPlayback();
                        //videoView.setVisibility(videoView.INVISIBLE);
                        System.out.println("pengyun video stop,hide the controller");
                         // videoView.setVisibility(videoView.GONE);
                       // MediaPlayer mp;
                        onDestroy();
                       // mp.setVisibility(mp.GONE);
                    }
                });

/*
        flutterView.addOnMessageListenerAsync("playAudio",
                new FlutterView.OnMessageListenerAsync() {
                    @Override
                    public void onMessage(FlutterView flutterView, String param, FlutterView.MessageResponse messageResponse) {

                        _response = messageResponse;

                        if( mediaPlayer != null && mediaPlayer.isPlaying() ){
                            mediaPlayer.pause();
                            return;
                        }


                        if (mediaPlayer == null) {
                            mediaPlayer = new MediaPlayer();
                            mediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);

                            try {
                                mediaPlayer.setDataSource(param);
                            } catch (IOException e) {
                                e.printStackTrace();
                                Log.d("AUDIO", "invalid DataSource");
                            }

                            try {
                                mediaPlayer.prepare(); // might take long! (for buffering, etc)
                                Log.d("AUDIO", "media preapre ERROR");
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }

                        // start or resume
                        mediaPlayer.start();
                    }
                });
        flutterView.addOnMessageListenerAsync("stopAudio",
                new FlutterView.OnMessageListenerAsync() {
                    @Override
                    public void onMessage(FlutterView flutterView, String s, FlutterView.MessageResponse messageResponse) {

                        _response = messageResponse;

                        if (mediaPlayer != null && mediaPlayer.isPlaying()){
                            mediaPlayer.stop();
                            mediaPlayer = null;
                        }
                    }
                });
                */
    }
    /*
    private void resetVideo()
    {
      if(videoView !=null)
      {
        videoView.seekTo(0);
      }
    }*/
    @Override
    protected void onDestroy() {
        /*
        if (flutterView != null) {
            flutterView.destroy();
            System.out.println("pengyun still !null");
        }
        System.out.println("pengyun still null");
        */
        flutterView.destroy();
        //handler.removeCallbacks(run);
          super.onDestroy();
       // super.onDestroy();
    }

    @Override
    protected void onPause() {
        super.onPause();
        flutterView.onPause();
    }

    @Override
    protected void onPostResume() {
        super.onPostResume();
        flutterView.onPostResume();
    }


    @Override
    protected void onNewIntent(Intent intent) {
        // Reload the Flutter Dart code when the activity receives an intent
        // from the "flutter refresh" command.
        // This feature should only be enabled during development.  Use the
        // debuggable flag as an indicator that we are in development mode.
        if ((getApplicationInfo().flags & ApplicationInfo.FLAG_DEBUGGABLE) != 0) {
            if (Intent.ACTION_RUN.equals(intent.getAction())) {
                flutterView.runFromBundle(intent.getDataString(),
                        intent.getStringExtra("snapshot"));
            }
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        _response.send("{result:1}");
    }

}
