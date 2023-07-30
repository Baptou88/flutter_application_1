import 'dart:convert';
import 'dart:developer';

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
  double _sliderValue = 0;
  final int _sliderMul = 100;
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
      body: ListView(children: [
        Column (
        children:  [
          const Text("Container"),
          const ElevatedCardExample(),
          const FilledCardExample(),
          const OutlinedCardExample(),
           DatePickerDialog(initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.utc(2023,11,30)),
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
          Text('$buttonState'),
          Slider(
            value: _sliderValue * _sliderMul, 
            max: (100 * _sliderMul.toDouble()),
            divisions: 1 * _sliderMul,
            onChanged: (double value) {
              setState(() {
                _sliderValue = value / _sliderMul;
              });
            }
          ),
          Text("$_sliderValue")
      ]
      
    )
      ],))  ;
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

class ElevatedCardExample extends StatelessWidget {
  const ElevatedCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card(
        child: SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Elevated Card')),
        ),
      ),
    );
  }
}
class FilledCardExample extends StatelessWidget {
  const FilledCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.surfaceVariant,
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Filled Card')),
        ),
      ),
    );
  }
}

/// An example of the outlined card type.
///
/// To make a [Card] match the outlined type, the default elevation and shape
/// need to be changed to the values from the spec:
///
/// https://m3.material.io/components/cards/specs#0f55bf62-edf2-4619-b00d-b9ed462f2c5a
class OutlinedCardExample extends StatelessWidget {
  const OutlinedCardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: const SizedBox(
          width: 300,
          height: 100,
          child: Center(child: Text('Outlined Card')),
        ),
      ),
    );
  }
}
