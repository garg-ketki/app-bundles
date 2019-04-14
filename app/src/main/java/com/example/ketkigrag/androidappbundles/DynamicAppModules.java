package com.example.ketkigrag.androidappbundles;

import android.content.Context;

import java.util.Arrays;
import java.util.List;

public class DynamicAppModules {

    private final List<String> modules;

    DynamicAppModules(Context context) {
        modules = Arrays.asList(context.getResources().getStringArray(R.array.dynamic_features));
    }

    public boolean isModuleExist(String moduleName) {
        return modules.contains(moduleName);
    }

    public String getModule1() {
        return modules.get(0);
    }
}
