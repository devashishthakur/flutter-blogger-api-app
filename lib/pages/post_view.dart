import 'package:flutter/material.dart';

class PostView extends StatelessWidget {
  var desc;

  PostView(String desc)
  {
    this.desc = desc;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Blogger"),
      ),
      body: new Container(
        child: new SingleChildScrollView(
          child: new Text(desc,style: new TextStyle(
            fontSize: 18.0,
          ),))
        ),
    );
  }
}