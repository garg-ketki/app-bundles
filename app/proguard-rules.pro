# This is the global proguard config with sane defaults for uberlite.
## It will be remerged with monorepo proguard once other apps stop using kryo. ##
## Check https://code.uberinternal.com/T1819137 for remerge strategy. ##

## --------------- Start Android Settings --------------- ##

-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers
-dontpreverify
-dontnote **

-allowaccessmodification
-keepattributes *Annotation*
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
-repackageclasses ''
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5

-keepnames public class * extends android.app.Activity
-keepnames public class * extends android.app.Application
-keepnames public class * extends android.app.Service
-keepnames public class * extends android.content.BroadcastReceiver
-keepnames public class * extends android.content.ContentProvider
-keepnames public class * extends android.app.backup.BackupAgentHelper
-keepnames public class * extends android.preference.Preference
-keepnames public class com.android.vending.licensing.ILicensingService
-dontnote com.android.vending.licensing.ILicensingService

# Explicitly preserve all serialization members. The Serializable interface
# is only a marker interface, so it wouldn't save them.
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Preserve all native method names and the names of their classes.
-keepclasseswithmembernames class * {
    native <methods>;
}


# Keep constructors of all custom views
-keepclassmembers class * extends android.view.View {
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

-keepclasseswithmembernames class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembernames class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# Preserve static fields of inner classes of R classes that might be accessed
# through introspection.
-keepclassmembers class **.R$* {
  public static <fields>;
}

# Preserve the special static methods that are required in all enumeration classes.
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Preserve Parcelable classes
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Preserve Javascript Interfaces
-keepclassmembers class * { @android.webkit.JavascriptInterface <methods>; }
-keepattributes JavascriptInterface

## ---------------- End Android Settings ---------------- ##


## ---------------- Start Third Party Library Settings ---------------- ##

# Auto
-dontwarn com.google.auto.value.AutoValue
-dontwarn com.google.auto.value.AutoValue$Builder

# Adjust
-keep class com.adjust.sdk.** { *; }
-keep class com.google.android.gms.ads.identifier.** { *; }
-keep class com.google.android.gms.net.** { *; }

# Apache Commons Math
-dontwarn java.awt.geom.**

# AWS SDK
-keepnames class com.amazonaws.**
-keepnames class com.amazon.**
-keep class com.amazonaws.services.**.*Handler
-dontwarn com.fasterxml.jackson.**
-dontwarn org.apache.commons.logging.**
-dontwarn org.apache.http.**
-dontwarn com.amazonaws.http.**
-dontwarn com.amazonaws.metrics.**

# Braintree
-keep class com.braintree.** {*; }
-keep class com.braintreegateway.** {*; }

# Calligraphy
-dontwarn io.github.inflationx.calligraphy3.**
-dontwarn io.github.inflationx.calligraphy3.**
-dontwarn io.github.inflationx.viewpump.ViewPumpContextWrapper

# Card.io
-keep class io.card.payment.DetectionInfo
-keep class io.card.payment.CreditCard
-keep class io.card.payment.CreditCard$1
-keepclassmembers class io.card.payment.CreditCard { *; }
-keepclassmembers class io.card.payment.DetectionInfo { public *; }
-keepclassmembers class io.card.payment.CardScanner { *** onEdgeUpdate(...); }

# Checker Framework
-dontwarn **org.checkerframework.**

# Crashlytics
-keep class com.crashlytics.** { *; }

## ---------------- Start CrashOnErrorObserver Settings ----------------##

# We keep these in order for CrashOnErrorObservers to properly work and resolve entries in each of these packages
-keepnames class com.ubercab.rx2.java.**
-keepnames class io.reactivex.**
-keepnames class com.uber.autodispose.**

## ----------------- End CrashOnErrorObserver Settings -----------------##

## ---------------- Start Chromium ----------------##

# Keep the annotations, because if we don't, the ProGuard rules that use them
# will not be respected. These classes then show up in our final dex, which we
# do not want - see crbug.com/628226.
-keep @interface org.chromium.base.annotations.AccessedByNative
-keep @interface org.chromium.base.annotations.CalledByNative
-keep @interface org.chromium.base.annotations.CalledByNativeUnchecked
-keep @interface org.chromium.base.annotations.RemovableInRelease
-keep @interface org.chromium.base.annotations.UsedByReflection
# Keeps for class level annotations.
-keep @org.chromium.base.annotations.UsedByReflection class *
# Keeps for method level annotations.
-keepclasseswithmembers class * {
  @org.chromium.base.annotations.AccessedByNative <fields>;
}
-keepclasseswithmembers,includedescriptorclasses class * {
  @org.chromium.base.annotations.CalledByNative <methods>;
}
-keepclasseswithmembers,includedescriptorclasses class * {
  @org.chromium.base.annotations.CalledByNativeUnchecked <methods>;
}
-keepclasseswithmembers class * {
  @org.chromium.base.annotations.UsedByReflection <methods>;
}
-keepclasseswithmembers class * {
  @org.chromium.base.annotations.UsedByReflection <fields>;
}
-keepclasseswithmembers,includedescriptorclasses class * {
  native <methods>;
}
# Remove methods annotated with this if their return value is unused.
-assumenosideeffects class ** {
  @org.chromium.base.annotations.RemovableInRelease <methods>;
}

## ---------------- End Chromium ----------------##

## ---------------- Start Cronet ----------------##

# This constructor is called using the reflection from Cronet API (cronet_api.jar).
-keep class org.chromium.net.impl.NativeCronetProvider {
    public <init>(android.content.Context);
}

# Suppress unnecessary warnings.
-dontnote org.chromium.net.ProxyChangeListener$ProxyReceiver
-dontnote org.chromium.net.AndroidKeyStore
# Needs 'void setTextAppearance(int)' (API level 23).
-dontwarn org.chromium.base.ApiCompatibilityUtils
# Needs 'boolean onSearchRequested(android.view.SearchEvent)' (API level 23).
-dontwarn org.chromium.base.WindowCallbackWrapper

# Generated for chrome apk and not included into cronet.
-dontwarn org.chromium.base.BuildConfig
-dontwarn org.chromium.base.library_loader.NativeLibraries
-dontwarn org.chromium.base.multidex.ChromiumMultiDexInstaller

# Objects of this type are passed around by native code, but the class
# is never used directly by native code. Since the class is not loaded, it does
# not need to be preserved as an entry point.
-dontnote org.chromium.net.UrlRequest$ResponseHeadersMap
# https://android.googlesource.com/platform/sdk/+/marshmallow-mr1-release/files/proguard-android.txt#54
-dontwarn android.support.**

## ---------------- End Cronet ----------------##

# Dagger
-dontwarn dagger.internal.codegen.**
-dontwarn dagger.internal.Factory
-dontwarn dagger.shaded.auto.common.**
-dontwarn com.squareup.haha.**

# Datami
-dontwarn com.datami.**
-keep,allowshrinking class com.datami.** { *; }

# DotsTextView animation
-keep public class com.ubercab.chatui.waitingdots.DotsTextView {
    void set*(***);
    *** get*();
}
-keep public class com.ubercab.chatui.waitingdots.JumpingSpan {
    void set*(***);
    *** get*();
}

# Duktape
-keep class com.squareup.duktape.DuktapeException { *; }
-keep class com.squareup.duktape.Duktape { private static int getLocalTimeZoneOffset(double); }

# ErrorProne
-dontwarn com.google.errorprone.annotations.**
-dontwarn com.uber.errorprone.annotations.**

# Exoplayer
-keep class com.devbrackets.android.exomedia.** { *; }
-keep class com.google.android.exoplayer.metadata.** { *; }
-dontwarn com.google.android.exoplayer.metadata.**

# gRPC
-keepnames class io.grpc.internal.GrpcUtil
-dontwarn com.google.common.**

##---------------Begin: Gson  ----------

# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-keep class com.google.gson.stream.** { *; }

# Prevent proguard from stripping interface information from TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer
-keep class * extends com.google.gson.TypeAdapter {
   public <init>(com.google.gson.Gson);
}

# Legacy Uber Gson configuration.
-keepattributes EnclosingMethod
-dontwarn sun.misc.**

##---------------End: Gson  ------------

# InAuth
-keep class com.security.** { *; }

# J2Objc
-dontwarn com.google.j2objc.annotations.**

# Javax
-dontwarn javax.annotation.**

# Kryo
-keepnames class java.beans.** { *; }
-keepnames class sun.reflect.** { *; }
-keepnames class sun.nio.** { *; }
-keepnames class com.ubercab.keyvaluestore.core.*PrimitiveCollection
-keepnames @com.uber.rave.annotation.Validated class ** { *; }
-keep class com.esotericsoftware.** { *; }
-dontwarn sun.nio.**
-dontwarn sun.reflect.**
-dontwarn java.beans.**

# MPAndroidChart
-keep class com.github.mikephil.charting.** { *; }

# Moshi
-dontwarn okio.**
-dontwarn javax.annotation.**
-keepclasseswithmembers class * {
    @com.squareup.moshi.* <methods>;
}
-keep @com.squareup.moshi.JsonQualifier interface *

# Now
-keep class com.google.android.now.** { *; }

# OkHttp
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.squareup.okhttp.** { *; }
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**

# Okio
-dontwarn java.nio.file.*
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
-dontwarn okio.**

# Parse (Used by Metro App)
-keepnames class com.parse.** { *; }
-dontwarn com.parse.ParseApacheHttpClient**
-dontwarn com.parse.NotificationCompat**

# PayPal
-keep class com.paypal.android.sdk.*** { *; }
-keep interface com.paypal.android.sdk.*** { *; }

# PayU
-keepclassmembers class com.payu.custombrowser.** { *; }
-keep public class com.ketkigrag.androidappbundles.main.MainActivity
-keep public class * implements com.payu.sdk.ProcessPaymentActivity$PayUJavaScriptInterface

# Pusher
-dontwarn org.slf4j.**

# Enabling Protobuf Proguarding T2630603
#-keep class com.google.protobuf.** { *; }
#-keep public class * extends com.google.protobuf.** { *; }

# Retrofit
-keep class com.squareup.okhttp.** { *; }
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**
-dontwarn retrofit.**
-dontwarn okio.**
-keep class retrofit.** { *; }
-keepclasseswithmembers class * { @retrofit.http.* <methods>; }

# Retrofit 2
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions
-keepclasseswithmembers class * {
    @retrofit2.http.* <methods>;
}
-keepclassmembernames interface * {
    @retrofit.http.* <methods>;
}

# OkHttp 3
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
# A resource is loaded with a relative path so the package of this class must be preserved.
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase

# Retrolambda
-dontwarn java.lang.invoke.*
-dontwarn **$$Lambda$*

# RxJava
-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
   long producerIndex;
   long consumerIndex;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
   long producerNode;
   long consumerNode;
}

