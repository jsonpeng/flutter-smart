import 'package:flutter/material.dart';

// final Map<String, WidgetBuilder> _kRoutes = new Map<String, WidgetBuilder>.fromIterable(
//   //kAllGalleryItems,
//   key: (GalleryItem item) => item.routeName,
//   value: (GalleryItem item) => item.buildRoute,
// );

class HomePage extends StatefulWidget {


    static const String routeName = '/home';
  HomePage({
    Key key,
  })
      : super(key: key) {

  }
  @override
 HomePageState createState() => new HomePageState();
  }

  class HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {

Widget home= new AspectRatio(
        aspectRatio: 1.0 / 1.0,
        child: new Container(

            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

              new Expanded(
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
                                left: 0.0, right: 0.0, top: 0.0),
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: new Text('188',
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 50.0,
                                              fontWeight: FontWeight.w400 ))),
                                  new Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: new Text('31',
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 60.0,
                                              fontWeight: FontWeight.w800))),
                                  new Padding(
                                    padding: const EdgeInsets.only(top:38.0),
                                      child: new Image.asset('Assets/sun.png',
                                          fit: ImageFit.contain,width: 20.0,height: 20.0)),
                                  new Padding(
                                      padding: const EdgeInsets.only(top:2.0),
                                      child: new Text('23°',
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 38.0,
                                              fontWeight: FontWeight.w800))),

                                ])))
                  ]))
            ])));
            return new MaterialApp(

              //routes: _kRoutes,
              home:home,
            );
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
