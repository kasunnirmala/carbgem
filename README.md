# For Deployment:
1. Merge/finalize code in dev branch
2. Merge code from main branch to dev branch (mainly in order to update android app build.gradle file for the latest version number)
3. Commit the final code to dev branch
4. Create pull request to merge dev branch to main branch (make sure only merge new dart files, not config files such as plist, xml, etc which may break the CI/CD pipeline)

## Final commit from dev branch:
include [skip ci] in the commit message
## Final check in the main branch:
- Change versionName for Android: android/fastlane/Fastfile -> line 18
- Change versionName for iOS: ios/fastlane/Fastfile -> line 29
## Finish checking version:
git commit -a -m "finish checking"
git push
# carbgem

fvm use 2.10.0

To run any flutter command:

fvm flutter {command}

fvm flutter packages get
    
Unit test:

fvm flutter test test-path.dart

# For MacOS simulator:
open -a Simulator

To get bundle id:
Runner.xcodeproj/project.pbx

# Register to Firebase:

package name: android\app\src\main\AndroidManifest.xml
need to register for both sh1 and sh256 to activate phone registration
SH1 key: keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

https://firebase.google.com/docs/flutter/setup?platform=android

# BlocBuilder vs. BlocListener:
It all depends on if you route-based navigation (where you push routes onto the navigation stack and have routing animations etc...). If you don't care about that, then using BlocBuilder to return different widgets is totally fine.

If you do, however, decide that you want to refactor your app to use route-based navigation, then I would highly recommend using BlocListener or BlocListenerTree to handle the navigation when it needs to occur as a result of a state change.

When using BlocListener or BlocListenerTree your child can be any other widget. They don't have an impact on the UI and are simply a listener.

In general, I would say BlocBuilder should only be used to return different widgets in response to different bloc states whereas BlocListener should be used if you want to "do things" in response to state changes. 

database requirement: patient list Patient 1 patient

## Test TFLite on Mobile device:
https://pub.dev/packages/tflite_flutter
May want to test NNAPI, GPU delegates on Android, Metal and CoreML delegates on iOS

For android:
sh install.sh (Linux) / install.bat (Windows) 

For iOS:
Download https://github.com/am15h/tflite_flutter_plugin/releases/download/v0.5.0/TensorFlowLiteC.framework.zip
Unzip and place the folder in :
1. ~/.pub-cache/hosted/pub.dartlang.org/tflite_flutter-<plugin-version>/ios/ (Linux/ Mac)
2. ios/.symlinks/plugins/tflite_flutter/ios

flutter clean
flutter pub get
pod install

## How to switch api connection environment

※ If you wish to start with the initial setup (defining your own environment name from the firebase project & app creation), please start from step 1. If you wish to run the application in the currently created environment, please start from step 5.

1. Write additionally the following Flutter flavor libraries into the following file.

    `./carbgem/pubspec.yaml` 

    ```
    dev_dependencies:
        flutter_flavorizr: ^2.0.0
        flutter_flavor: ^3.0.3
    ```

-   Reference
    - https://pub.dev/packages/flutter_flavor
    - https://pub.dev/packages/flutter_flavorizr/versions/2.0.0/


2. Download the `authorization file` from the application of the firebase project you will use, and then create a `.firebase` folder directly under `./carbgem` and place it in it.

3. Write additionally the definition of flavor in the following file.

     `./carbgem/pubspec.yaml` 
     
    In order to flavorize your project and enable Firebase in your flavor
you have to define a firebase object below each OS flavor. Under the
firebase object you must define the config path of the google-services.json
(if you are under Android configuration) or GoogleService-Info.plist
(if you are under iOS configuration).

    As you can see in the example below, we added the path accordingly
    ```
    flavorizr:
    app:
        android:
        flavorDimensions: "flavor-type"
        ios:

    flavors:
        apple:
        app:
            name: "Apple App"

        android:
            applicationId: "com.example.apple"
            firebase:
            config: ".firebase/apple/google-services.json"

        ios:
            bundleId: "com.example.apple"
            firebase:
            config: ".firebase/apple/GoogleService-Info.plist"

        banana:
        app:
            name: "Banana App"
            
        android:
            applicationId: "com.example.banana"
            firebase:
            config: ".firebase/banana/google-services.json"
        ios:
            bundleId: "com.example.banana"
            firebase:
            config: ".firebase/banana/GoogleService-Info.plist"
    ```
    - Reference
        - https://pub.dev/packages/flutter_flavorizr/versions/2.0.0

4. Execute the following command.

    `$fvm flutter pub get`
    
    `$fvm flutter pub run flutter_flavorizr`

5. The following command can be executed to switch the api's connection point and start frontend.

    5.1. For Android Build
    (simply execute the following command)

        `$fvm flutter run --flavor [flavorName] --dart-define=Flavor=[flavorName] -t lib/main-[flavorName].dart -d [device-name] --no-sound-null-safety`

        - The following three flavornames are currently available.

        `flavorName: development, staging, production`

        - The device name can be confirmed with the following command(example output below).

        `$fvm flutter devices`
        ```
        A103OP (mobile) • [device-name] • android-arm64  • Android 12 (API 31)
        ```

    5.2. For iOS Build

    ※ If you wish to start with the initial setup (defining your own environment name from the firebase project & app creation), please start from step 5.2.1. If you wish to run the application in the currently created environment, please start from step 5.2.3
    
    5.2.1. Configuration of Xcode to start flavor in each environment(See below)
    - https://medium.com/flutter-jp/flavor-b952f2d05b5d (Articles)
    - https://www.youtube.com/watch?v=Vhm1Cv2uPko&t=215s (Videos)

    5.2.2. M1 mac users also need to support the following(See below)
    - https://stackoverflow.com/questions/63607158/xcode-building-for-ios-simulator-but-linking-in-an-object-file-built-for-ios-f
    - https://qiita.com/littleossa/items/ff75b19e0ac6713941f8

    5.2.3. Execute the commands listed in 5.1 android above

### The following steps are also required if you want to switch environments in vscode via GUI operation.

6. Create laugh.json directly under .vscode.
Please refer to the following file as an example of preparation.

    `./carbgem/.vscode/launch.json`

7. If you press "Run -> Start Debugging" on the vscode, you should see a tab for selecting the environment and be able to choose.
