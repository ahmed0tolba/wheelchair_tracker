import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'EmpLogin_Screen.dart';
import 'Login_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: _AppBar(),
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Title

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          'Welcome to AviAid, Are you a passenger or an airpot employee? ',
                          style: GoogleFonts.robotoCondensed(
                              color: Colors.grey[200],
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      SizedBox(
                        height: 70,
                      ),

                      //Passenger button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 100, maxWidth: 300),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 106, 122, 135),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Passenger ',
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

                      //Airpot Employee button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmpLoginScreen()),
                            );
                          },
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 100, maxWidth: 300),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 106, 122, 135),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Airport Employee ',
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
                    ]),
              ),
            ),
          ),
        ));
  }
}
