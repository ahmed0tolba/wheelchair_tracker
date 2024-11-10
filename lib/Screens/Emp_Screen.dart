import 'package:aviaid_/Screens/Emp_chairs.dart';
import 'package:aviaid_/Screens/Emp_requests.dart';
import 'package:aviaid_/Screens/Emp_requests_big.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aviaid_/components/MyAppBar.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

class EmpScreen extends StatefulWidget {
  const EmpScreen({super.key});

  @override
  State<EmpScreen> createState() => _EmpScreenState();
}

dynamic email = "", usertype = "", username = "", employeeid = "";
Future<void> loadSessionVariable(context) async {
  email = await SessionManager().get("email");
  usertype = await SessionManager().get("usertype");
  username = await SessionManager().get("username");
  employeeid = await SessionManager().get("employeeid");
}

class _EmpScreenState extends State<EmpScreen> {
  @override
  void initState() {
    super.initState();
    loadSessionVariable(context).then((listMap) {
      setState(() {});
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
                      color: const Color.fromARGB(255, 65, 93, 111),
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              //Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  'ID : $employeeid \n Role: $usertype ',
                  style: GoogleFonts.robotoCondensed(fontSize: 20),
                ),
              ),

              const SizedBox(
                height: 80,
              ),

              // Check Chairs button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 106, 122, 135),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const empchairs()));
                        },
                        child: const Text('Check Chairs'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.robotoCondensed(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              //Check Requests button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 106, 122, 135),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const emprequest()));
                          },
                          child: const Text('Check Requests'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            textStyle: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      )),
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              // Check Requests Details button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 106, 122, 135),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const emprequestbig()));
                        },
                        child: const Text('Check Requests Details'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.robotoCondensed(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