-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode producerNode;
}
-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode consumerNode;
}

# SnappyDB
-keep class com.snappydb.** { *; }

# Spotify
-keep class com.spotify.sdk.android.** { *; }

# Support Annotations
-dontwarn android.support.annotation.RequiresApi
-dontwarn android.support.annotation.Keep
-keep class android.support.annotation.Keep
-keep @android.support.annotation.Keep class *
-keep @android.support.annotation.Keep enum * {
    *;
}
-dontwarn androidx.annotation.RequiresApi
-dontwarn androidx.annotation.Keep
-keep class androidx.annotation.Keep
-keep @androidx.annotation.Keep class *
-keep @androidx.annotation.Keep enum * {
    *;
}

-keepclassmembers class * {
    @android.support.annotation.Keep *;
}
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# Support Library
-keep class * extends android.support.design.widget.CoordinatorLayout$Behavior { *; }
-keep class android.support.v7.widget.SearchView { *; }
-keep public class * extends android.support.v7.widget.SearchView { *; }
-keep class * extends androidx.coordinatorlayout.widget.CoordinatorLayout$Behavior { *; }
-keep class androidx.appcompat.widget.SearchView { *; }
-keep public class * extends androidx.appcompat.widget.SearchView { *; }

# Support V4
-keep class android.support.v4.widget.ViewDragHelper { *; }
-keepnames class android.support.v4.widget.ViewDragHelper { *; }
-keepnames class android.support.v4.util.ArrayMap
-keepnames class android.support.v4.util.Pair
-dontwarn android.support.v4.**
-keep class androidx.customview.widget.ViewDragHelper { *; }
-keepnames class androidx.customview.widget.ViewDragHelper { *; }
-keepnames class androidx.collection.ArrayMap
-keepnames class androidx.core.util.Pair

