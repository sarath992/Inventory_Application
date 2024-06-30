import 'package:flutter/material.dart';
import 'package:inventory_app/app_features/Authentication/Login/UI/login_page.dart';
import 'package:inventory_app/app_features/product_list/UI/product_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async{
    await Future.delayed(Duration(seconds: 3));

    
    bool loggedIn = await isLoggedIn();

    if (loggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ProductListPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }
    Future<bool> isLoggedIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? username = prefs.getString('username');
      return username != null;
    } catch (error) {
      print('Error fetching SharedPreferences: $error');
      return false;
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
          child: Text(
        "Inventory Application",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0,color: Colors.white),
      )),
    );
  }
}