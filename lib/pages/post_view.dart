import 'package:flutter/material.dart';

class PostView extends StatelessWidget {
  var desc, title, image;

  PostView(String title, String desc, String image) {
    this.desc = desc;
    this.title = title;
    this.image = image;
  }
  @override
  Widget build(BuildContext context) {
    if (desc.toString().contains("\n\n\n\n")) {
      desc = desc.toString().replaceAll("\n\n\n\n", "\n\n");
    }

    if (desc.toString().contains("\n\n\n")) {
      desc = desc.toString().replaceAll("\n\n\n", "\n");
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Blogger"),
      ),
      body: new Container(
          child: new SingleChildScrollView(
              child: new Column(
        children: <Widget>[
          new Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: new Text(
              title,
              style: new TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          new Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: new Container(
              width: 500.0,
              height: 180.0,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                image: new DecorationImage(
                    fit: BoxFit.fill,
                    //check if the image is not null (length > 5) only then check imgUrl else display default img
                    image: new NetworkImage(image.toString().length > 10
                        ? image.toString()
                        : "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
              ),
            ),
          ),
          new Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: new Text(
              desc,
              style: new TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ))),
    );
  }
}
