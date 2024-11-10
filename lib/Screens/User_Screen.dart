import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Request_Screen.dart';
import 'package:aviaid_/components/MyAppBar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

final _client = http.Client();
List<Map<String, String>> listOfColumns = [];

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

var sessionManager = SessionManager();
dynamic email = "", usertype = "", username = "", employeeid = "";
Future<void> loadSessionVariable(context) async {
  email = await SessionManager().get("email");
  usertype = await SessionManager().get("usertype");
  username = await SessionManager().get("username");
  employeeid = await SessionManager().get("employeeid");
}

int needchair = 0;

Future<void> loadpassengerdata(context) async {
  // print("hi");
  try {
    //fullnames,genders,locations,requiredservices,chairsgoing
    http.Response response = await _client.get(
        Uri.parse("http://127.0.0.1:12000/loadpassengerdata?email=$email"));
    var responseDecoded = jsonDecode(response.body);
    needchair = responseDecoded['needchair'] ?? 0;

    print(responseDecoded);
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

class _UserScreenState extends State<UserScreen> {
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      loadpassengerdata(context).then((listMap) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              //Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Hello, $username',
                  style: GoogleFonts.robotoCondensed(
                      color: Color.fromARGB(255, 65, 93, 111),
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 70,
              ),

              //Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'Your Wheelchair Bookings: ',
                  style: GoogleFonts.robotoCondensed(fontSize: 27),
                ),
              ),

              SizedBox(
                height: 80,
              ),

              if (needchair == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'You curently have no wheelchairs booked for your travel with AviAid. ',
                    style: GoogleFonts.robotoCondensed(fontSize: 23),
                  ),
                ),
              if (needchair == 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'A chair is booked and on his way. ',
                    style: GoogleFonts.robotoCondensed(fontSize: 23),
                  ),
                ),
              SizedBox(
                height: 150,
              ),

              //Book Now button
              if (needchair == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestScreen()),
                      );
                    },
                    child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 100, maxWidth: 300),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 106, 122, 135),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Book Now!',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (needchair == 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RequestScreen()),
                      );
                    },
                    child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 100, maxWidth: 300),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 106, 122, 135),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Update Request',
                          style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
