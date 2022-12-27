import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Second extends StatefulWidget {
  const Second({super.key});

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {

  late Future<Album> _futureAlbum;
  bool buttonState = true;
  int queryNumber = 1;

  @override
  void initState() {
    super.initState();
    _futureAlbum = fetchData();
  }
  Future<Album>fetchData() async {
    log('fetch');
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/$queryNumber')); 
    if (response.statusCode == 200) {
      return Album.fromJson(jsonDecode(response.body));
    } else{
      throw Exception('Failed');
    }
    
  } 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: const [
        IconButton(
          onPressed: null, 
          icon: Icon(Icons.abc),
          tooltip: 'errre',)
      ],
      title: const Text("ert"),),
      body: Column (
        children:  [
          const Text("Container"),
          const Text("cont2"),
          ElevatedButton(onPressed: () {
            setState(() {
              queryNumber++;
             _futureAlbum =  fetchData();
             
             log("par la");
              buttonState = !buttonState;
            });
          }, child:  const Text("fetch")),
          FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(children: [
                    Text(snapshot.data!.title),
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          queryNumber=1;
                          fetchData();
                        });
                      }, 
                      child: const Text("data"))
                    ]);

                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }
              return const CircularProgressIndicator();
            },
            
          ),
          Text('$buttonState')
      ]
      
    ))  ;
  }
}

class Album {
  final int userId;
  final int id;
  final String title;
  const Album({
    required this.id,
    required this.userId,
    required this.title,
  });
  factory Album. fromJson(Map<String,dynamic> json) {
    return Album(id: json['id'], userId: json['userId'], title: json['title']);

  }
}