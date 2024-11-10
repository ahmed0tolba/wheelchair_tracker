import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aviaid_/components/ButtonLogin.dart';
import 'package:aviaid_/Screens/EmpLogin_Screen.dart';

// id fullname,nationality,gender,birthday,ssn,employeeid,email,password
final fullnameController = TextEditingController();
var nationality;
var gender;
DateTime birthday = DateTime.now();
final ssnController = TextEditingController();
final employeeidController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();

final _client = http.Client();

Future<void> addEmployee(context) async {
  final String fullname = fullnameController.text;
  final String ssn = ssnController.text;
  final String employeeid = employeeidController.text;
  final String email = emailController.text;
  final String password = passwordController.text;

  try {
    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:12000/addemployee?fullname=$fullname&nationality=$nationality&gender=$gender&birthday=$birthday&ssn=$ssn&employeeID=$employeeid&email=$email&password=$password"));
    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    bool accepted = responseDecoded['success'];
    String message = responseDecoded['message'];
    int status = responseDecoded['status'];
    if (response.statusCode == 200) {
      if (accepted) {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 5), () {
                Navigator.of(context, rootNavigator: true).pop(true);
              });
              return const AlertDialog(
                title: Text("Employee added successfuly."),
              );
            });
        Future.delayed(const Duration(milliseconds: 500), () {
          // Here you can write your code
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const EmpLoginScreen()));
        });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 10), () {
                Navigator.of(context, rootNavigator: true).pop(true);
              });
              return AlertDialog(
                title: Text(message),
              );
            });
        // wrong input
      }
    } else {
      // not 200
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

class EmpSingupScreen extends StatefulWidget {
  const EmpSingupScreen({super.key});

  @override
  State<EmpSingupScreen> createState() => _EmpSignupScreenState();
}

class _EmpSignupScreenState extends State<EmpSingupScreen> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: birthday,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != birthday) {
      setState(() {
        birthday = picked;
      });
    }
  }

  AppBar _AppBar() {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 65, 93, 111),
      title: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        height: 32,
      ),
    );
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
              //Title
              Text(
                ' ',
                style: GoogleFonts.robotoCondensed(
                    fontSize: 40, fontWeight: FontWeight.bold),
              ),

              //Full name Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: fullnameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Full Name',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //Nationality Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButtonFormField(
                  value: nationality,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Nationality',
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'Saudia Arabia', child: Text('Saudia Arabia')),
                    DropdownMenuItem(value: 'Kuwait', child: Text('Kuwait')),
                  ],
                  onChanged: (value) {
                    nationality = value;
                    // Handle the selected value here
                  },
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //Gender Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: DropdownButtonFormField(
                  value: gender,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Gender',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    gender = value;
                    // Handle the selected value here
                  },
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black54,
                    minimumSize: const Size.fromHeight(50),
                    alignment: Alignment
                        .centerLeft, // Align button content to the left
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft, // Align text to the left
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the left
                      children: [
                        const Text(
                          'Select Your date of birth',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "${birthday.toLocal()}".split(' ')[0],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              //Birth Date Textfield

              // Row(
              //   children: <Widget>[
              //     // const Expanded(flex: 1, child: Text("")),
              //     Expanded(
              //       // flex: 4,
              //       child: // First Name
              //           ElevatedButton(
              //         onPressed: () => _selectDate(context),
              //         child: Text("${birthday.toLocal()}".split(' ')[0]),
              //       ),
              //     ),
              //     // const Expanded(flex: 1, child: Text("")),
              //     // Expanded(
              //     //   flex: 8,
              //     //   child: // username field
              //     //       Text("${birthday.toLocal()}".split(' ')[0]),
              //     // ),
              //     // const Expanded(flex: 1, child: Text(""))
              //   ],
              // ),

              const SizedBox(
                height: 10,
              ),

              //SSN Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: ssnController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'SSN',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //Employee ID Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: employeeidController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Employee ID ',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //Email Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //Password Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              //Sign up button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: ButtonLogin(
                        onTap: () async {
                          await addEmployee(context);
                        },
                        buttonText: "Sign Up",
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
