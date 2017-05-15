import 'package:flutter/material.dart';
import 'dart:async';
import 'menu.dart';
class ScenePage extends StatefulWidget {
  ScenePage({Key key,this.shouldTurnToHome:true,this.timer}): super(key: key) {}

  bool shouldTurnToHome;
  Timer timer;
  @override
  _ScenePageState createState() => new _ScenePageState();
}


class _ScenePageState extends State<ScenePage>{
int _temperature =27;
void reduce(){
    setState(() {
   _temperature--;
   });
}
Timer timer;
void add(){
    setState(() {
    _temperature++;
});
}
@override
void initState(){
  super.initState();

  timer = new Timer.periodic(new Duration(seconds:5),turnToHome);
  print('timer=$timer');
  print('timerinitedAfterInitSate');
}

void turnToHome(Timer timer){
//  config.shouldTurnToHome?Navigator.of(context).pushNamed('/'):null;
if(config.shouldTurnToHome){
  timer.cancel();
//  print('timercanceled');
  Navigator.of(context).pushNamed('/');

}else{
  config.shouldTurnToHome=true;
}

}

@override
void dispose(){

 timer.cancel();
  print('timercanceledBeforeDispose');
  super.dispose();
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
                      delegate: new ScenePageLayout(),
                      children: <Widget>[
                    new LayoutId(
                        id: ScenePageLayout.background,
                        child: new Image.asset('Assets/circle.png',
                            fit: ImageFit.contain)),
                    new LayoutId(
                        id: ScenePageLayout.centerElements,
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
                              new Center(
                                  child: new GestureDetector(
                                onTap: (){
                                  config.shouldTurnToHome=false;
                                    timer.cancel();
                                  print('timerCanceledAfterTap');
                                  Navigator.push(context, new MaterialPageRoute(
                                      builder: (BuildContext context) => new MenuPage(timer:timer,shouldTurnToHome: false)));
//                                 Navigator.pushNamed(context,'/menu');
                                },
                               child:  new Icon(

                                  Icons.menu,
                                  color:Colors.white,

                                //size:40.0,
                                ),)
                              ),
                        //                   new Container(
                        //  //padding: const EdgeInsets.only(right:148.0,top:0.0,left:30.0),
                        //  child:new Row(
                        //      children:<Widget>[
                        //          new Padding(
                        //          padding: const EdgeInsets.only(top:0.0,left:20.0),
                        //                  child: new Text('date mode',
                        //                  style: new TextStyle(
                        //                  color: Colors.white,
                        //                  fontSize: 20.0,
                        //                  fontStyle: FontStyle.italic,
                        //                  fontWeight: FontWeight.w400 ))),
                        //                  new Padding(
                        //                  padding: const EdgeInsets.only(left:125.0),
                        //                          child: new Text('movie time',
                        //                          style: new TextStyle(
                        //                          color: Colors.white,
                        //                          fontSize: 20.0,
                        //                          fontStyle: FontStyle.italic,
                        //                          fontWeight: FontWeight.w400 ))),
                        //  ])),

                                //             new Padding(
                                //                 padding: const EdgeInsets.only(right:148.0,top:0.0,left:30.0),
                                //                 child:new Row(
                                //                     children: <Widget>[
                                //                 child: new Text('date mode',
                                //                     style: new TextStyle(
                                //                         color: Colors.white,
                                //                         fontSize: 20.0,
                                //                         fontStyle: FontStyle.italic,
                                //                         fontWeight: FontWeight.w400 )),
                                //
                                // new Padding(
                                // padding: const EdgeInsets.only(left: 200.0,right:0.0,top:0.0),
                                //         child: new Text('movie time',
                                //         style: new TextStyle(
                                //         color: Colors.white,
                                //         fontSize: 20.0,
                                //         fontStyle: FontStyle.italic,
                                //         fontWeight: FontWeight.w400 ))),
                                //     ])),
                                //

                            new Padding(
                             padding: const EdgeInsets.only(left:70.0,top:65.0),
                                    child: new Row(
                                    children:<Widget>[
                             new Padding(
                                 padding :const EdgeInsets.only(right:40.0),
                                    child:new GestureDetector(
                                         onTap: (){
                                            reduce();
                                         },

                                child: new Icon(

                                        Icons.remove_circle_outline,
                                        color:Colors.white,
                                        size:40.0,
                                    ))),
                                  new Padding(
                                      padding: const EdgeInsets.only(top:0.0),
                                      child: new Text('$_temperature°',
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 40.0,
                                              fontWeight: FontWeight.w800))),
                                             // child: new Icon(Icons.wifi),
                                             new Padding(
                                                 padding :const EdgeInsets.only(left:40.0),
                                                 child: new GestureDetector(
                                                     onTap: (){
                                                         add();
                                                     },
                                                     child:new Icon(

                                               Icons.add_circle_outline,
                                               color:Colors.white,
                                               size:40.0,
                                           ))),
                                       ])),

                                 new Padding(
                                            padding: const EdgeInsets.only(top:20.0),
                                            child: new Text('temp',
                                                      style: new TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 28.0,
                                                          fontWeight: FontWeight.w800))),
                                                          new Padding(
                                                            padding: const EdgeInsets.only(top:20.0),
                                                              child: new Image.asset('Assets/sun.png',
                                                                  fit: ImageFit.contain,width: 20.0,height: 20.0)),

                                                                  new Padding(
                                                                      padding: const EdgeInsets.only(top:0.0),
                                                                      child: new Text('23°',
                                                                          style: new TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 36.0,
                                                                              fontWeight: FontWeight.w800))),




                                ])))
                  ]))
            ])));
  }
}



class ScenePageLayout extends MultiChildLayoutDelegate {
  ScenePageLayout();

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
  bool shouldRelayout(ScenePageLayout oldDelegate) => false;
}


class ScenePageRoute extends MaterialPageRoute {
  ScenePageRoute({
  WidgetBuilder builder,
  RouteSettings settings: const RouteSettings()
  }) : super(builder: builder, settings: settings);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> forwardAnimation) {
    return  buildPage(context, super.animation,super.forwardAnimation);
  }
//  static ScenePageRoute of(BuildContext context) => ModalRoute.of(context);
}