import 'package:aviaid_/Screens/Emp_Screen.dart';
import 'package:aviaid_/Screens/User_Screen.dart';
import 'package:flutter/material.dart';
import 'package:aviaid_/Screens/home.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

dynamic username = "", userid = "", usertype = "", employeeid = "";
Future<void> loadSessionVariable(context) async {
  username = await SessionManager().get("username");
  userid = await SessionManager().get("userid");
  usertype = await SessionManager().get("usertype");
  employeeid = await SessionManager().get("employeeid");
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    loadSessionVariable(context);
    return AppBar(
      // title: Text("Hello Appbar"),
      title: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        height: 32,
      ),
      backgroundColor: const Color.fromARGB(255, 65, 93, 111),
      leading: GestureDetector(
        child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),

      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: GestureDetector(
              onTap: () {
                if (usertype == "employee") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EmpScreen()));
                }
                if (usertype == "passenger") {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const UserScreen()));
                }
              },
              child: const Icon(
                Icons.home,
                size: 26.0,
              ),
            )),
        Padding(
            padding: const EdgeInsets.only(right: 40.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
              child: const Icon(
                Icons.logout,
                size: 26.0,
              ),
            )),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
