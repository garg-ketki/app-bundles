package com.example.ketkigrag.androidappbundles.main;

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

        void onPause();

        void onResume();

        void uninstallAllFeatures();
    }
}
