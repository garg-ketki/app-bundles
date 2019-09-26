package com.ketkigrag.androidappbundles;

import android.os.Bundle;
import com.ketkigrag.androidappbundles.BaseSplitActivity;
import com.ketkigrag.androidappbundles.R;
import io.reactivex.Scheduler;
import io.reactivex.Observable;
import io.reactivex.android.plugins.RxAndroidPlugins;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;
import io.reactivex.android.schedulers.AndroidSchedulers;
import android.os.Looper;

import java.util.concurrent.Callable;

public class LaunchActivity extends BaseSplitActivity {

    Observable observable = Observable.just("A", "B", "C", "D", "E", "F");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_launch);
        System.out.println("observable: "+observable);
        final Scheduler asyncMainThreadScheduler = AndroidSchedulers.from(Looper.getMainLooper(), true);
        RxAndroidPlugins.setInitMainThreadSchedulerHandler(new Function<Callable<Scheduler>, Scheduler>() {
            @Override public Scheduler apply(Callable<Scheduler> schedulerCallable) throws Exception {
                return asyncMainThreadScheduler;
            }
        });
    }
}
