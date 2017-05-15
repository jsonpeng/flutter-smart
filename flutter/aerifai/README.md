# Aerifai App #
![aerifai](http://45.32.248.21/static/aerifai/3.gif)  

Aerifai application by the `dart flutter` and `native Java` write, Aerifai applications at the core of the architecture is `MVVM structure`, namely the view and logical binding together in college

## Aerifai struct ##
![aerifai](http://45.32.248.21/static/aerifai/stu.jpg)    

Aerifai is also a `mvvm struct` project for design,first add parameter with `lib/main.dart` to edit app router,and can edit the should add page in `all.dart`,then can edit `lib/appstruct` file to edit the app page.  
some android native code should edit at `android` file.then edit the `lib/communication` file to add **websocket api** and the **jog control** parameter.

## Application of communication between ##
![aerifai](http://45.32.248.21/static/flutter/tongxin.png)  
Due to flutter the framework itself does not have the video media function and unable to invoke the `native android SDK`, so all call depends on `PlatformMessages`(ON **FLUTTER SERVICE**) between native to send a message to the android, to make the android can invoke the underlying encapsulated interface, specific examples of roughly can see the following:  

     Future<Null> _play() async {
    int result = await methodChannel.invokeMethod('$playmovie');
    print('get result :$result');
  }


this code is in dart flutter stucture and need to set a `Listen for an event` in the android.  


      new FlutterMethodChannel(getFlutterView(), VIDEO_CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, Response response) {
            if (call.method.equals("playMovie")) {
                    playMovie("file:///sdcard/all.mp4");
            }else if(call.method.equals("playWeather")){
                   playMovie("file:///sdcard/weather.mp4");
            } else {
              response.notImplemented();
            }
          }
