![beegoproject](http://www.portushome.com/static/flutterapp/img/app-logo.png)  

# Flutter App #
--------------------  

Flutter is a new way to build high-performance, cross-platform mobile apps. Flutter is optimized for today's, and tomorrow's, mobile devices. They are focused on low-latency input and high frame rates on Android and iOS.


## Download Code ##
--------------------  

* `git clone https://yourname@bitbucket.org/portus/flutter.git`

## Download Test App ##
--------------------  

>**version1:**[http://www.portushome.com/static/flutterapp/version1/app.apk](http://www.portushome.com/static/flutterapp/version1/app.apk)  

>**version2:**[http://www.portushome.com/static/flutterapp/version2/app.apk](http://www.portushome.com/static/flutterapp/version2/app.apk)

## Debugging and Use Code  installing the Flutter app##
--------------------  

Before that you need to install the `Flutter SDK` and `Dart SDK` also need `android sdk` and `ios sdk` to build, make sure your environment is a `Linux` or `Mac OS`, things you need eg:  

 * Linux or Mac OS X. (Windows is not yet supported.)
 * git (used for source version control).
 * An IDE. We recommend [IntelliJ with the Flutter plugin](https://flutter.io/intellij-ide/).
 * An ssh client (used to authenticate with GitHub).
 * Python (used by some of tools).
 * The Android platform tools (see [Issue #55](https://github.com/flutter/flutter/issues/55)
   about downloading the Android platform tools automatically).
   _If you're also working on the Flutter engine, you can use the
   copy of the Android platform tools in
   `.../engine/src/third_party/android_tools/sdk/platform-tools`._
   - Mac: `brew install android-platform-tools`
   - Linux: `sudo apt-get install android-tools-adb`  

try to use `adb devices`
    
first to make sure, and through the command  

* `flutter doctor`
    
to make sure your `Flutter` all no problem, then use the command line  
 
* `cd flutter/aerifai`  

* `flutter run`
    
to run the code, it has hot compilation functions you can use heat to compile the `Shift + R` will not restart your APP instant output to your screen

### The flutter app structure ###
--------------------  

![beegoproject](http://www.portushome.com/static/flutterapp/img/app-stu.png)  

The directory `structure` above we can see `lib` is the main application directory, because of all the `program compiled` by this , `main.dart` is entry documents.We need to configure some add parameters in a `flutter.yaml`, such as load of the third party **image** and **font**.

### Running the analyzer ###
--------------------

When editing Flutter code, it's important to check the code with the analyzer. There are two
main ways to run it. In either case you will want to run `flutter update-packages --upgrade`
first, or you will get version conflict issues or bogus error messages about core clases like
Offset from `dart:ui`.

For a one-off, use `flutter analyze --flutter-repo`. This uses the `.analysis_options_repo` file
at the root of the repository for its configuration.

For continuous analysis, use `flutter analyze --flutter-repo --watch`. This uses normal
`.analysis_options` files, and they can differ from package to package.

If you want to see how many members are missing dartdocs, you should use the first option,
providing the additional command `--dartdocs`.

If you omit the `--flutter-repo` option you may end up in a confusing state because that will
assume you want to check a single package and the flutter repository has several packages.  

### Running the tests ###
-----------------

To automatically find all files named `_test.dart` inside a package's `test/` subdirectory, and run them inside the flutter shell as a test, use the `flutter test` command, e.g:

 * `cd flutter/aerifai`
 * `flutter test`

Individual tests can also be run directly, e.g. `flutter test lib/my_app_test.dart`

Flutter tests use [package:flutter_test](https://github.com/flutter/flutter/tree/master/packages/flutter_test) which provides flutter-specific extensions on top of [package:test](https://pub.dartlang.org/packages/test).

`flutter test` runs tests inside the flutter shell. To debug tests in Observatory, use the `--start-paused` option to start the test in a paused state and wait for connection from a debugger. This option lets you set breakpoints before the test runs.

To run all the tests for the entire Flutter repository, the same way that Travis runs them, run `dart dev/bots/test.dart`.

If you've built [your own flutter engine](#working-on-the-engine-and-the-framework-at-the-same-time), you can pass `--local-engine` to change what flutter shell `flutter test` uses. For example,
if you built an engine in the `out/host_debug_unopt` directory, you can pass
`--local-engine=host_debug_unopt` to run the tests in that engine.

Flutter tests are headless, you won't see any UI. You can use
`print` to generate console output or you can interact with the DartVM
via observatory at [http://localhost:8181/](http://localhost:8181/).