# Thrift
-keep class org.apache.thrift.EncodingUtils
-keep class org.apache.thrift.TDSerializer
-keep class org.apache.thrift.TException
-keep class org.apache.thrift.TSerializer
-keep class org.apache.thrift.protocol.** { *; }
-keep class org.apache.thrift.scheme** { *; }
-dontwarn org.apache.http.**
-dontwarn org.apache.thrift.**
-dontwarn org.slf4j.**

# Twilio Programmable Voice
-keep class com.twilio.** { *; }

# UPI
-keep class org.apache.xml.security.** {*;}
-keep interface org.apache.xml.security.** {*;}
-keep class org.npci.** {*;}
-keep interface org.npci.** {*;}
-keep class com.axis.axismerchantsdk.** {*;}
-keep interface com.axis.axismerchantsdk.** {*;}
-dontwarn com.axis.axismerchantsdk.**
-dontwarn org.apache.xml.security.**
-keep class in.juspay.mystique.** {*;}
-keep interface in.juspay.mystique.** {*;}
-keep class in.org.npci.** {*;}
-keep interface in.org.npci.** {*;}
-dontwarn in.org.npci.**

# Safe browser
-keep,allowshrinking class in.juspay.godel.** {*;}

## ---------------- End Third Party Library Settings ---------------- ##


