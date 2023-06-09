import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_database/firebase_database.dart';

// home page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controller untuk google map
  final Completer<GoogleMapController> controller = Completer();
  // string untuk menyimpan tema map
  String mapTheme = '';

  // posisi awal pada map
  static const CameraPosition _initialPos = CameraPosition(
    target: LatLng(-6.2024787, 106.7825044),
    zoom: 16.4746,
  );

  // posisi marker pada map (bin1)
  static final Marker _bin1 = Marker(
    markerId: const MarkerId('bin1'),
    position: const LatLng(-6.2024787, 106.7825044),
    infoWindow: const InfoWindow(title: 'Bin 1'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
  );

  @override
  void initState() {
    super.initState();
    // load tema map dari file json ke mapTheme
    DefaultAssetBundle.of(context)
        .loadString('assets/darkmode.json')
        .then((value) {
      mapTheme = value;
    });
  }

  // database reference untuk mengambil data dari firebase pada gauge nantinya
  final databaseReference = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    final capacityRef = databaseReference
        .child('Read')
        .child('Tong1')
        .child('capacity')
        .onValue;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Welcome back, ${FirebaseAuth.instance.currentUser!.email}!',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 203, 203, 203),
                    fontSize: 24,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: const Color.fromARGB(255, 203, 203, 203),
                    width: 0.5,
                  )),
                  child: GoogleMap(
                    initialCameraPosition: _initialPos,
                    markers: {
                      _bin1,
                    },
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(mapTheme);
                    },
                    mapType: MapType.normal,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        width: 165,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 34, 34, 34),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 99, 96, 96),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Status:",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Text("ONLINE",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 145, 221, 147),
                                    fontSize: 25,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 165,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 34, 34, 34),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 99, 96, 96),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 8.0, top: 8, right: 8),
                            child: Text("Fullness:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          SizedBox(
                            width: 165,
                            height: 70,
                            child: StreamBuilder<DatabaseEvent>(
                              stream: capacityRef,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final capacity =
                                      snapshot.data!.snapshot.value as int;
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
                                          thickness: 3,
                                          cornerStyle: CornerStyle.startCurve,
                                        ),
                                        pointers: <GaugePointer>[
                                          RangePointer(
                                              value: val,
                                              width: 5,
                                              pointerOffset: -6,
                                              cornerStyle:
                                                  CornerStyle.bothCurve,
                                              gradient: const SweepGradient(
                                                  colors: <Color>[
                                                    Color.fromARGB(
                                                        255, 255, 148, 130),
                                                    Color.fromARGB(
                                                        255, 125, 119, 255),
                                                  ],
                                                  stops: <double>[
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
                                                Text(
                                                  ' $capacity%',
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
