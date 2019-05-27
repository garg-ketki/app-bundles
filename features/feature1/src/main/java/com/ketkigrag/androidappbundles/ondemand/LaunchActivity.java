package com.ketkigrag.androidappbundles.ondemand;

import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import com.google.android.play.core.splitcompat.SplitCompat;

import android.os.Bundle;

public class LaunchActivity extends AppCompatActivity {

    @Override
    protected void attachBaseContext(Context context) {
        super.attachBaseContext(context);
        SplitCompat.install(this);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_launch);
    }
}
