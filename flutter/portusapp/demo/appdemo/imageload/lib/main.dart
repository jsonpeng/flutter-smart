import 'package:flutter/material.dart';
class LayoutDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('imageload'),
      ),

      body:  new Center(
        //dding: const EdgeInsets.all(50.0),
        child: new Image.network('http://www.portushome.com/static/myhome/test/demo.jpg',
              // new Text('我在屏幕的中心！'), // ignore: extra_positional_arguments
      scale:2.0 ),),);
  }
}

void main() {
  runApp(
    new MaterialApp(
      title: 'imagedemo',
      home: new LayoutDemo(),
    ),
  );
}
