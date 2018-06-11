import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';
import 'pages/post_view.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isLoading = true; //For progress bar
  var posts;
  var imgUrl;
  //initialization
  void initState() {
    super.initState();
    _fetchData();
  }
  //Function to fetch data from JSON
  @override
  _fetchData() async {
    print("attempting");
    final url =
        "https://www.googleapis.com/blogger/v3/blogs/2218928969272947503/posts/?key=AIzaSyCiql1eQkMHczkLiS--0HOLxbLJVEoZ2IE";
    final response = await http.get(url);
    print(response);
    if (response.statusCode == 200) { 
      //HTTP OK is 200
      final Map items = json.decode(response.body);
      var post = items['items'];

      setState(() {
        _isLoading = false;
        this.posts = post;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Blogger"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _fetchData();
                })
          ],
        ),
        body: new Center(
            child: _isLoading
                ? new CircularProgressIndicator()
                : new ListView.builder(
                    itemCount: this.posts != null ? this.posts.length : 0,
                    itemBuilder: (context, i) {
                      final Post = this.posts[i];
                      final postDesc = Post["content"];
                      //All the below code is to fetch the image
                      var document = parse(postDesc);
                      //Regular expression
                      RegExp regExp = new RegExp(
                        r"(https?:\/\/.*\.(?:png|jpg|gif))",
                        caseSensitive: false,
                        multiLine: false,
                      );
                      final match = regExp
                          .stringMatch(document.outerHtml.toString())
                          .toString();
                      //print(document.outerHtml);
                      //print("firstMatch : " + match);
                      //Converting the regex output to image (Slashing) , since the output from regex was not perfect for me
                      if (match.length > 5) {
                        if (match.contains(".jpg")) {
                          imgUrl = match.substring(0, match.indexOf(".jpg"));
                          print(imgUrl);
                        } else {
                          imgUrl =
                              "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg";
                        }
                      }
                      String description = document.body.text.trim();
                      return new Container(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              width: 500.0,
                              height: 180.0,
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    //check if the image is not null (length > 5) only then check imgUrl else display default img
                                    image: new NetworkImage(imgUrl
                                                .toString()
                                                .length >
                                            10
                                        ? imgUrl.toString()
                                        : "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                              ),
                            ),
                            new Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: new Text(
                                Post["title"],
                                maxLines: 3,
                                style: new TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            new Text(
                              description.replaceAll("\n", ", "),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(fontSize: 15.0),
                            ),
                            new Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: new RaisedButton(
                                child: new Text("READ MORE",style: new TextStyle(color: Colors.white),),
                                color: Colors.blue,
                                onPressed: () {
                                  //We will pass description to postview through an argument
                                  Navigator
                                      .of(context)
                                      .push(new MaterialPageRoute<Null>(
                                    builder: (BuildContext context) {
                                      return PostView(description);
                                    },
                                  ));
                                },
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    },
                  )));
  }
}
