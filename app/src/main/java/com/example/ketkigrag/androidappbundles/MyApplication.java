package com.example.ketkigrag.androidappbundles;

import android.content.Context;
import com.google.android.play.core.splitcompat.SplitCompat;
import com.google.android.play.core.splitcompat.SplitCompatApplication;

public class MyApplication extends SplitCompatApplication {
    @Override
    protected void attachBaseContext(Context context) {
        super.attachBaseContext(context);
        SplitCompat.install(this);
    }
}
