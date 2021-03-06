import 'package:flutter/material.dart';


class SceneDetails2Page extends StatefulWidget {
  SceneDetails2Page({Key key,}): super(key: key) {}
  @override
  _SceneDetails2PageState createState() => new _SceneDetails2PageState();
}


class _SceneDetails2PageState extends State<SceneDetails2Page>{


void sceneedit(){
    setState(() {

   print("scene edit");
   });

}

void deldevice(){
    setState(() {

   print("delete device");
   });
}

void devicedetails(){
    setState(() {

   print("device details");
   Navigator.of(context).pushNamed('/devicedetails');
   });
}


  @override
  Widget build(BuildContext context) {

    return new AspectRatio(
        aspectRatio: 1.0 / 1.0,
        child: new Container(

            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

              new Expanded(
                  child: new CustomMultiChildLayout(
                      delegate: new SceneDetailsPageLayout(),
                      children: <Widget>[
                    new LayoutId(
                        id: SceneDetailsPageLayout.background,
                        child: new Image.asset('Assets/circle.png',
                            fit: ImageFit.contain)),
                    new LayoutId(
                        id: SceneDetailsPageLayout.centerElements,
                        child: new Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 0.0),
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                new Padding(
                                    padding: const EdgeInsets.only(top: 10.0,left:125.0,bottom:20.0),
                                    child: new Row(
                                    children:<Widget>[
                                     new Text('party time',
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400 )),

                                    new GestureDetector(
                                                 onTap: (){
                                                    sceneedit();
                                                 },
                                        child:new Icon(

                                              Icons.edit,
                                              color:Colors.white,
                                          ))])),


                            new Padding(
                             padding: const EdgeInsets.only(top:0.0),
                                    child: new Row(
                                    children:<Widget>[
                             new Padding(
                                 padding :const EdgeInsets.only(top:0.0,left:75.0),
                                 child:new GestureDetector(
                                      onTap: (){
                                        // sceneon();
                                        devicedetails();
                                      },

                                child: new Icon(
                                    Icons.adjust,
                                    color:Colors.white,
                                    size:200.0,))),

                                       ])),

                                 new Padding(
                                            padding: const EdgeInsets.only(top:20.0),
                                            child:new GestureDetector(
                                                 onTap: (){
                                                    devicedetails();
                                                 },
                                            child: new Text('air purifier 01',
                                                      style: new TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight: FontWeight.w800)))),

                                                          new Padding(
                                                                     padding: const EdgeInsets.only(top:15.0),
                                                                     child:new GestureDetector(
                                                                          onTap: (){
                                                                             deldevice();
                                                                          },
                                                                     child: new Text('delete',
                                                                               style: new TextStyle(
                                                                                   color: Colors.white,
                                                                                   fontSize: 16.0,
                                                                                   fontWeight: FontWeight.w800)))),







                                ])))
                  ]))
            ])));
  }
}



class SceneDetailsPageLayout extends MultiChildLayoutDelegate {
  SceneDetailsPageLayout();

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
  bool shouldRelayout(SceneDetailsPageLayout oldDelegate) => false;
}
