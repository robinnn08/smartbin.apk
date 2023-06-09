import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';

// dashboard
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    // capacityRef untuk mengambil data kapasitas dari database
    final capacityRef = databaseReference
        .child('Read')
        .child('Tong1')
        .child('capacity')
        .onValue;
    // weightRef untuk mengambil data berat dari database
    final weightRef =
        databaseReference.child('Read').child('Tong1').child('weight1').onValue;
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.9),
        body: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              // StreamBuilder untuk mengambil data kapasitas dari database melalui stream capacityRef secara realtime
              child: StreamBuilder<DatabaseEvent>(
                stream: capacityRef,
                builder: (context, snapshot) {
                  //Jika data sudah didapat maka akan ditampilkan sebuah gauge
                  if (snapshot.hasData) {
                    final capacity = snapshot.data!.snapshot.value as int;
                    final val = capacity.toDouble();
                    return SfRadialGauge(
                      enableLoadingAnimation: true,
                      animationDuration: 2000,
                      axes: <RadialAxis>[
                        RadialAxis(
                            showLabels: false,
                            showTicks: false,
                            maximum: 100,
                            radiusFactor: 0.75,
                            interval: 1,
                            axisLineStyle: const AxisLineStyle(
                              thickness: 5,
                              cornerStyle: CornerStyle.startCurve,
                            ),
                            pointers: <GaugePointer>[
                              RangePointer(
                                  value: val,
                                  width: 15,
                                  pointerOffset: -6,
                                  cornerStyle: CornerStyle.bothCurve,
                                  gradient: const SweepGradient(colors: <Color>[
                                    Color.fromARGB(255, 255, 148, 130),
                                    Color.fromARGB(255, 125, 119, 255),
                                  ], stops: <double>[
                                    0.25,
                                    0.75
                                  ])),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                angle: 90,
                                widget: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Capacity',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                    Text(
                                      ' $capacity%',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ],
                                ),
                              ),
                              const GaugeAnnotation(
                                angle: 124,
                                positionFactor: 1.1,
                                widget: Text(
                                  '0',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 249, 248, 248),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              const GaugeAnnotation(
                                angle: 54,
                                positionFactor: 1.1,
                                widget: Text(
                                  '100',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 249, 248, 248),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ])
                      ],
                    );
                  }
                  // jika error saat mengambil data dari database maka akan ditampilkan text error
                  else if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  // jika data belum didapat maka akan ditampilkan sebuah loading indicator
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                },
              ),
            ),
            SizedBox(
              height: 300,
              // StreamBuilder untuk mengambil data berat dari database melalui stream weightRef secara realtime
              child: StreamBuilder<DatabaseEvent>(
                stream: weightRef,
                builder: (context, snapshot) {
                  //Jika data sudah didapat maka akan ditampilkan sebuah gauge
                  if (snapshot.hasData) {
                    final weight = snapshot.data!.snapshot.value as int;
                    final val1 = weight.toDouble();
                    return SfRadialGauge(
                      enableLoadingAnimation: true,
                      animationDuration: 2000,
                      axes: <RadialAxis>[
                        RadialAxis(
                            showLabels: false,
                            showTicks: false,
                            maximum: 2000,
                            radiusFactor: 0.75,
                            interval: 1,
                            axisLineStyle: const AxisLineStyle(
                              thickness: 5,
                              cornerStyle: CornerStyle.startCurve,
                            ),
                            pointers: <GaugePointer>[
                              RangePointer(
                                  value: val1,
                                  width: 15,
                                  pointerOffset: -6,
                                  cornerStyle: CornerStyle.bothCurve,
                                  gradient: const SweepGradient(colors: <Color>[
                                    Color.fromARGB(255, 238, 77, 95),
                                    Color.fromARGB(255, 255, 205, 165),
                                  ], stops: <double>[
                                    0.25,
                                    0.75
                                  ])),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                angle: 90,
                                widget: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Weight',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                    Text(
                                      '$weight g',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                  ],
                                ),
                              ),
                              const GaugeAnnotation(
                                angle: 124,
                                positionFactor: 1.1,
                                widget: Text(
                                  '0',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 249, 248, 248),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              const GaugeAnnotation(
                                angle: 54,
                                positionFactor: 1.1,
                                widget: Text(
                                  '2000',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 249, 248, 248),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ])
                      ],
                    );
                  }
                  // jika error saat mengambil data dari database maka akan ditampilkan text error
                  else if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  // jika data belum didapat maka akan ditampilkan sebuah loading indicator
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                },
              ),
            ),
          ],
        ));
  }
}
