import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

Future<Post> fetchPost() async {
  final response = await http.get('http://35.198.219.154:1337/position/1');
  if (response.statusCode == 200)
    return Post.fromJson(json.decode(response.body));
  else
    throw Exception('fail');
}

List<Post> postFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Post>.from(jsonData.map((x) => Post.fromJson(x)));
}

String postToJson(List<Post> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}


class Post {
  int createdAt;
  int updatedAt;
  int id;
  String positionName;
  int status;

  Post({
    this.createdAt,
    this.updatedAt,
    this.id,
    this.positionName,
    this.status,
  });

  factory Post.fromJson(Map<String, dynamic> json) => new Post(
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    id: json["id"],
    positionName: json["position_name"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "id": id,
    "position_name": positionName,
    "status": status,
  };
}


void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {
  @override

  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);

    double screenWidth = queryData.size.width;
    double screenHeight = queryData.size.height;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Name here'),
      ),
      body: new Container(height: screenHeight,width: screenWidth,margin: EdgeInsets.all(5),
        padding: new EdgeInsets.all(32.0),
        child: new ListView(
          children: <Widget>[
            RaisedButton(onPressed: null,child: Text('sadsdf'),),
            Card(child:
            FutureBuilder<Post>(
              future: fetchPost(),
              builder: (context,snapshot){
                if (snapshot.hasData){
                  String create = snapshot.data.createdAt.toString();
                  String update = snapshot.data.updatedAt.toString();
                  String ID = snapshot.data.id.toString();
                  String Position = snapshot.data.positionName;
                  String Status = snapshot.data.status.toString();
                  return Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                    Text('create :$create'),
                    Text('update :$update'),
                    Text('ID : $ID'),
                    Text('Position :$Position'),
                    Text('Status :$Status'),


                  ],);
                }
                else if (snapshot.hasError)
                  return Text(snapshot.error);
              },

            ),

            )
          ],
        ),
      ),
    );
  }
}