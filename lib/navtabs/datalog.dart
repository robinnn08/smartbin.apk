import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class log yang digunakan untuk menampung data dari url json yang diambil dari firebase
class Log {
  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      date: json['date'] ?? '', // jika date null, maka date = '' (empty string)
      time: json['time'] ?? '', // jika time null, maka time = '' (empty string)
      status: json['status'] ??
          '', // jika status null, maka status = '' (empty string)
      capacity: json['fullness'] ?? 0, // jika fullness null, maka capacity = 0
      weight: json['weight'] ?? 0,
    ); // jika weight null, maka weight = 0
  }
  Log({
    required this.date,
    required this.time,
    required this.status,
    required this.capacity,
    required this.weight,
  });
  final String? date;
  final String? time;
  final String? status;
  final int? capacity;
  final int? weight;
}

// class LogDataGridSource sebagai sumber data untuk menampilkan data pada row2 di SfDataGrid
class LogDataGridSource extends DataGridSource {
  LogDataGridSource(this.logList) {
    buildDataGridRow();
  }
  late List<DataGridRow> dataGridRows;
  late List<Log> logList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[0].value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Nunito',
          ),
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Nunito',
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[2].value,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: row.getCells()[2].value == 'AVAILABLE'
                ? const Color.fromARGB(255, 145, 221, 147)
                : Colors.red,
            fontFamily: 'Nunito',
          ),
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '${row.getCells()[3].value} %',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontFamily: 'Nunito',
          ),
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${row.getCells()[4].value} g',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontFamily: 'Nunito',
            ),
          ))
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;
  // mapping data dari logList (list dari class Log) ke dalam list dataGridRows
  void buildDataGridRow() {
    dataGridRows = logList.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'date', value: dataGridRow.date),
        DataGridCell<String>(columnName: 'time', value: dataGridRow.time),
        DataGridCell<String>(columnName: 'status', value: dataGridRow.status),
        DataGridCell<int>(columnName: 'capacity', value: dataGridRow.capacity),
        DataGridCell<int>(columnName: 'weight', value: dataGridRow.weight)
      ]);
    }).toList(growable: false);
  }
}

class DataLog extends StatefulWidget {
  const DataLog({super.key});

  @override
  State<DataLog> createState() => _DataLogState();
}

class _DataLogState extends State<DataLog> {
  // mengambil data dari url json yang diambil dari firebase,
  // kemudian di decode menjadi Map<String, dynamic>
  // lalu di mapping menjadi List<Log>
  Future<List<Log>> generateLogList() async {
    var response = await http.get(Uri.parse(
        'https://esp-scale-default-rtdb.asia-southeast1.firebasedatabase.app/LogTest.json'));
    var decodedLogs = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Log> logList =
        await decodedLogs.map<Log>((json) => Log.fromJson(json)).toList();
    return logList;
  }

  // mengambil data menggunakan fungsi generateLogList()
  // kemudian memasukkan data tersebut ke dalam LogDataGridSource
  // untuk ditampilkan sebagai sumber data pada SfDataGrid
  Future<LogDataGridSource> getLogDataSource() async {
    var logList = await generateLogList();
    return LogDataGridSource(logList);
  }

  // list dari GridColumn yang merupakan judul dari setiap kolom pada SfDataGrid
  // setiap GridColumn memiliki columnName yang sama dengan nama property pada DataGridCell
  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
          columnName: 'date',
          width: 88,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Date',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ))),
      GridColumn(
          columnName: 'time',
          width: 77,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Time',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ))),
      GridColumn(
          columnName: 'status',
          width: 90,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text(
                'Status',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ))),
      GridColumn(
          columnName: 'capacity',
          width: 85,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text(
                'Capacity',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ))),
      GridColumn(
          columnName: 'weight',
          width: 75,
          label: Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: const Text(
                'Weight',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ))),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      // digunakan FutureBuilder untuk menunggu data dari getLogDataSource()
      // yaitu Future<LogDataGridSource>
      // jika data sudah didapatkan, maka akan ditampilkan tabel data gridnya
      body: FutureBuilder(
        future: getLogDataSource(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? SfTheme(
                  data: SfThemeData(
                      dataGridThemeData: SfDataGridThemeData(
                    brightness: Brightness.dark,
                    gridLineColor: const Color.fromARGB(255, 156, 156, 156),
                  )),
                  child: SfDataGrid(
                    rowHeight: 80,
                    columnWidthMode: ColumnWidthMode.fill,
                    allowPullToRefresh: true,
                    source: snapshot.data,
                    columns: getColumns(),
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
        },
      ),
    );
  }
}
