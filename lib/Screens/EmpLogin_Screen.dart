import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:aviaid_/Screens/User_Screen.dart';
import 'EmpSignUp_Screen.dart';
import 'package:aviaid_/Screens/Emp_Screen.dart';
import 'package:aviaid_/components/ButtonLogin.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();
final _client = http.Client();

class EmpLoginScreen extends StatefulWidget {
  const EmpLoginScreen({super.key});

  @override
  State<EmpLoginScreen> createState() => _EmpLoginScreenState();
}

AppBar _AppBar() {
  return AppBar(
    backgroundColor: Color.fromARGB(255, 65, 93, 111),
    title: Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain,
      height: 32,
    ),
  );
}

class _EmpLoginScreenState extends State<EmpLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signUserIn(context) async {
    var email = emailController.text;

    final password = passwordController.text;

    http.Response response = await _client.post(Uri.parse(
        "http://127.0.0.1:12000/login?email=$email&password=$password"));

    var responseDecoded = jsonDecode(response.body);
    print(responseDecoded);
    bool accepted = responseDecoded['success'];
    String usertype = responseDecoded['usertype'];
    email = responseDecoded['email'];
    String username = responseDecoded['username'];
    String employeeid = responseDecoded['employeeid'];

    if (accepted) {
      await SessionManager().set("email", email);
      await SessionManager().set("usertype", usertype);
      await SessionManager().set("username", username);
      await SessionManager().set("employeeid", employeeid);
      if (usertype == "passenger") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const UserScreen()));
      }
      if (usertype == "employee") {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const EmpScreen()));
      }
    } else {
      // wrong email or password
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(const Duration(seconds: 5), () {
              Navigator.of(context, rootNavigator: true).pop(true);
            });
            return const AlertDialog(
              title: Text("Wrong credentials."),
            );
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
              //Title
              Text(
                'LOG IN',
                style: GoogleFonts.robotoCondensed(
                    fontSize: 40, fontWeight: FontWeight.bold),
              ),

              //Subtitle
              Text(
                'Welcome back! Nice to see you again. ',
                style: GoogleFonts.robotoCondensed(fontSize: 18),
              ),

              SizedBox(
                height: 50,
              ),

              //Email Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 100, maxWidth: 500),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              //Pass Textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 100, maxWidth: 500),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              //Login button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GestureDetector(
                  child: Container(
                    constraints:
                        const BoxConstraints(minWidth: 100, maxWidth: 300),
                    // padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 106, 122, 135),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: ButtonLogin(
                        onTap: () async {
                          await signUserIn(context);
                        },
                        buttonText: "Login",
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a user yet? ',
                    style: GoogleFonts.robotoCondensed(
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmpSingupScreen()),
                        );
                      },
                      child: Text(
                        'Sign up!',
                        style: GoogleFonts.robotoCondensed(
                            color: Color.fromARGB(255, 106, 122, 135),
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
