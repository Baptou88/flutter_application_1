
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';

class Graph2 extends StatefulWidget {
  const Graph2({super.key});

  
  @override
  State<Graph2> createState() => _Graph2State();
}

class _Graph2State extends State<Graph2> {
  final List<Feature> features = [
    Feature(
      title: "Drink Water",
      color: Colors.blue,
      data: [0.2, 0.8, 0.4, 0.7, 0.6],
    ),
    Feature(
      title: "Exercise",
      color: Colors.pink,
      data: [1, 0.8, 0.6, 0.7, 0.3],
    ),
    Feature(
      title: "Study",
      color: Colors.cyan,
      data: [0.5, 0.4, 0.85, 0.4, 0.7],
    ),
    Feature(
      title: "Water Plants",
      color: Colors.green,
      data: [0.6, 0.2, 0, 0.1, 1],
    ),
    Feature(
      title: "Grocery Shopping",
      color: Colors.amber,
      data: [0.25, 1, 0.3, 0.8, 0.6],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromARGB(103, 255, 193, 7),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(" Chart"),
      ),
      body:(
      //mainAxisAlignment: MainAxisAlignment.spaceAround,
      //crossAxisAlignment: CrossAxisAlignment.center,
      Column(children: [
        Container(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 64.0),
          child: Text(
            "Tasks Track",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        LineGraph(
          features: features,
          size: const Size(320, 400),
          labelX: const ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5'],
          labelY: const ['20%', '40%', '60%', '80%', '100%'],
          showDescription: true,
          graphColor: Colors.white30,
          graphOpacity: 0.2,
          verticalFeatureDirection: true,
          descriptionHeight: 130,
        ),
        ElevatedButton(onPressed: (){
          setState(() {
            features[0].data.add(3);
            List<double> data = features[0].data;
            log('$data');
          });
        }, child: const Text("er"))

      ],
    )
    ));
  }
}