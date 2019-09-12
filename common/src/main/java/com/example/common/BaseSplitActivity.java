package com.example.common;

import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import com.google.android.play.core.splitcompat.SplitCompat;

public class BaseSplitActivity extends AppCompatActivity {
  @Override
  protected void attachBaseContext(Context context) {
    super.attachBaseContext(context);
    SplitCompat.install(this);
  }
}
