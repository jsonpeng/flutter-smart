import 'package:flutter/material.dart';


class DeviceDetails extends StatefulWidget {
  DeviceDetails({Key key,}): super(key: key) {}
  @override
  _DeviceDetailsState createState() => new _DeviceDetailsState();
}


class _DeviceDetailsState extends State<DeviceDetails>{
int _air =2;
void reduce(){
    setState(() {
   _air--;
   });
}

void add(){
    setState(() {
    _air++;
});
}

void sceneedit(){
    setState(() {
    print("scene edit");
});
}

void deviceon(){
    setState(() {
    print("device on");
    });

}

void deviceoff(){
    setState(() {
    print("device off");
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
                      delegate: new DeviceDetailsLayout(),
                      children: <Widget>[
                    new LayoutId(
                        id: DeviceDetailsLayout.background,
                        child: new Image.asset('Assets/circle.png',
                            fit: ImageFit.contain)),
                    new LayoutId(
                        id: DeviceDetailsLayout.centerElements,
                        child: new Padding(
                            padding: const EdgeInsets.only(
                                left: 0.0, right: 0.0, top: 0.0),
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                new Padding(
                                    padding: const EdgeInsets.only(top:0.0,left:115.0,bottom:20.0),
                                    child: new Row(
                                    children:<Widget>[
                                 new Text('air purifier 01',
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w400 )),
                                            new GestureDetector(
                                                         onTap: (){
                                                            sceneedit();
                                                         },
                                        child: new Icon(

                                              Icons.edit,
                                              color:Colors.white,

                                              //size:40.0,
                                          ))])),

                            new Padding(
                             padding: const EdgeInsets.only(left:85.0,top:35.0),
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
                                      child: new Text('$_air°',
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
                                            padding: const EdgeInsets.only(top:35.0),
                                            child: new Text('wind',
                                                      style: new TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24.0,
                                                          fontWeight: FontWeight.w800))),


                                                                  new Padding(
                                                                      padding: const EdgeInsets.only(top:35.0,left:125.0),
                                                                      child: new Row(
                                                                      children:<Widget>[

                                                                          new GestureDetector(
                                                                                       onTap: (){
                                                                                          deviceon();
                                                                                       },
                                                                    child:new Text('on',
                                                                          style: new TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 24.0,
                                                                              fontWeight: FontWeight.w800))),
                                                                              new GestureDetector(
                                                                                           onTap: (){
                                                                                              deviceoff();
                                                                                              },
                                                                                          child:     new Padding(
                                                                                                          padding: const EdgeInsets.only(left:40.0),
                                                                                                          child: new Text('off',
                                                                                                                    style: new TextStyle(
                                                                                                                        color: Colors.white,
                                                                                                                        fontSize: 24.0,
                                                                                                                        fontWeight: FontWeight.w800)))
                                                                             ),


                                                                          ])),




                                ])))
                  ]))
            ])));
  }
}



class DeviceDetailsLayout extends MultiChildLayoutDelegate {
  DeviceDetailsLayout();

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
  bool shouldRelayout(DeviceDetailsLayout oldDelegate) => false;
}
