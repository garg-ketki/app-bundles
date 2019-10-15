package com.ketkigrag.androidappbundles.main;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;
import com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener;
import com.ketkigrag.androidappbundles.BaseSplitActivity;
import com.ketkigrag.androidappbundles.BuildConfig;
import com.ketkigrag.androidappbundles.Injector;
import com.ketkigrag.androidappbundles.R;
import com.ketkigrag.androidappbundles.split_install_manager.MySplitInstallStateUpdatedListener.Listener;

public class MainActivity extends BaseSplitActivity implements MainContract.View {

    private static final String TAG = MainActivity.class.getSimpleName();
    private View instructionsView, dynamicFeature1View, uninstallDynamicFeaturesView;
    private ProgressBar progressBar;
    private TextView progressTextView;
    private MainContract.Presenter presenter;
    private SplitInstallStateUpdatedListener splitInstallStateUpdatedListener;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        initialize();
    }

    private void initialize() {
        presenter = Injector.providePresenter(this, this);
        splitInstallStateUpdatedListener = Injector.provideSplitInstallStateUpdatedListener(this, (Listener) presenter);

        //initialize Views
        instructionsView = findViewById(R.id.tv_instructions);
        dynamicFeature1View = findViewById(R.id.btn_load_feature1);
        uninstallDynamicFeaturesView = findViewById(R.id.btn_uninstall_features);
        progressBar = findViewById(R.id.progress_bar);
        progressTextView = findViewById(R.id.progress_text);

        initializeClickListeners();
    }

    private void initializeClickListeners() {
        dynamicFeature1View.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                presenter.loadAndLaunchModule1();
            }
        });

        uninstallDynamicFeaturesView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                presenter.uninstallAllFeatures();
            }
        });
    }

    @Override
    public void toastAndLog(String message) {
        Log.v(TAG, message);
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void launchActivity(String className) {
      Intent intent = new Intent();
      intent.setClassName(BuildConfig.APPLICATION_ID, className);
      startActivity(intent);
    }

    @Override
    protected void onPause() {
        super.onPause();
        presenter.unregisterSplitManager(splitInstallStateUpdatedListener);
    }

    @Override
    protected void onResume() {
        super.onResume();
        presenter.registerSplitManager(splitInstallStateUpdatedListener);
    }

    @Override
    public void updateProgress(int progress, int maxProgress) {
        progressBar.setProgress(progress);
        progressBar.setMax(maxProgress);
    }

    @Override
    public void displayProgressText(String text) {
        progressTextView.setText(text);
    }

    @Override
    public void displayProgressBar() {
        progressBar.setVisibility(View.VISIBLE);
        progressTextView.setVisibility(View.VISIBLE);

        instructionsView.setVisibility(View.GONE);
        dynamicFeature1View.setVisibility(View.GONE);
        uninstallDynamicFeaturesView.setVisibility(View.GONE);
    }

    @Override
    public void displayButtons() {
        instructionsView.setVisibility(View.VISIBLE);
        dynamicFeature1View.setVisibility(View.VISIBLE);
        uninstallDynamicFeaturesView.setVisibility(View.VISIBLE);

        progressBar.setVisibility(View.GONE);
        progressTextView.setVisibility(View.GONE);
    }
}
