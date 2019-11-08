package com.ketkigrag.androidappbundles.split_install_manager;

import android.util.Log;
import com.google.android.play.core.splitinstall.SplitInstallException;
import com.google.android.play.core.splitinstall.SplitInstallManager;
import com.google.android.play.core.splitinstall.SplitInstallRequest;
import com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener;
import com.google.android.play.core.tasks.OnCompleteListener;
import com.google.android.play.core.tasks.OnFailureListener;
import com.google.android.play.core.tasks.OnSuccessListener;
import com.google.android.play.core.tasks.Task;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SplitInstallManagerWrapper {

    private final SplitInstallManager splitInstallManager;
    private Listener listener;

    public SplitInstallManagerWrapper(SplitInstallManager splitInstallManager) {
        this.splitInstallManager = splitInstallManager;
    }

    public void loadAndLaunchModule(final String moduleName) {
        Log.v("ketki", "splitInstallManager.getInstalledModules(): " + splitInstallManager.getInstalledModules() + " moduleName: " + moduleName);
        if (splitInstallManager.getInstalledModules().contains(moduleName)) {
            listener.onModuleInstallSuccess(new ArrayList(Arrays.asList(moduleName)));
        } else {
            // Create request to install a feature module by name. Load and install the requested feature module.
            splitInstallManager.startInstall(SplitInstallRequest.newBuilder().addModule(moduleName).build())
                    .addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(Exception exception) {
                            listener.onModuleInstallationFailed(moduleName, getErrorMessage(moduleName, ((SplitInstallException) exception).getErrorCode()));
                        }
                    })
                    .addOnCompleteListener(new OnCompleteListener<Integer>() {
                        @Override
                        public void onComplete(Task<Integer> task) {
                        }
                    });

            listener.onModuleInstalling(moduleName, getInstallingMessage(moduleName));
        }
    }

    private String getInstallingMessage(String moduleName) {
        return "Starting installation for " + moduleName;
    }

    private String getErrorMessage(String moduleName, int errorCode) {
        return "Installation failed for : " + moduleName + " with error code: " + errorCode;
    }

    public void uninstallAllFeatures() {
        listener.onModulesUninstallingMessage("Requesting uninstall of all modules. This will happen at some point in the future.");
        final List<String> installedModules = new ArrayList<>(splitInstallManager.getInstalledModules());
        splitInstallManager.deferredUninstall(installedModules).addOnSuccessListener(new OnSuccessListener<Void>() {
            @Override
            public void onSuccess(Void aVoid) {
                listener.onModulesUninstallSuccess(getUninstallSuccessMessage(installedModules));
            }
        }).addOnFailureListener(new OnFailureListener() {
            @Override
            public void onFailure(Exception exception) {
                listener.onModuleUninstallFailure(getUninstallFailureMessage(exception, installedModules));
            }
        });
    }

    private String getUninstallFailureMessage(Exception exception, List<String> installedModules) {
        return "Failed installation of " + installedModules.toString() + " with ErrorMessage: " + exception.getMessage();
    }

    private String getUninstallSuccessMessage(List<String> installedModules) {
        return "Uninstalling " + installedModules.toString();
    }


    public void registerSplitInstallListener(SplitInstallStateUpdatedListener stateUpdatedListener) {
        splitInstallManager.registerListener(stateUpdatedListener);
    }

    public void unRegisterSplitInstallListener(SplitInstallStateUpdatedListener stateUpdatedListener) {
        splitInstallManager.unregisterListener(stateUpdatedListener);
    }

    public void setListener(Listener listener) {
        this.listener = listener;
    }

    public interface Listener {
        void onModuleInstallSuccess(List<String> moduleNames);

        void onModuleInstallationFailed(String moduleName, String message);

        void onModuleInstalling(String moduleName, String message);

        void onModulesUninstallingMessage(String message);

        void onModulesUninstallSuccess(String message);

        void onModuleUninstallFailure(String message);
    }
}
