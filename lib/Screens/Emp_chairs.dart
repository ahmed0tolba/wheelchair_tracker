import 'package:aviaid_/components/MyAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter_session_manager/flutter_session_manager.dart';

dynamic email = "", usertype = "", username = "", employeeid = "";
Future<void> loadSessionVariable(context) async {
  email = await SessionManager().get("email");
  usertype = await SessionManager().get("usertype");
  username = await SessionManager().get("username");
  employeeid = await SessionManager().get("employeeid");
}

final _client = http.Client();
List<Map<String, String>> listOfColumns = [];

Future<void> loadchairssData(context) async {
  // print("hi");
  try {
    http.Response response =
        await _client.post(Uri.parse("http://127.0.0.1:12000/listchairsdata"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    String available = "Not used";
    if (responseDecoded['espsnames'].length > 0) {
      listOfColumns = [];
      for (int k = 0; k < responseDecoded['espsnames'].length; k++) {
        if (responseDecoded['espspassengeremail'][k] == "None" ||
            responseDecoded['espspassengeremail'][k] == "") {
          available = "Not used";
        } else {
          available = "Used";
        }
        listOfColumns.add({
          "espsnames": responseDecoded['espsnames'][k],
          "espslocations": responseDecoded['espslocations'][k] ?? "",
          "espslastlocationstimes":
              responseDecoded['espslastlocationstimes'][k] ?? "",
          "espsstatuss": responseDecoded['espsstatuss'][k] ?? "",
          "espspassengeremail": responseDecoded['espspassengeremail'][k],
          "available": available
        });
      }
      // }
    } else {
      listOfColumns = [];
    }
    // print(dropdownItems);
    // setState(() {});
  } on Exception catch (_) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 20), () {
            Navigator.of(context, rootNavigator: true).pop(true);
          });
          return const AlertDialog(
            title: Text(
                '404 , unable to establish connection with server, check internet , make sure the server is running , type http://127.0.0.1:12000'),
          );
        });
    return;
  }
}

class empchairs extends StatefulWidget {
  const empchairs({Key? key}) : super(key: key);

  @override
  _empchairsState createState() => _empchairsState();
}

// flutter pub add http
class _empchairsState extends State<empchairs> {
  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      setState(() {});
    });
    listOfColumns = [];
    loadchairssData(context).then((listMap) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // wellcome back
              Text(
                "Welcome, $username",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 10),
              // wellcome back
              const Text(
                "Chairs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              DataTable(
                headingRowHeight: 40,
                dataRowHeight: 70,
                columns: const [
                  DataColumn(label: Text('')),
                  DataColumn(label: Text('Chair name')),
                  DataColumn(label: Text('Chair location')),
                  DataColumn(label: Text('last locations times')),
                  DataColumn(label: Text('passenger email')),
                  DataColumn(label: Text('available')),
                ],
                rows:
                    listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                        .map(
                          ((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(
                                    Container(
                                      width: 90,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // Navigator.of(context)
                                              //     .push(MaterialPageRoute(
                                              //   builder: (context) =>
                                              //       const TaskDelete(),
                                              //   settings: RouteSettings(
                                              //     arguments:
                                              //         element["Task number"],
                                              //   ),
                                              // ));
                                            },
                                            icon: const Icon(Icons.cancel),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              // Navigator.of(context)
                                              //     .push(MaterialPageRoute(
                                              //   builder: (context) =>
                                              //       const TaskEdit(),
                                              //   settings: RouteSettings(
                                              //     arguments:
                                              //         element["Task number"],
                                              //   ),
                                              // ));
                                            },
                                            icon: const Icon(Icons.edit),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ), //Extracting from Map element the value
                                  DataCell(Text(element["espsnames"]!)),
                                  DataCell(Text(element["espslocations"]!)),
                                  DataCell(
                                      Text(element["espslastlocationstimes"]!)),
                                  DataCell(
                                      Text(element["espspassengeremail"]!)),
                                  DataCell(Text(element["available"]!)),
                                  // SizedBox(
                                  //   width: 280,
                                  //   height: 70,
                                  //   child: Row(
                                  //     children: [
                                  //       ButtonNavigate(
                                  //         buttonText: element["applied"]!,
                                  //         onTap: () {
                                  //           // Navigator.of(context)
                                  //           //     .push(MaterialPageRoute(
                                  //           //   builder: (context) =>
                                  //           //       const TaskApprove(),
                                  //           //   settings: RouteSettings(
                                  //           //     arguments:
                                  //           //         element["Task number"],
                                  //           //   ),
                                  //           // ));
                                  //         },
                                  //       ),
                                  //     ],
                                  //   ),
                                  // )

                                  // ),
                                ],
                              )),
                        )
                        .toList(),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _verticalDivider = const VerticalDivider(
  color: Colors.black,
  thickness: 1,
);
