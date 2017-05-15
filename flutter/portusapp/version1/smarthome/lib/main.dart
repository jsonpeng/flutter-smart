
library chartjs.example;

import 'package:flutter/material.dart';
import 'home.dart';
import 'scene.dart';
import 'menu.dart';
import 'scenesetting.dart';
import 'alldevices.dart';
import 'devicedetails.dart';
import 'scenedetails2.dart';
import 'scennedetails1.dart';
import 'dart:async';


//
//import 'dart:html';
//import 'dart:math' as math;
//
//import 'package:chartjs/chartjs.dart';

void main() {

//  runApp(new MyApp());
  runApp(new MaterialApp(
    home: new HomePage(), // becomes the route named '/'

    routes: <String, WidgetBuilder> {
      '/scene': (BuildContext context) => new ScenePage(),
      '/menu': (BuildContext context) => new MenuPage(),
      '/setting': (BuildContext context) => new SceneSettingPage(),
      '/device': (BuildContext context) => new AllDevicesPage(),
      '/devicedetails': (BuildContext context) => new DeviceDetails(),
      '/scenedetails1': (BuildContext context) => new SceneDetails1Page(),
      '/scenedetails2': (BuildContext context) => new SceneDetails2Page(),

    },
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new HomePage(key: key
        //dding: const EdgeInsets.all(50.0),
//       child:new Image.asset('Assets/circle.png',scale: 3.0,fit: ImageFit.cover)

        );
  }
}




//class FeatureItem extends StatelessWidget {
//  FeatureItem({Key key, this.product}) : super(key: key) {
//    assert(product.featureTitle != null);
//    assert(product.featureDescription != null);
//  }
//
//  final Product product;
//
//  @override
//  Widget build(BuildContext context) {
//    final ShrineTheme theme = ShrineTheme.of(context);
//    return new AspectRatio(
//        aspectRatio: 3.0 / 3.5,
//        child: new Container(
//            decoration: new BoxDecoration(
//                backgroundColor: theme.cardBackgroundColor,
//                border: new Border(
//                    bottom: new BorderSide(color: theme.dividerColor))),
//            child: new Column(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: <Widget>[
//                  new SizedBox(
//                      height: unitSize,
//                      child: new Align(
//                          alignment: FractionalOffset.topRight,
//                          child: new FeaturePriceItem(product: product))),
//                  new Expanded(
//                      child: new CustomMultiChildLayout(
//                          delegate: new FeatureLayout(),
//                          children: <Widget>[
//                        new LayoutId(
//                            id: FeatureLayout.left,
//                            child: new ClipRect(
//                                child: new OverflowBox(
//                                    minWidth: 340.0,
//                                    maxWidth: 340.0,
//                                    minHeight: 340.0,
//                                    maxHeight: 340.0,
//                                    alignment: FractionalOffset.topRight,
//                                    child: new Image.asset(product.imageAsset,
//                                        fit: ImageFit.cover)))),
//                        new LayoutId(
//                            id: FeatureLayout.right,
//                            child: new Padding(
//                                padding: const EdgeInsets.only(right: 16.0),
//                                child: new Column(
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    children: <Widget>[
//                                      new Padding(
//                                          padding:
//                                              const EdgeInsets.only(top: 18.0),
//                                          child: new Text(product.featureTitle,
//                                              style: theme.featureTitleStyle)),
//                                      new Padding(
//                                          padding: const EdgeInsets.symmetric(
//                                              vertical: 16.0),
//                                          child: new Text(
//                                              product.featureDescription,
//                                              style: theme.featureStyle)),
//                                      new VendorItem(vendor: product.vendor)
//                                    ])))
//                      ]))
//                ])));
//  }
//}

//
//class FeatureLayout extends MultiChildLayoutDelegate {
//    FeatureLayout();
//
//    static final String left = 'left';
//    static final String right = 'right';
//
//    // Horizontally: the feature product image appears on the left and
//    // occupies 50% of the available width; the feature product's
//    // description apepars on the right and occupies 50% of the available
//    // width + unitSize. The left and right widgets overlap and the right
//    // widget is stacked on top.
//    @override
//    void performLayout(Size size) {
//    final double halfWidth = size.width / 2.0;
//    layoutChild(left, new BoxConstraints.tightFor(width: halfWidth, height: size.height));
//    positionChild(left, Offset.zero);
//    layoutChild(right, new BoxConstraints.expand(width: halfWidth + unitSize, height: size.height));
//    positionChild(right, new Offset(halfWidth - unitSize, 0.0));
//    }
//
//    @override
//    bool shouldRelayout(FeatureLayout oldDelegate) => false;
//    }
//
