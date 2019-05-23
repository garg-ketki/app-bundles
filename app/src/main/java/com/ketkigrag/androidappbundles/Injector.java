package com.ketkigrag.androidappbundles;

import android.content.Context;
import com.ketkigrag.androidappbundles.main.MainContract;
import com.ketkigrag.androidappbundles.main.MainPresenter;
import com.ketkigrag.androidappbundles.split_install_manager.MySplitInstallStateUpdatedListener;
import com.ketkigrag.androidappbundles.split_install_manager.SplitInstallManagerWrapper;
import com.google.android.play.core.splitinstall.SplitInstallManager;
import com.google.android.play.core.splitinstall.SplitInstallManagerFactory;
import com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener;

// Defines dependencies used in the app
public class Injector {

    private Injector() {
        throw new AssertionError("No object is allowed");
    }

    public static MainContract.Presenter providePresenter(MainContract.View view, Context context) {
        final SplitInstallManager splitInstallManager = provideSplitInstallManager(context);
        final SplitInstallManagerWrapper splitInstallManagerWrapper = provideSplitInstallManagerWrapper(splitInstallManager);
        final DynamicAppModules dynamicAppModules = provideDynamicAppModules(context);

        return providePresenter(view, splitInstallManagerWrapper, dynamicAppModules);
    }

    private static MainContract.Presenter providePresenter(MainContract.View view,
                                                   SplitInstallManagerWrapper splitInstallManagerWrapper,
                                                   DynamicAppModules dynamicAppModules) {
        return new MainPresenter(view, splitInstallManagerWrapper, dynamicAppModules);
    }

    private static SplitInstallManager provideSplitInstallManager(Context context) {
        return SplitInstallManagerFactory.create(context);
    }

    private static SplitInstallManagerWrapper provideSplitInstallManagerWrapper(SplitInstallManager splitInstallManager) {
        return new SplitInstallManagerWrapper(splitInstallManager);
    }

    private static DynamicAppModules provideDynamicAppModules(Context context) {
        return new DynamicAppModules(context);
    }

    public static SplitInstallStateUpdatedListener provideSplitInstallStateUpdatedListener(MySplitInstallStateUpdatedListener.Listener listener) {
        return new MySplitInstallStateUpdatedListener(listener);
    }
}
