# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Dart/Flutter specific
-dontwarn io.flutter.embedding.engine.FlutterJNI
-dontwarn io.flutter.embedding.engine.dart.DartExecutor

# Keep names for reflection
-keepattributes Signature
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Google services / Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# AdMob
-keep class com.google.android.gms.ads.** { *; }

# Gson
-keep class com.google.gson.** { *; }

# OkHttp/Retrofit/Dio
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keep class retrofit2.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# uCrop (image cropper) - uses OkHttp internally
-keep class com.yalantis.ucrop.** { *; }

# Keep JSON serialization (freezed/json_serializable)
-keep class * implements com.google.gson.JsonSerializer { *; }
-keep class * implements com.google.gson.JsonDeserializer { *; }
-keep class * implements com.google.gson.TypeAdapterFactory { *; }

# Room/SQLite
-keep class androidx.room.** { *; }
-keep class * extends androidx.room.RoomDatabase { *; }

# Prevent obfuscation of @Keep annotations
-keep @androidx.annotation.Keep class * { *; }
-keepclassmembers class * { @androidx.annotation.Keep *; }

# Enum
-keepclassmembers enum * { *; }

# ProGuard optimization
-optimizations !code/simplification/arithmetic

# Don't warn about missing classes (common with Flutter)
-dontwarn io.flutter.**
-dontwarn org.xmlpull.v1.**
-dontwarn okio.**
-dontwarn java.nio.file.**
-dontwarn java.nio.channels.**
-dontwarn java.util.concurrent.**