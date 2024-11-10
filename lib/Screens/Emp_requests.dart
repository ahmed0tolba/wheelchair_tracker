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

String seatnamedropdownItem = "";
List<String> seatnamedropdownItems = [''];
final _client = http.Client();
List<Map<String, String>> listOfColumns = [];
bool employeeisfree = true;
String gotopassengeremail = "";
Future<void> listrequests(context) async {
  // print("hi");
  try {
    //fullnames,genders,locations,requiredservices,chairsgoing
    http.Response response = await _client
        .post(Uri.parse("http://127.0.0.1:12000/listrequests?email=$email"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    if (responseDecoded['locations'].length > 0) {
      listOfColumns = [];
      for (int k = 0; k < responseDecoded['locations'].length; k++) {
        listOfColumns.add({
          "fullnames": responseDecoded['fullnames'][k] ?? "",
          "genders": responseDecoded['genders'][k] ?? "",
          "emails": responseDecoded['emails'][k] ?? "",
          "locations": responseDecoded['locations'][k] ?? "",
          "requiredservices": responseDecoded['requiredservices'][k] ?? "",
          "chairsgoing": responseDecoded['chairsgoing'][k].toString(),
          "appointmenttimes": responseDecoded['appointmenttimes'][k].toString()
        });
      }
      employeeisfree = responseDecoded['employeeisfree'] ?? true;
      gotopassengeremail = responseDecoded['gotopassengeremail'] ?? "";
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

Future<void> loadavailabledevicesnames(context) async {
  // print("hi");
  try {
    http.Response response = await _client
        .get(Uri.parse("http://127.0.0.1:12000/loadavailabledevicesnames"));
    var responseDecoded = jsonDecode(response.body);
    if (responseDecoded['availabledevicesnames'].length > 0) {
      seatnamedropdownItems = [];
      for (int k = 0;
          k < responseDecoded['availabledevicesnames'].length;
          k++) {
        seatnamedropdownItems.add(responseDecoded['availabledevicesnames'][k]);
      }
      // }
    } else {
      seatnamedropdownItems = [''];
    }
    seatnamedropdownItem = seatnamedropdownItems[0];
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

class emprequest extends StatefulWidget {
  const emprequest({Key? key}) : super(key: key);

  @override
  _emprequestState createState() => _emprequestState();
}

// flutter pub add http
class _emprequestState extends State<emprequest> {
  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      listOfColumns = [];
      listrequests(context).then((listMap) {
        loadavailabledevicesnames(context).then((listMap) {
          setState(() {});
        });
      });
    });
  }

  Future<void> iwilldotask(context, passengeremail) async {
    try {
      http.Response response = await _client.post(Uri.parse(
          "http://127.0.0.1:12000/iwilldotask?employeeemail=$email&passengeremail=$passengeremail&seatname=$seatnamedropdownItem"));
      var responseDecoded = jsonDecode(response.body);
      // print(responseDecoded);
      bool accepted = responseDecoded['success'];

      if (response.statusCode == 200) {
        if (accepted) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Request Accepted."),
                );
              });
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context, rootNavigator: true).pop(true);
          });
          listrequests(context).then((listMap) {
            setState(() {});
          });
        }
      }
    } on Exception catch (_) {
      // make it explicit that this function can throw exceptions
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 20), () {
              Navigator.of(context, rootNavigator: true).pop(true);
            });
            return const AlertDialog(
              title: Text(
                  '404 , unable to establish connection with server, check internet , make sure the server is running , type http://127.0.0.1:13000'),
            );
          });
      return;
    } on Exception catch (_) {}
  }

  Future<void> finishtask(
    context,
  ) async {
    try {
      http.Response response = await _client.post(
          Uri.parse("http://127.0.0.1:12000/finishtask?employeeemail=$email"));
      var responseDecoded = jsonDecode(response.body);
      // print(responseDecoded);
      bool accepted = responseDecoded['success'];

      if (response.statusCode == 200) {
        if (accepted) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Task marked as finished"),
                );
              });
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context, rootNavigator: true).pop(true);
          });
          listrequests(context).then((listMap) {
            setState(() {});
          });
        }
      }
    } on Exception catch (_) {
      // make it explicit that this function can throw exceptions
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 20), () {
              Navigator.of(context, rootNavigator: true).pop(true);
            });
            return const AlertDialog(
              title: Text(
                  '404 , unable to establish connection with server, check internet , make sure the server is running , type http://127.0.0.1:13000'),
            );
          });
      return;
    } on Exception catch (_) {}
  }

  // iwilldotask

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // wellcome back
              Text(
                "Welcome, $username",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 30),
              // wellcome back
              const Text(
                "Requests",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              DataTable(
                headingRowHeight: 40,
                // dataRowHeight: 70,
                columns: const [
                  //fullnames,genders,locations,requiredservices,chairsgoing
                  // DataColumn(label: Text('')),
                  // DataColumn(label: Text('passenger fullname')),
                  // DataColumn(label: Text('gender')),
                  // DataColumn(label: Text('required location')),
                  // DataColumn(label: Text('required service')),
                  DataColumn(label: Text('Request')),
                  // DataColumn(label: Text('chair is going')),
                  DataColumn(label: Text('Accept')),
                ],
                rows:
                    listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                        .map(
                          ((element) => DataRow(
                                color: MaterialStateColor.resolveWith((states) {
                                  if (!employeeisfree &&
                                      gotopassengeremail == element["emails"]) {
                                    return Color.fromARGB(255, 152, 255, 205);
                                  }
                                  return Color.fromARGB(0, 0, 0, 0);
                                }),
                                cells: <DataCell>[
                                  // DataCell(
                                  //   Container(
                                  //     width: 90,
                                  //     child: Row(
                                  //       children: [
                                  //         IconButton(
                                  //           onPressed: () {
                                  //             Navigator.of(context)
                                  //                 .push(MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   const TaskDelete(),
                                  //               settings: RouteSettings(
                                  //                 arguments:
                                  //                     element["Task number"],
                                  //               ),
                                  //             ));
                                  //           },
                                  //           icon: const Icon(Icons.cancel),
                                  //         ),
                                  //         IconButton(
                                  //           onPressed: () {
                                  //             Navigator.of(context)
                                  //                 .push(MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   const TaskEdit(),
                                  //               settings: RouteSettings(
                                  //                 arguments:
                                  //                     element["Task number"],
                                  //               ),
                                  //             ));
                                  //           },
                                  //           icon: const Icon(Icons.edit),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ), //Extracting from Map element the value
                                  // DataCell(Text(element["fullnames"]!)),
                                  // DataCell(Text(element["genders"]!)),
                                  // DataCell(Text(element["locations"]!)),
                                  DataCell(Text(
                                      "${element["fullnames"]!} requires a ${element["requiredservices"]!} at ${element["locations"]!} by ${element["appointmenttimes"]!}")),
                                  // DataCell(Text(element["requiredservices"]!)),
                                  // DataCell(Text(element["chairsgoing"]!)),
                                  if (!employeeisfree &&
                                      gotopassengeremail != element["emails"])
                                    const DataCell(
                                        Text("You already have a task")),
                                  if (!employeeisfree &&
                                      gotopassengeremail == element["emails"])
                                    const DataCell(Text("Your task")),
                                  if (employeeisfree)
                                    DataCell(
                                      IconButton(
                                        onPressed: () {
                                          showAlertDialogSelectChair(
                                              context, element["emails"]!);
                                        },
                                        icon: const Icon(Icons
                                            .check_circle_outline_outlined),
                                      ),
                                    ),

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

              const SizedBox(height: 30),

              if (!employeeisfree) const Text("You already have a task"),
              const SizedBox(height: 30),
              if (!employeeisfree)
                TextButton(
                  child: const Text("Mark task as finished"),
                  onPressed: () {
                    showAlertDialogFinishTask(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialogSelectChair(BuildContext context, String passengerfullname) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Confirm Accept"),
      onPressed: () {
        Navigator.pop(context);
        iwilldotask(context, passengerfullname);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Select your chair name (esp name)"),
      content: DropdownButton(
        value: seatnamedropdownItem,
        hint: const Text("Select your chair name (esp name)"),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: seatnamedropdownItems.map((String value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onTap: () {
          // setState(() {});
        },
        onChanged: (String? newValue) {
          setState(() {
            seatnamedropdownItem = newValue!;
          });
        },
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogFinishTask(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Finish"),
      onPressed: () {
        Navigator.pop(context);
        finishtask(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm Finish"),
      content:
          const Text("Are you sure you want to Set this task as finished?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

Widget _verticalDivider = const VerticalDivider(
  color: Colors.black,
  thickness: 1,
);
