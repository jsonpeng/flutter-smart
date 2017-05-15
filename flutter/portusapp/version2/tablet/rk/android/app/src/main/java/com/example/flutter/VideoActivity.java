package com.example.flutter;

import android.app.Activity;
import android.app.ProgressDialog;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.util.Log;
import android.widget.MediaController;
import android.widget.VideoView;
import android.view.MotionEvent;

public class VideoActivity extends Activity {

    ProgressDialog dialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_video);

        dialog = new ProgressDialog(VideoActivity.this);
        //dialog.setMessage("Loading, Please Wait...");
        //dialog.setCancelable(true);
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
/*
videoView.start();
videoView.setLooping(true);
*/
onDestroy();
finish();
}
});



    }


    @Override
    protected void onDestroy() {

        super.onDestroy();
    }

}
