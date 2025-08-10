plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.medinoti"
    compileSdk = 35 // Cambiado a 35 para compatibilidad con plugins

    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.medinoti"
        minSdk = 23
        targetSdk = 35 // Cambiado a 35 para compatibilidad con plugins
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // Usa tu propia configuración de firma si tienes, si no usa debug
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
