package com.ketkigrag.androidappbundles.ondemand;

import android.os.Bundle;
import com.ketkigrag.androidappbundles.BaseSplitActivity;

public class LaunchActivity extends BaseSplitActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_launch_feature2);
    }
}
