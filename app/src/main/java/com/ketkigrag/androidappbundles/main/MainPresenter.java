package com.ketkigrag.androidappbundles.main;

import com.ketkigrag.androidappbundles.DynamicAppModules;
import com.ketkigrag.androidappbundles.split_install_manager.MySplitInstallStateUpdatedListener;
import com.ketkigrag.androidappbundles.split_install_manager.SplitInstallManagerWrapper;
import com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener;

import java.util.ArrayList;
import java.util.List;

import static com.ketkigrag.androidappbundles.Constants.FEATURE1_CLASS_PATH;

public class MainPresenter implements MainContract.Presenter, SplitInstallManagerWrapper.Listener, MySplitInstallStateUpdatedListener.Listener {

    private final MainContract.View view;
    private final SplitInstallManagerWrapper splitInstallManagerWrapper;
    private final DynamicAppModules dynamicAppModules;

    public MainPresenter(MainContract.View view, SplitInstallManagerWrapper splitInstallManagerWrapper, DynamicAppModules dynamicAppModules) {
        this.view = view;
        this.splitInstallManagerWrapper = splitInstallManagerWrapper;
        this.dynamicAppModules = dynamicAppModules;
        this.splitInstallManagerWrapper.setListener(this);
    }

    @Override
    public void onModuleInstallSuccess(List<String> moduleNames) {
        view.displayButtons();
        onSuccessfulLoad(moduleNames);
    }

    @Override
    public void onModuleInstallationFailed(String moduleName, String message) {
        view.displayButtons();
        view.toastAndLog(message);
    }

    @Override
    public void onModuleInstalling(String moduleName, String message) {
        view.displayProgressBar();
        view.displayProgressText(message);
    }

    @Override
    public void onModulesUninstallingMessage(String message) {
        view.toastAndLog(message);
    }

    @Override
    public void onModulesUninstallSuccess(String message) {
        view.toastAndLog(message);
    }

    @Override
    public void onModuleUninstallFailure(String message) {
        view.toastAndLog(message);
    }

    @Override
    public void loadAndLaunchModule1() {
        splitInstallManagerWrapper.loadAndLaunchModule(dynamicAppModules.getModule1());
    }

    @Override
    public void uninstallAllFeatures() {
        splitInstallManagerWrapper.uninstallAllFeatures();
    }

    @Override
    public void unregisterSplitManager(SplitInstallStateUpdatedListener splitInstallStateUpdatedListener) {
        splitInstallManagerWrapper.unRegisterSplitInstallListener(splitInstallStateUpdatedListener);
    }

    @Override
    public void registerSplitManager(SplitInstallStateUpdatedListener splitInstallStateUpdatedListener) {
        splitInstallManagerWrapper.registerSplitInstallListener(splitInstallStateUpdatedListener);
    }

    @Override
    public void onFailed(List<String> moduleName, String message) {
        view.toastAndLog(message);
    }

    @Override
    public void onInstalling(List<String> moduleName, int bytesDownloaded, int totalBytes, String message) {
        view.displayProgressBar();
        view.updateProgress(bytesDownloaded, totalBytes);
        view.displayProgressText(message);
    }

    @Override
    public void onInstalled(List<String> moduleNames) {
        onModuleInstallSuccess(moduleNames);
    }

    @Override
    public void onDownloading(List<String> moduleName, int bytesDownloaded, int totalBytes, String message) {
        view.displayProgressBar();
        view.updateProgress(bytesDownloaded, totalBytes);
        view.displayProgressText(message);
    }

    private void onSuccessfulLoad(List<String> moduleName) {
        if (moduleName.contains(dynamicAppModules.getModule1())) {
            view.launchActivity(FEATURE1_CLASS_PATH);
        }
    }
}
