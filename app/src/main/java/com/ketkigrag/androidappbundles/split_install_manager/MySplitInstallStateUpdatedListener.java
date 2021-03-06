package com.ketkigrag.androidappbundles.split_install_manager;

import com.google.android.play.core.splitinstall.SplitInstallSessionState;
import com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener;
import com.google.android.play.core.splitinstall.model.SplitInstallSessionStatus;

import java.util.List;

public class MySplitInstallStateUpdatedListener implements SplitInstallStateUpdatedListener {

    private final Listener listener;

    public MySplitInstallStateUpdatedListener(MySplitInstallStateUpdatedListener.Listener listener) {
        this.listener = listener;
    }

    @Override
    public void onStateUpdate(SplitInstallSessionState splitInstallSessionState) {
        final List<String> moduleName = splitInstallSessionState.moduleNames();
        switch (splitInstallSessionState.status()) {
            case SplitInstallSessionStatus.DOWNLOADING:
                listener.onDownloading(moduleName, (int) splitInstallSessionState.bytesDownloaded(), (int) splitInstallSessionState.totalBytesToDownload(), "Downloading " + moduleName);
                break;
            case SplitInstallSessionStatus.INSTALLED:
                listener.onInstalled(moduleName);
                break;
            case SplitInstallSessionStatus.INSTALLING:
                listener.onInstalling(moduleName, (int) splitInstallSessionState.bytesDownloaded(), (int) splitInstallSessionState.totalBytesToDownload(), "Installing " + moduleName);
                break;
            case SplitInstallSessionStatus.FAILED:
                listener.onFailed(moduleName, "Installation failed for : " + moduleName);
                break;
        }
    }

    public interface Listener {

        void onFailed(List<String> moduleName, String message);

        void onInstalling(List<String> moduleName, int bytesDownloaded, int totalBytes, String message);

        void onInstalled(List<String> moduleName);

        void onDownloading(List<String> moduleName, int bytesDownloaded, int totalBytes, String message);
    }
}
