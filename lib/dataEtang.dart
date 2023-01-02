import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;

class DataEtang extends StatefulWidget {
  const DataEtang({super.key});

  @override
  State<DataEtang> createState() => _DataEtangState();
}

class _DataEtangState extends State<DataEtang> {
  late Future<DataEtangT> _dataEtang;
  Timer fetchTimer = Timer(
    Duration.zero,
    () {},
  );

  @override
  void initState() {
    super.initState();
    _dataEtang = fetchData();
    setUpTimer();
  }
@override
  void dispose() {
    
    super.dispose();
    fetchTimer.cancel();
  }
  void setUpTimer() {
    fetchTimer = Timer.periodic(const Duration(seconds: 5), fetchTimerCb);
  }

  fetchTimerCb(timer) {
    setState(() {
      log("tick");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etang"),
      ),
      body: Column(
        children: [
          RangeSlider(
              min: 0,
              max: 100,
              values: const RangeValues(0, 50),
              onChanged: (v) {}),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _dataEtang =  fetchData();
                });
              },
              child: const Text("Fetch")),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  if (fetchTimer.isActive) {
                    fetchTimer.cancel();
                  } else {
                    fetchTimer = Timer.periodic(
                        const Duration(seconds: 5), fetchTimerCb);
                  }
                });
              },
              child: Text('periodic  ${fetchTimer.isActive}')),
          Text(fetchTimer.isActive.toString()),
          FutureBuilder<DataEtangT>(
            future: _dataEtang,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  log('has data');

                  return dataEtangTModel(snapshot.data!);
                } else {
                  return const Text("noData");
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

  Future<DataEtangT> fetchData() async {
    final response =
        await http.get(Uri.parse('http://hydro.hydro-babiat.ovh/dataEtang'));
    log(response.statusCode.toString());
    log(response.body);
    if (response.statusCode == 200) {
      return DataEtangT.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Errerur fetching');
    }
  }
}

class DataEtangT {
  final double niveauEtang;
  final double niveauEtangP;
  const DataEtangT({
    required this.niveauEtang,
    required this.niveauEtangP,
  });
  factory DataEtangT.fromJson(Map<String, dynamic> json) {
    log('from json');
    return DataEtangT(
        niveauEtang: json['niveauEtang'], niveauEtangP: json['niveauEtangP']);
  }
}

class NodeStatus {
  final int rssi;
  final int snr;
  final int dernierMessage;
  final int addr;
  final String name;
  final bool active;
  const NodeStatus(
      {required this.name,
      required this.rssi,
      required this.snr,
      required this.active,
      required this.addr,
      required this.dernierMessage});
  factory NodeStatus.fromJson(Map<String, dynamic> json) {
    return NodeStatus(
        name: json['name'],
        rssi: json['rssi'],
        snr: json['snr'],
        active: json['active'],
        addr: json['addr'],
        dernierMessage: json['derniermesage']);
  }
}

dataEtangTModel(DataEtangT data) {
  
  log('fn');
  TextStyle style = const TextStyle(fontSize: 20);
  return Container(
    margin: const EdgeInsets.all(8),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.blue,
    ),
    child: Column(
      children: [
        Card(
          
            child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.none,
              child: Text("Etang", style: style),
            )),
        Row(children: [
          Text(
            "Niveau: ",
            style: style,
          ),
          Text(data.niveauEtang.toString(), style: style),
        ]),
        Row(children: [
          Text(
            "Pourcentage : ",
            style: style,
          ),
          Text(
            data.niveauEtangP.toString(),
            style: style,
          ),
        ])
      ],
    ),
  );
}
