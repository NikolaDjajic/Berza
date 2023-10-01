import 'dart:async';
import 'package:crypto/View/navBar.dart';
import 'package:crypto/View/splash.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IO extends StatefulWidget {
  
  const IO({Key? key}) : super(key: key);

  @override
  State<IO> createState() => _IOState();
}

class _IOState extends State<IO> {
  bool isFieldPopulated = false; 

  
  @override
  void initState() {
      checkFieldPopulated(); 

    Timer(
      Duration(seconds: 4),
      () {

        if(isFieldPopulated){
        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NavBar()));
                  }
        else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Splash()));
        }
      },
    );
    super.initState();
  }


   Future<void> checkFieldPopulated() async {
    WidgetsFlutterBinding.ensureInitialized(); 
    final prefs = await SharedPreferences.getInstance();
    isFieldPopulated = prefs.containsKey('username');
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffFBC700),
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: myHeight * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(''),
                Text(
                  'Berza',
                  style: TextStyle(
                      fontSize: 60,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Dobrodošli',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          width: myWidth * 0.02,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: myHeight * 0.005,
                    ),
                    Image.asset(
                      'assets/image/loading1.gif',
                      height: myHeight * 0.015,
                      color: Colors.black,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
