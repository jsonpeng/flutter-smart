import 'package:flutter/material.dart';


class SceneSettingPage extends StatefulWidget {
  SceneSettingPage({Key key,}): super(key: key) {}
  @override
  _SceneSettingPageState createState() => new _SceneSettingPageState();
}


class _SceneSettingPageState extends State<SceneSettingPage>{


void menu(){
    setState(() {

   print("menu");
   });

}

void sceneon(){
    setState(() {

   print("scene switch on");
   });
}

void sceneadd(){
    setState(() {

    print("add scene");
    });

}

void sceneoff(){
    setState(() {

    print("scene switch off");
});
}

void scenedetails(){
    setState(() {

    print("scene details");
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
                      delegate: new SceneSettingPageLayout(),
                      children: <Widget>[
                    new LayoutId(
                        id: SceneSettingPageLayout.background,
                        child: new Image.asset('Assets/circle.png',
                            fit: ImageFit.contain)),
                    new LayoutId(
                        id: SceneSettingPageLayout.centerElements,
                        child: new Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 0.0),
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                new Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: new Text('party time',
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400 ))),

                                    new GestureDetector(
                                                 onTap: (){
                                                    menu();
                                                 },
                                        child:new Icon(

                                              Icons.menu,
                                              color:Colors.white,
                                          )),


                            new Padding(
                             padding: const EdgeInsets.only(left:90.0,top:45.0),
                                    child: new Row(
                                    children:<Widget>[
                             new Padding(
                                 padding :const EdgeInsets.only(right:40.0),
                                 child:new GestureDetector(
                                      onTap: (){
                                         sceneon();
                                      },

                                child: new Text('on',
                                    style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 28.0,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w400 )))),
                                  new Padding(
                                      padding: const EdgeInsets.only(top:0.0),
                                      child:new GestureDetector(
                                           onTap: (){
                                              sceneadd();
                                           },
                                      child: new Icon(
                                          Icons.add_circle_outline,
                                          color:Colors.white,
                                          size:40.0,

                                      ))),
                                             // child: new Icon(Icons.wifi),
                                             new Padding(
                                                 padding :const EdgeInsets.only(left:40.0),
                                                 child:new GestureDetector(
                                                      onTap: (){
                                                         sceneoff();
                                                      },
                                                 child:  new Text('off',
                                                     style: new TextStyle(
                                                         color: Colors.white,
                                                         fontSize: 28.0,
                                                         fontStyle: FontStyle.italic,
                                                         fontWeight: FontWeight.w400 )))),
                                       ])),

                                 new Padding(
                                            padding: const EdgeInsets.only(top:70.0),
                                            child:new GestureDetector(
                                                 onTap: (){
                                                    scenedetails();
                                                 },
                                            child: new Text('scene details',
                                                      style: new TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight: FontWeight.w800)))),







                                ])))
                  ]))
            ])));
  }
}



class SceneSettingPageLayout extends MultiChildLayoutDelegate {
  SceneSettingPageLayout();

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
  bool shouldRelayout(SceneSettingPageLayout oldDelegate) => false;
}
