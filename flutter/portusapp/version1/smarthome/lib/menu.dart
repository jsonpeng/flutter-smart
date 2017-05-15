import 'package:flutter/material.dart';
import 'dart:async';

class MenuPage extends StatefulWidget{
    MenuPage({Key key,this.timer,this.shouldTurnToHome}):super(key: key){}

    @override
    _MenuPageState createState() =>new _MenuPageState();
   Timer timer;
   bool shouldTurnToHome;

}

class _MenuPageState extends State<MenuPage>{

void _device(){
    setState((){
//            print("this is device");
    Navigator.of(context).pushNamed('/device');
    });

}

void _stats(){
    setState((){
        print("this is stats");
    });
}

void _home(){
    setState((){
        print("this is home");
        Navigator.of(context).pop();
    });
}

void _scenes(){
    setState((){
//        print("this is scenes");
      Navigator.of(context).pushNamed('/setting');
    });
}

void _settings(){
    setState((){
//        print("this is settings");
      Navigator.of(context).pushNamed('/setting');
    });
}

@override
void initState(){
  super.initState();
  config.timer;
  print('TryToAddTimer');
}
   @override
   Widget build(BuildContext context){

     return new Container(
   child: new Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children:<Widget>[

   new Padding(
  padding: const EdgeInsets.only(top:0.0),
child: new GestureDetector(
    onTap: (){
        _device();
    },

child: new Icon(
    Icons.devices,
    color: Colors.white,
    size: 45.0,
))),

new Padding(
    padding: const EdgeInsets.only(top:0.0),
    child:new Text('device',
    style: new TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w800))),


        new Padding(
         padding: const EdgeInsets.only(left:50.0,top:65.0),
                child: new Row(
                children:<Widget>[
         new Padding(
             padding :const EdgeInsets.only(right:60.0),
                child:new GestureDetector(
                     onTap: (){
                        _stats();
                     },

            child: new Icon(

                    Icons.assessment,
                    color:Colors.white,
                    size:45.0,
                ))),
              new Padding(
                  padding: const EdgeInsets.only(top:0.0,left: 5.0),
                  child:new GestureDetector(
                      onTap: (){
                          _home();
                      },
                      child:new Icon(

                Icons.home,
                color:Colors.white,
                size:45.0,
            ))),
                         // child: new Icon(Icons.wifi),
                         new Padding(
                             padding :const EdgeInsets.only(left:75.0),
                             child: new GestureDetector(
                                 onTap: (){
                                     _scenes();
                                 },
                                 child:new Icon(

                           Icons.access_time,
                           color:Colors.white,
                           size:45.0,
                       ))),
                   ])),


                   new Padding(
                  padding: const EdgeInsets.only(top:60.0),
                  child: new GestureDetector(
                    onTap: (){
                        _settings();
                    },

                  child: new Icon(
                    Icons.build,
                    color: Colors.white,
                    size: 45.0,
                  ))),

                  new Padding(
                    padding: const EdgeInsets.only(top:0.0),
                    child:new Text('settings',
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800))),



// new Row(
//     children: <Widget>[
//     new Container(
// child:new Padding(
//     padding: const EdgeInsets.only(top:0.0),
//     child: new GestureDetector(
//         onTap:(){
//         _stats();
//         },
//     child: new Icon(
//         Icons.assessment,
//         color: Colors.white,
//         size:40.0,
//     )
//
//     )
// )
//
//
//
// ),
// ]
// ),


//  new Container(
//     child: new Row(
//         children: <Widget>[
//     new Padding(
//         padding: const EdgeInsets.only(top:0.0,left:40.0),
//     child: new GestureDetector(
//         onTap: (){
//             _stats();
//         },
//     child: new Icon(
//         Icons.assessment,
//         color: Colors.white,
//         size: 40.0,
//     )
//     )
// ),
// new Padding(
//     padding: const EdgeInsets.only(top:0.0),
//     child:new GestureDetector(
//         onTap: (){
//         _home();
//         },
//         child: new Icon(
//             Icons.home,
//             size:40.0,
//         )
//     )),
//
//     new Padding(
//         padding: const EdgeInsets.only(top:0.0),
//         child:new GestureDetector(
//             onTap: (){
//             _scenes();
//             },
//             child: new Icon(
//                 Icons.access_time,
//                 size:40.0,
//             )
//         )),
//
//
//         ]
//     )
// ),

    ]));




   }

}
