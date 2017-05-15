/**
*copyright 2017 Portus(Wuhan). All rights reserved.
*@Author: HipePeng
*@Date:   2017/05/11
*
*this file  In flutter applications to monitor android events,
*in flutter applications can invoke the native android interface and the SDK college
// but the file is the most difirence with mian.activity is about it load the all
*android native mefia lib
*
*/
package com.yourcompany.mobileapp;

import android.app.Activity;
import android.app.ProgressDialog;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.view.View;
import android.view.MotionEvent;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.util.Log;
import android.widget.MediaController;
import android.widget.VideoView;


public class VideoActivity extends Activity {
    ProgressDialog dialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_video);
        dialog = new ProgressDialog(VideoActivity.this);
        dialog.show();
    }

    @Override
    protected void onStart() {
        super.onStart();

        String url = this.getIntent().getDataString();
        Log.d("=> VIDEO =>", url);

        final VideoView videoView =
                (VideoView) findViewById(R.id.videoView1);

        videoView.setVideoPath(url);

        // MediaController mediaController = new MediaController(this);
        // mediaController.setAnchorView(videoView);
        // videoView.setMediaController(mediaController);

        // attach a mediacontroller
          MediaController mediaController = new MediaController(this);
          mediaController.setAnchorView(videoView);
        //mediaController.setVisibility(View.INVISIBLE);

          videoView.setMediaController(null);
          videoView.requestFocus();

          videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mp) {
                videoView.start();
                dialog.dismiss();
            }
        });
        videoView.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {

@Override
public void onCompletion(MediaPlayer videoView) {
// TODO Auto-generated method stub

videoView.start();
videoView.setLooping(true);
}
});

//add touch in videoview
videoView.setOnTouchListener(new OnTouchListener() {
  @Override
  public boolean onTouch(View v, MotionEvent event) {
    onDestroy();
    finish();
    return false;
  }
});

    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

}