## ---------------- Start Uber Library Settings ---------------- ##

# Experiments
-keepclassmembers class * implements com.ubercab.experiment.analytics.ExperimentName {
    <fields>;
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Deferrable client
-keep @com.uber.network.deferred.core.annotation.Deferrable class *
-keep class com.uber.network.deferred.core.DelayTolerance { *; }

# Gps Imu Fusion
-keepnames class com.uber.snp.gps_imu_fusion.** implements java.io.Serializable
-keepclassmembers class com.uber.snp.gps_imu_fusion.** implements java.io.Serializable {
    !static !transient <fields>;
}

# Payments
-keepnames class **$LinuxPRNGSecureRandomProvider { *; }

# Presidio
-dontwarn com.ubercab.presidio.**$RequestCode

# Rave
-keep class **.rave.BaseValidator { *; }
-keep class * extends **.rave.BaseValidator { *; }
-keep class * implements **.rave.ValidatorFactory { *; }

# Shape
-keep class com.ubercab.shape.Shape
-dontwarn com.fasterxml.jackson.**

# Storage
-dontwarn com.ubercab.storage.KeyValueStorable

# Synapse
-dontwarn com.uber.synapse.annotations.**

# Thrift generated models
-keepnames class com.uber.model.core.generated.** { *; }

# Ui Deprecated
-dontwarn com.ubercab.ui.ValidatedTextView

# Utils
-keepnames class com.ubercab.android.util.ArraySet
-keepclassmembers class ** {
    @com.ubercab.android.util.preferences.OnPreferenceChange *;
}
-keepclassmembers class ** {
    @com.ubercab.android.util.preferences.OnPreferenceClick *;
}

## ---------------- End Uber Library Settings ---------------- ##


## ---------------- Start Uber App General Settings ---------------- ##

# BuildConfig
-keep class com.ubercab.**.BuildConfig { *; }

# Keep classes that interact with Gson
-keepnames class com.uber**model**  { *; }
-keepnames class com.ubercab**model**  { *; }
-keepnames class com.ubercab**realtime.error.** { *; }
-keepnames class com.ubercab**realtime.object.** { *; }
-keepnames class com.ubercab**realtime.request.** { *; }
-keepnames class com.ubercab**realtime.response.** { *; }
-keepnames class com.uber**model**  { *; }
-keepnames class com.ubercab**model**  { *; }

# Keep String type for Union Thrift type
-keepclassmembers class com.uber**model** { protected java.lang.String type; }

# Keep constructors of all Error classes
-keepclassmembers class * extends com.uber.presidio.realtime.core.error.Error {
  public <init>(java.lang.String, java.lang.Object);
}

-keepclassmembers class * extends com.uber.presidio.realtime.core.legacy.error.Error {
  public <init>(java.lang.String, java.lang.Object);
}

# keep models with shape
-keep @com.ubercab.shape.Shape class *
-keep class **Shape_** { *; }

# keep models with autovalue
-keep @com.google.auto.value.AutoValue class *
-keep class **AutoValue_** { *; }

# Keep app config enum class names
-keepclasseswithmembernames class com.ubercab.**AppConfigKey*

# For proguard issues related to gms 9.6.1 and com.ubercab.network.http
-dontwarn android.support.customtabs.**
-dontwarn androidx.browser.customtabs.**
-dontwarn javax.lang.model.element.Modifier

# Misc
-dontwarn com.kount.**
-dontwarn com.google.android.gms.common.internal.**
-dontwarn com.ubercab.android.map.**
-dontwarn com.ubercab.geo.**

## ---------------- End Uber App General Settings ---------------- ##


## ---------------- Start Uber Rider Settings ---------------- ##

# Cached shorcuts item
-keep class com.ubercab.presidio.accelerators.accelerators_core.CachedShorcuts
-keep class com.ubercab.presidio.accelerators.accelerators_core.CachedShortcutsItem

# Pending rating item
-keep class org.threeten.bp.DayOfWeek { *; }

# All strings that reference class names should be treated as class names inside this file.
# This allows us to use hardcoded strings to reflectively load classes.
-adaptclassstrings com.ubercab.confirmation_class_loader.ConfirmationClassLoader

## ---------------- End Uber Rider Settings ---------------- ##


## ---------------- Start Uber Partner Settings ---------------- ##

# Custom views that use ObjectAnimator
-keep class com.ubercab.driver.core.pulse.PulseView {
  void set*(***);
  *** get*();
}
-keep class com.ubercab.driver.core.pulse.PulseView$PulseCircleView {
  void set*(***);
  *** get*();
}
-keep class com.ubercab.driver.feature.main.goonline.GoOnlineTextSwitcher {
  void set*(***);
  *** get*();
}
-keep class com.ubercab.driver.feature.main.view.OnlineButtonWithLoading {
  void set*(***);
  *** get*();
}
-keep class com.ubercab.driver.feature.navigation.NavigationView {
  void set*(***);
  *** get*();
}
-keep class com.ubercab.driver.feature.online.DispatchedView {
  void set*(***);
  *** get*();
}
-keep class com.ubercab.driver.feature.online.AddedToRouteView {
  void set*(***);
  *** get*();
}
-keep class * extends com.ubercab.driver.feature.online.toolbar.ExpandableView {
  void set*(***);
  *** get*();
}


## ---------------- End Uber Partner Settings ---------------- ##

## ---------------- Start Style Guide Settings ----------------##

# Flipper
-dontwarn android.text.StaticLayout
-dontwarn android.view.DisplayList
-dontwarn android.view.RenderNode
-dontwarn android.view.DisplayListCanvas
-dontwarn android.view.HardwareCanvas
-dontwarn com.facebook.fbui.**
-dontwarn com.facebook.infer.annotation.**
-dontwarn com.facebook.litho.**
-dontwarn com.facebook.litho.annotations.**
-dontwarn com.facebook.proguard.annotations.**
-dontwarn org.mozilla.javascript.tools.**

## ----------------- End Style Guide Settings -----------------##

## ---------------- Start uCam Settings ----------------##

-keepnames class * implements com.ubercab.ucam.filters.base.Inference
-keep class * extends com.ubercab.ucam.filters.base.InferenceFilter {
  public <init>(com.ubercab.ucam.filters.base.UcamFilterDependencies);
}

-keep class com.uber.vide09.android.common.ImageUtils {
  native <methods>;
}
-keep class com.uber.vide09.tracker.basic.ObjectTracker {
  long nativeObjectTracker;
  native <methods>;
}
-keep class com.uber.vide09.tensorflow.RunStats {
  long nativeHandle;
  native <methods>;
}
-keep class com.uber.vide09.tracker.OpticalFlowTracker {
  long nativeOpticalFlowTracker;
  native <methods>;
}
# Snapdragon Neural Processing Engine
-keep class com.qualcomm.qti.snpe.** { *; }

## ----------------- End uCam Settings -----------------##

## ---------------- Start uTrek Settings ----------------##

-keep class com.uber.wni.netsim.SimulationConfig { *; }

-keep class com.jcraft.jsch.jce.*
-keep class * extends com.jcraft.jsch.KeyExchange
-keep class com.jcraft.jsch.**
-keep interface com.jcraft.jsch.**
-dontwarn org.ietf.jgss.*
-dontwarn com.jcraft.jzlib.ZStream

## ----------------- End uTrek Settings -----------------##

## ---------------- Start Kryo Outage Settings ----------------##
-applymapping proguard.map
## ----------------- End Kryo Outage Settings -----------------##

## ---------------- Start ATG RCA Settings ----------------##

-dontwarn javax.mail.**
-dontwarn com.ubercab.shape.**
-dontwarn javax.naming.**

## ----------------- End ATG RCA Settings -----------------##

## ---------------- Start ATG FSCA Settings ----------------##

-dontwarn javax.mail.**
-dontwarn com.ubercab.shape.**
-dontwarn javax.naming.**

## ----------------- End ATG FSCA Settings -----------------##

# javax-extras annotations, which are always provided and only class-retained for static analysis
-dontwarn com.uber.javaxextras.**

## ---------------- Start Screenflow components ----------------##
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature
# Gson specific classes
-keep class sun.misc.Unsafe { *; }
# Application classes that will be serialized/deserialized over Gson
-keep class com.ubercab.uberlitecomponents.** { *; }
## ----------------  End Screenflow components  ----------------##
