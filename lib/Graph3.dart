import 'dart:developer' as debug;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Graph3 extends StatefulWidget {
  const Graph3({super.key});

  @override
  State<Graph3> createState() => _Graph3State();
}

class _Graph3State extends State<Graph3> {
  List<_SalesData> data = [
    _SalesData(2000, 35),
    _SalesData(2001, 28),
    _SalesData(2002, 34),
    _SalesData(2003, 32),
    _SalesData(2004, 40)
  ];
  int year = 2004;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //actions: [],
          title: const Text('Syncfusio Flutter'),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: _addData,
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
        ),
        body: Column(children: [
          
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: 'halg'),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_SalesData, String>>[
                LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, index) => sales.year.toString(),
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: true)),
              ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfSparkLineChart.custom(
                //Enable the trackball
                trackball: const SparkChartTrackball(
                    activationMode: SparkChartActivationMode.tap),
                //Enable marker
                marker: const SparkChartMarker(
                    displayMode: SparkChartMarkerDisplayMode.all),
                //Enable data label
                labelDisplayMode: SparkChartLabelDisplayMode.all,
                xValueMapper: (int index) => data[index].year,
                yValueMapper: (int index) => data[index].sales,
                dataCount: 5,
              ),
            ),
          ),
      ElevatedButton(onPressed: (){
        setState(() {
          
          
          data.add(_SalesData(++year, Random().nextDouble()));
        });
      }, child: const Text('Add')),
      
      ])
      );
  }
  
  _addData() {
    setState(() {
       debug.log('log');
      data.add(_SalesData(++year, Random().nextDouble() *2));
    });
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);
  final int year;
  final double sales;
}
