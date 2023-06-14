import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class ChartData untuk menampung data dari json string yang sudah di decode menjadi Map
class ChartData {
  ChartData(this.date, this.fullness, this.weight);

  final String date;
  final int fullness;
  final int weight;

  factory ChartData.fromJson(Map<String, dynamic> parsedJson) {
    return ChartData(
      parsedJson['date'].toString(),
      parsedJson['fullness'],
      parsedJson['weight'],
    );
  }
}

class StatisticChart extends StatefulWidget {
  const StatisticChart({Key? key}) : super(key: key);

  @override
  State<StatisticChart> createState() => _StatisticChartState();
}

class _StatisticChartState extends State<StatisticChart> {
  // list kosong yang digunakan untuk menampung data yang akan digunakan pada chart nantinya
  List<ChartData> chartData = [];

  // fungsi untuk request http get ke url json firebase dan mengambil data json sebagai string
  Future<String> getJsonForChart() async {
    String url =
        "https://esp-scale-default-rtdb.asia-southeast1.firebasedatabase.app/LogTest.json";
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  // fungsi untuk menambahkan data dari getJsonForChart ke list chartData
  Future<void> loadChartData() async {
    String jsonString = await getJsonForChart();
    final jsonResponse = json.decode(jsonString);
    setState(() {
      chartData.clear(); // Clear the existing chart data
      for (Map<String, dynamic> i in jsonResponse) {
        chartData.add(ChartData.fromJson(i));
      }
    });
  }

  // inisialisasi state dan untuk load data chart pertama kali
  @override
  void initState() {
    loadChartData();
    super.initState();
  }

  // fungsi untuk refresh data chart
  Future<void> _refreshChartData() async {
    await loadChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      // refresh indicator untuk refresh data chart apabila terdapat perubahan data
      body: RefreshIndicator(
        onRefresh: _refreshChartData,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 300,
                    width: 500,
                    // futurebuilder akan mengembalikan chart SfCartesianChart apabila fungsi getJsonForChart sudah selesai, jika belum akan ditampilkan indikator loading
                    child: FutureBuilder(
                        future: getJsonForChart(),
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
                            return SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                tooltipBehavior: TooltipBehavior(enable: true),
                                primaryXAxis: CategoryAxis(
                                  labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: 'Nunito',
                                  ),
                                  labelAlignment: LabelAlignment.center,
                                  interval: 1,
                                  edgeLabelPlacement: EdgeLabelPlacement.none,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                  labelFormat: '{value}%',
                                  labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: 'Nunito',
                                  ),
                                  minimum: 0,
                                  maximum: 100,
                                  interval: 20,
                                  majorTickLines: const MajorTickLines(
                                      color: Colors.transparent),
                                ),
                                title: ChartTitle(
                                  text: 'Bin Capacity Chart',
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                                series: <ChartSeries<ChartData, String>>[
                                  LineSeries<ChartData, String>(
                                      name: 'Capacity',
                                      animationDuration: 2500,
                                      dataSource: chartData,
                                      xValueMapper: (ChartData cap, _) =>
                                          cap.date,
                                      yValueMapper: (ChartData cap, _) =>
                                          cap.fullness,
                                      color: const Color.fromARGB(
                                          255, 125, 119, 255),
                                      markerSettings: const MarkerSettings(
                                        isVisible: true,
                                        color: Colors.white,
                                      ))
                                ]);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                          }
                        }),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 300,
                    width: 500,
                    child: FutureBuilder(
                        future: getJsonForChart(),
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
                            return SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                tooltipBehavior: TooltipBehavior(enable: true),
                                primaryXAxis: CategoryAxis(
                                  labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: 'Nunito',
                                  ),
                                  labelAlignment: LabelAlignment.center,
                                  interval: 1,
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                ),
                                primaryYAxis: NumericAxis(
                                  labelFormat: '{value}g',
                                  labelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontFamily: 'Nunito',
                                  ),
                                  minimum: 0,
                                  maximum: 5000,
                                  interval: 1000,
                                  majorTickLines: const MajorTickLines(
                                      color: Colors.transparent),
                                ),
                                title: ChartTitle(
                                  text: 'Bin Weight Chart',
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                ),
                                series: <ChartSeries<ChartData, String>>[
                                  LineSeries<ChartData, String>(
                                      name: 'Weight',
                                      animationDuration: 2500,
                                      dataSource: chartData,
                                      xValueMapper: (ChartData weight, _) =>
                                          weight.date,
                                      yValueMapper: (ChartData weight, _) =>
                                          weight.weight,
                                      color: const Color.fromARGB(
                                          255, 255, 148, 130),
                                      markerSettings: const MarkerSettings(
                                        isVisible: true,
                                        color: Colors.white,
                                      ))
                                ]);
                          } else {
                            return const Center(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
