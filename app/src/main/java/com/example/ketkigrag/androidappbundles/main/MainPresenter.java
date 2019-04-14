package com.example.ketkigrag.androidappbundles.main;

import com.example.ketkigrag.androidappbundles.DynamicAppModules;
import com.example.ketkigrag.androidappbundles.Injector;
import com.example.ketkigrag.androidappbundles.split_install_manager.MySplitInstallStateUpdatedListener;
import com.example.ketkigrag.androidappbundles.split_install_manager.SplitInstallManagerWrapper;
import com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener;

import static com.example.ketkigrag.androidappbundles.Constants.FEATURE1_CLASS_PATH;

public class MainPresenter implements MainContract.Presenter, SplitInstallManagerWrapper.Listener, MySplitInstallStateUpdatedListener.Listener {

    private final MainContract.View view;
    private final SplitInstallManagerWrapper splitInstallManagerWrapper;
    private final DynamicAppModules dynamicAppModules;
    private final SplitInstallStateUpdatedListener splitInstallStateUpdatedListener;

    public MainPresenter(MainContract.View view, SplitInstallManagerWrapper splitInstallManagerWrapper, DynamicAppModules dynamicAppModules) {
        this.view = view;
        this.splitInstallManagerWrapper = splitInstallManagerWrapper;
        this.dynamicAppModules = dynamicAppModules;
        this.splitInstallManagerWrapper.setListener(this);
        this.splitInstallStateUpdatedListener = Injector.provideSplitInstallStateUpdatedListener(this);
    }

    @Override
    public void onModuleInstallSuccess(String moduleName) {
        view.displayButtons();
        onSuccessfulLoad(moduleName);
    }

    @Override
    public void onModuleInstallationFailed(String moduleName, String message) {
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
    public void onPause() {
        splitInstallManagerWrapper.unRegisterSplitInstallListener(splitInstallStateUpdatedListener);
    }

    @Override
    public void onResume() {
        splitInstallManagerWrapper.registerSplitInstallListener(splitInstallStateUpdatedListener);
    }

    @Override
    public void uninstallAllFeatures() {
        splitInstallManagerWrapper.uninstallAllFeatures();
    }

    @Override
    public void onFailed(String moduleName, String message) {
        view.toastAndLog(message);
    }

    @Override
    public void onInstalling(String moduleName, int bytesDownloaded, int totalBytes, String message) {
        view.displayProgressBar();
        view.updateProgress(bytesDownloaded, totalBytes);
        view.displayProgressText(message);
    }

    @Override
    public void onInstalled(String moduleName) {
        onSuccessfulLoad(moduleName);
    }

    @Override
    public void onDownloading(String moduleName, int bytesDownloaded, int totalBytes, String message) {
        view.displayProgressBar();
        view.updateProgress(bytesDownloaded, totalBytes);
        view.displayProgressText(message);
    }

    private void onSuccessfulLoad(String moduleName) {
        if (dynamicAppModules.isModuleExist(moduleName)) {
            view.launchActivity(FEATURE1_CLASS_PATH);
        }
    }
}
