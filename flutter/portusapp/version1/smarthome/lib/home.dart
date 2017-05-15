import 'package:flutter/material.dart';
import 'scene.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({
  Key key,
//  this.onTap,
  })
      : super(key: key,) {
//    assert(product.featureTitle != null);
//    assert(product.featureDescription != null);
  }

//  GestureTapCallback onTap;

  @override
  _HomePageState createState() => new _HomePageState();
}


class _HomePageState extends State<HomePage>{
@override
void initState(){
  super.initState();

}
   @override
  Widget build(BuildContext context) {
//    final ShrineTheme theme = ShrineTheme.of(context);
      return  new AspectRatio(
        aspectRatio: 1.0 / 1.0,
        child: new Container(

             child: new GestureDetector(
             onTap: ()
       {
//                 Navigator.push(context, new ScenePageRoute(
//                 builder: (BuildContext context) {
//                   return new ScenePage();
//                      }));

         Navigator.of(context).pushNamed('/scene');
//         var future = getFuture();
//         new Timer(new Duration(milliseconds: 5), () {
//           // The error-handler is not attached until 5 ms after the future has
//           // been received. If the future fails before that, the error is
//           // forwarded to the global error-handler, even though there is code
//           // (just below) to eventually handle the error.
//         Future<bool> turnToHome =  future.then((value) { useValue(value); },
//               onError: (e) { handleError(e); });
//         });

             },
            child: new CustomMultiChildLayout(
                delegate: new HomePageLayout(),
                children: <Widget>[
                  new LayoutId(
                      id: HomePageLayout.background,
                      child: new Image.asset('Assets/circle.png',
                          fit: ImageFit.contain)),
                  new LayoutId(
                      id: HomePageLayout.centerElements,
                      child: new Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0),
                          child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                    padding: const EdgeInsets.only(top: 50.0),
                                    child: new Text('188',
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 50.0,
                                          fontWeight: FontWeight.w400,))),
                                new Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: new Text('31',
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 70.0,
                                            fontWeight: FontWeight.w800))),
                                new Padding(
                                    padding: const EdgeInsets.only(top:40.0),
                                    child: new Image.asset('Assets/sun.png',
                                        fit: ImageFit.contain,width: 16.0,height: 16.0)),
                                new Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: new Text('23°',
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w400))),

                              ])))
                ])
        )));
//    return new MaterialApp(
//      home: home,
//      routes: <String, WidgetBuilder> {
//        '/scene': (BuildContext context) => new ScenePage(),
////        '/menu': (BuildContext context) => new MyPage(title: 'page B'),
////        '/c': (BuildContext context) => new MyPage(title: 'page C'),
//      },
//    );
  }
}


class HomePageLayout extends MultiChildLayoutDelegate {
  HomePageLayout();

  static final String background = 'background';
  static final String centerElements = 'centerElements';

  // Horizontally: the feature product image appears on the left and
  // occupies 50% of the available width; the feature product's
  // description apepars on the right and occupies 50% of the available
  // width + unitSize. The left and right widgets overlap and the right
  // widget is stacked on top.
  @override
  void performLayout(Size size) {
    layoutChild(background,
        new BoxConstraints.tightFor(width: size.width, height: size.height));
    positionChild(background, Offset.zero);
    layoutChild(centerElements,
        new BoxConstraints.expand(width: size.width, height: size.height));
    positionChild(centerElements, Offset.zero);
  }

  @override
  bool shouldRelayout(HomePageLayout oldDelegate) => false;
}