# Elaros Mobile Wellbeing App

Professional Software Projects Group 3 Elaros Wellbeing app. A Flutter app written with Dart.

## Introduction

This is a POC Mobile personal wellbeing app designed primarily for android devices. This app allows the user to get an overview of their health data which has been collected by a wearable device (such as a Fitbit).
This app makes use of several dependencies which may be found [here](#Libraries/Frameworks Documentation). When we built this we made use of the Model-View-ViewModel (MVVM) architecture pattern described [here[docs.flutter]](https://docs.flutter.dev/app-architecture/concepts) and [here[wikipedia]](https://en.wikipedia.org/wiki/Model–view–viewmodel) and attempted to follow it closely to allow for this to be a maintainable and scalable project as we all collaborated on it.

The apps code is located in the lib folder and the assets folder contains the database file which is used to store the user's health data.

Below are some screenshots of the app in action aswell as a link to a youtube video of the app.

[The Apps Youtube Video](https://img.youtube.com/vi/y6yEphzdNWw/0.jpg)

The Apps Home Page

![Home Page](https://i.gyazo.com/f9a244e41abc24e6c147a0529724e047.png)

The Step Count Insights Page

![The step count insights page](https://i.gyazo.com/c4c0b46cc9466ca35e93c24624403582.png)

The Heart Rate Zones Modal

![Heart Rate Zones Modal](https://i.gyazo.com/4e5242a8cc647aec209e6dd6a35a50f2.png)

The Project Wireframes

![Project Wireframes](https://i.gyazo.com/7a47722eca2554057981675bc19a30ee.png)

## Installation

Note: Currently the app does not support the ingestion of live data due to that being out of scope. Due to this a sample database comes preloaded with the app making use of opensource health data which was collected from Fitbit users.

the database file 'main.db' is located in a seperate google drive as it was too large for github to handle.
please download the file and place it in the /assets/database folder of the project under the name 'main.db'

1. Run locally on an emulator (Requires Android Studio)
   1. Cone this repository to your machine
   2. Open a new terminal within the newly made directory
   3. Run the command below to get the dependencies for the project.
      ```bash
      flutter pub get
      ```
   4. Start up your emulator and select an android device
   5. Once the device has loaded run the command below to ensure its connected
      ```bash
      flutter devices
      ```
   6. Run the command below to load the app onto the device and start it up
      ```bash
      flutter run
      ```

2. Run natively on an android device from an APK
   1. Clone this repository to your machine
   2. Open a new terminal within the newly made directory
   3. Run the command below to get the dependencies for the project.
      ```bash
      flutter pub get
      ```
   4. Run the command below to build the APK in debug mode. the --debug flag should be ommitted when building for release.
      ```bash
      flutter build apk --debug
      ```
   5. The APK should be located at `build/app/outputs/flutter-apk/app-debug.apk`
   6. Transfer the APK to the target device
   7. Ensure device is able to download from unknown sources
   8. Download the APK from the device and follow the prompts.

## Libraries/Frameworks Documentation

- [Flutter](https://docs.flutter.dev/development/ui/widgets-intro)
- [Provider](https://pub.dev/packages/provider) - For state management
- [Cristalyse Charts](https://docs.cristalyse.com) - For native charts
- [sqflite](https://pub.dev/packages/sqflite) - For handling the in app database
- [sqflite_common_ffi](https://pub.dev/packages/sqflite_common_ffi)[DEV] - Development dependency for testing the database within unit tests

## Useful Commands

- list all connected devices

```bash
flutter devices
```

- launch device

```bash
flutter devices --launch <device_id>
```

- run the app on the connected emulator/device(via usb debugging)

```bash
flutter run
```

- run all of the tests found in lib/tests

```bash
flutter test
```

- get the dependencies for the project.

```bash
flutter pub get
```

## More on Flutter

A few helpful resources made by the flutter team which we made use of:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
