import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchList extends StatefulWidget {
  const FetchList({super.key});

  @override
  State<FetchList> createState() => _FetchListState();
}

class _FetchListState extends State<FetchList> {
  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber.shade100,
          title: const Text('fetch list'),
        ),
        // body: Column(
        //   children: [
        //     Row(
        //       children: [
        //         const Text("fetch"),
        //         ElevatedButton(
        //             onPressed: () {
        //               setState(() {
        //                 var test = fetch();
        //                 test.then((value) {
        //                   log("par la");
        //                   log('${value.length}');
        //                   log('${value[0].id}');
        //                   value.map((e) => log('${e.id}'));
        //                   for (var element in value) {
        //                     log('${element.id}');
        //                   }
        //                 });
        //               });
        //             },
        //             child: const Text("Fetch")),
        //       ],
        //     ),
        body: FutureBuilder<List<Album>>(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.cyan.shade500),
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Text(snapshot.data![index].title),
                          Text('${snapshot.data![index].id}'),
                        ],
                      ));
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const CircularProgressIndicator();
            }
          },
        )
        //   ],
        // )
        );
  }

  Future<List<Album>> fetch() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
    List<Album> luist;
    log('fetch');
    if (response.statusCode == 200) {
      //luist = List.from(jsonDecode(response.body));
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Album.fromJson(data)).toList();
      //log('$luist');
    } else {
      throw Exception('Exception');
    }
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
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], userId: json['userId'], title: json['title']);
  }
}
