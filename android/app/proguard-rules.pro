# =====================
# Firebase
# =====================
-keepattributes Signature
-keepattributes *Annotation*
# Keep all Firebase classes (Core, Messaging, Analytics)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Firebase Messaging / Notifications
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase Core / Analytics
-keep class com.google.firebase.messaging.** { *; }
-keep class com.google.firebase.analytics.** { *; }

# =====================
# For Google Maps / Play Services
#-keep class com.google.android.gms.maps.** { *; }
#-keep class com.google.android.gms.location.** { *; }
#-dontwarn com.google.android.gms.**

# =====================
# Gson (used by Firebase)
# =====================
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**

# =====================
# Kotlin & Coroutines
# =====================
-keepclassmembers class kotlinx.coroutines.** { *; }
-dontwarn kotlinx.coroutines.**

# =====================
# UCrop For Image Cropper
#-keep class com.yalantis.ucrop.** { *; }
#-dontwarn com.yalantis.ucrop.**

# =====================
# Multidex Support
# =====================
-keep class androidx.multidex.** { *; }
-dontwarn androidx.multidex.**

# =====================
# Flutter / Generated Plugins
# =====================
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.plugin.**

# =====================
# Keep All Model Classes (Hive / JSON Models)
# =====================
-keep class com.asp.asp_chat.model.** { *; }

# =====================
# Keep Serializable classes (simple version)
# =====================
-keepclassmembers class ** implements *Parcelable {
    public static final *** CREATOR;
}

# =====================
# Optional: Keep All Flutter Generated Classes (like R)
# =====================
-keep class **.R$* { *; }
-dontwarn **.R$*


# Instead of *
-keep class com.asp.asp_chat.** implements java.io.Serializable { *; }
-keep class com.asp.asp_chat.** extends android.app.Application { *; }
-keep class com.asp.asp_chat.** extends android.app.Activity { *; }
-keep class com.asp.asp_chat.** extends android.app.Service { *; }
-keep class io.flutter.embedding.android.** { *; }
-keep class io.flutter.plugin.** { *; }



# =====================
# EGL / OpenGL / RenderThread (prevent GPU crashes)
# =====================
-keep class android.opengl.** { *; }
-keep class android.view.HardwareRenderer { *; }
-keep class android.graphics.HardwareRenderer$** { *; }
-keep class android.view.ThreadedRenderer { *; }
-keep class android.view.RenderNode { *; }
-dontwarn android.opengl.**
-keep class com.asp.asp_chat.BuildConfig { *; }


# =====================
# Keep native method names
# =====================
-keepclassmembers class * {
    native <methods>;
}

# Keep Flutter engine
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class com.google.firebase.** { *; }
-keep class io.flutter.embedding.engine.** { *; }



# =====================
# WebView (future safe)
# =====================
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(...);
}
-keepclassmembers class * extends android.webkit.WebChromeClient {
    public void *(...);
}