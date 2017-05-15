import 'package:flutter/material.dart';


class SceneDetails1Page extends StatefulWidget {
  SceneDetails1Page({Key key,}): super(key: key) {}
  @override
  _SceneDetails1PageState createState() => new _SceneDetails1PageState();
}


class _SceneDetails1PageState extends State<SceneDetails1Page>{


void sceneedit(){
    setState(() {

   print("scene edit");
   });

}
void close(){
  setState((){
    print("closeSceneDetails");
    Navigator.of(context).pop();
  });
}
void adddevice(){
    setState(() {

   print("add new device");
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

                                  new GestureDetector(
                                                onTap: (){
                                                  close();
                                                },
                                                child:new Icon(

                                                    Icons.close,
                                                    color:Colors.white,
                                                )),
                                new Padding(
                                    padding: const EdgeInsets.only(top: 0.0,left:125.0,bottom:20.0),
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
                                        adddevice();
                                      },

                                child: new Icon(
                                    Icons.add_circle_outline,
                                    color:Colors.white,
                                    size:200.0,))),

                                       ])),

                                 new Padding(
                                            padding: const EdgeInsets.only(top:20.0),
                                            child:new GestureDetector(
                                                 onTap: (){
                                                    adddevice();
                                                 },
                                            child: new Text('add new device',
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
