package com.ketkigrag.androidappbundles.main;

import com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener;

public interface MainContract {

    interface View {
        void displayProgressBar();

        void updateProgress(int progress, int maxProgress);

        void displayProgressText(String text);

        void displayButtons();

        void toastAndLog(String message);

        void launchActivity(String classPath);
    }

    interface Presenter {
        void loadAndLaunchModule1();

        void uninstallAllFeatures();

        void unregisterSplitManager(SplitInstallStateUpdatedListener splitInstallStateUpdatedListener);

        void registerSplitManager(SplitInstallStateUpdatedListener splitInstallStateUpdatedListener);
    }
}
