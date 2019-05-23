**Run project with Gradle**
1. Apk
    - ./gradlew installDebug
    - It will install the debug app
    - Path to Debug apk: /app/build/outputs/apk/app-debug.apk

2. Aab
    - ./gradlew bundleDebug
    - It will create a the debug bundle
    - Path to Debug aar: /app/build/outputs/bundle/debug/app.aab

**Setup Buck project**
1. Follow instruction provided in https://github.com/uber/okbuck link
2. After applying the plugin, you will see okbuck tasks added. To verify run ./gradlew tasks
3. To create buck wrapper execute the task: ./gradlew :buckWrapper
    - This will generate BUCK file in app package
4. Execution of buck tasks will fail at multiple points: ./buckw build //app:bin_debug

    Error 1:
    ```
    > Task :app:okbuck FAILED
    
    FAILURE: Build failed with an exception.
    What went wrong:
    Execution failed for task ':app:okbuck'.
    > /Users/ketkigrag/.android/debug.keystore must be located inside /Users/ketkigrag/App_Bundles/AppBundlesProject
    
    Add signing configuration in app -> build.gradle and create a keystore
    ```
    Error 2:
    ```
    * What went wrong:
    Execution failed for task ':app:okbuck'.
    > Configuration with name 'buckLint_deps' not found.
    
    Add following code to main build.gradle
    okbuck {
            target = "android-$compileSdkVersion"
            buildToolVersion = "28.0.3"
    
            lint {
                disabled = true
            }
    }
   ```
   
**Run project with Buck**
1. Apk
    - ./buckw install //app:bin_debug
    - It will install the debug app
    - Path to Debug apk: /buck-out/gen/app/bin_debug.apk

2. Aab
    - Add custom rule
    - ./gradlew bundleDebug
    - It will create a the debug bundle
    - Path to Debug aar: /app/build/outputs/bundle/debug/app.aab

6. Create .aab file through buck
    
    extraDefs += project.file('buck-rules/BUNDLE_RULE')
    - Run command ./buckw build //app:bundle_debug

Issue1: Currently getting an error as expected:
'''
Buck encountered an internal error
 java.nio.file.FileAlreadyExistsException: buck-out/tmp/tempRes7375701694593264027.txt
         at sun.nio.fs.UnixException.translateToIOException(UnixException.java:88)
         at sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:102)
         at sun.nio.fs.UnixException.rethrowAsIOException(UnixException.java:107)
         at sun.nio.fs.UnixFileSystemProvider.newByteChannel(UnixFileSystemProvider.java:214)
         at com.facebook.buck.cli.bootstrapper.filesystem.BuckFileSystemProvider.newByteChannel(BuckFileSystemProvider.java:132)
         at java.nio.file.spi.FileSystemProvider.newOutputStream(FileSystemProvider.java:434)
         at java.nio.file.Files.newOutputStream(Files.java:216)
         at java.nio.file.Files.copy(Files.java:3016)
         at com.facebook.buck.android.AabBuilderStep.convertZipEntryToFile(AabBuilderStep.java:445)
         at com.facebook.buck.android.AabBuilderStep.packageFile(AabBuilderStep.java:431)
         at com.facebook.buck.android.AabBuilderStep.addModule(AabBuilderStep.java:190)
         at com.facebook.buck.android.AabBuilderStep.execute(AabBuilderStep.java:125)
         at com.facebook.buck.step.DefaultStepRunner.runStepForBuildTarget(DefaultStepRunner.java:45)
         ... 14 more

     When running <aab_builder>.
     When building rule //app:bundle_debug.
'''
This will happen because okBuck version 0.43.0 does not fix app bundles in BUCK
Issue 2: If I use latest okbuck version okbuckVersion = '0.47.1', it does not support extraDefs

7. Update okBuck to v0.47.1
-Replace extraDefs with ruleOverrides
ruleOverrides {
        override{
            nativeRuleName = "android_binary"
            importLocation = "//buck-rules:BUNDLE_RULE"
            newRuleName = "original_android_binary"
        }
    }
 - Issue1:
 BUILD FAILED: The rule //app:bundle_debug could not be found.
 Please check the spelling and whether it exists in /Users/ketkigrag/App_Bundles/AppBundlesProject/app/BUCK.

Replace with .bzl file (Add custom_android_binary.bzl file)
This will generate bundle in buck-out/gen/app/bundle_debug.apk directory

8. There is an issue with the file extension, bundle is showing .apk file. To fix it, add latest buck version in the code.
buckBinary = "com.github.facebook:buck:e1fec3196532dc58cf06461ac0f3020f63f570bc@pex"
This will generate bundle in buck-out/gen/app/bundle_debug.aab directory





