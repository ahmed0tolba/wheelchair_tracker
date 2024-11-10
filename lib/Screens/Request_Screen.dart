import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session_manager/flutter_session_manager.dart';

dynamic email = "", usertype = "", username = "", employeeid = "";
Future<void> loadSessionVariable(context) async {
  email = await SessionManager().get("email");
  usertype = await SessionManager().get("usertype");
  username = await SessionManager().get("username");
  employeeid = await SessionManager().get("employeeid");
}

List<String> locationsdropdownItems = [''];
String locationdropdownItem = "";
String requiredservice = "";
DateTime appointmenttime = DateTime.now();

final _client = http.Client();

Future<void> createrequest(context) async {
  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:12000/createrequest?email=$email&location=$locationdropdownItem&requiredservice=$requiredservice&appointmenttime=$appointmenttime"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    bool accepted = responseDecoded['success'];
    String message = responseDecoded['message'];

    if (response.statusCode == 200) {
      if (accepted) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Request posted successfuly."),
              );
            });
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context, rootNavigator: true).pop(true);
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => const Task()));
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(message),
              );
            });
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.of(context, rootNavigator: true).pop(true);
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
                '404 , unable to establish connection with server, check internet , make sure the server is running , type http://127.0.0.1:12000'),
          );
        });
    return;
  }
}

Future<void> loadlocations(context) async {
  // print("hi");
  try {
    http.Response response =
        await _client.get(Uri.parse("http://127.0.0.1:12000/listlocations"));
    var responseDecoded = jsonDecode(response.body);
    if (responseDecoded['locations_list'].length > 0) {
      locationsdropdownItems = [];
      for (int k = 0; k < responseDecoded['locations_list'].length; k++) {
        locationsdropdownItems.add(responseDecoded['locations_list'][k]);
      }
      // }
    } else {
      locationsdropdownItems = [''];
    }
    locationdropdownItem = locationsdropdownItems[0];
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

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

AppBar _AppBar() {
  return AppBar(
    backgroundColor: const Color.fromARGB(255, 65, 93, 111),
  );
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      loadlocations(context).then((listMap) {
        // list = [];
        setState(() {});
      });
    });

    // loadTasksData().then((listMap) {
    //   setState(() {});
    // });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: appointmenttime,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != appointmenttime) {
      setState(() {
        appointmenttime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //Request Assistance Service Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Type of Assistance Service',
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: '', child: Text('No assistance service')),
                    DropdownMenuItem(
                        value: 'rampwheelchair',
                        child: Text('Ramp wheelchair assistance service')),
                    DropdownMenuItem(
                        value: 'stairswheelchair',
                        child: Text('Stairs wheelchair assistance service')),
                    DropdownMenuItem(
                        value: 'cabinwheelchair',
                        child: Text('Cabin wheelchair assistance service')),
                  ],
                  onChanged: (value) {
                    requiredservice = value!;
                    // Handle the selected value here
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: // First Name
                        Text(
                      "Select your location:",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: // username field
                        DropdownButton(
                      value: locationdropdownItem,
                      hint: const Text("Select your location"),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: locationsdropdownItems.map((String value) {
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
                          locationdropdownItem = newValue!;
                        });
                      },
                    ),
                  ),
                  const Expanded(flex: 2, child: Text(""))
                ],
              ),

              const SizedBox(
                height: 1,
              ),

              //Send Request button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black54,
                    backgroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                    alignment: Alignment
                        .centerLeft, // Align button content to the left
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the left
                    children: [
                      const Text(
                        'Select time',
                        textAlign: TextAlign.left, // Align text to the left
                      ),
                      Text(
                        "${appointmenttime.toLocal()}".split(' ')[0],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 200,
              ),

              //Send Request button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  onTap: () async {
                    await createrequest(context);
                  },
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 100, maxWidth: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 106, 122, 135),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                        child: Text(
                      ' Send Request ',
                      style: GoogleFonts.robotoCondensed(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
