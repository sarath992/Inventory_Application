import 'package:flutter/material.dart';
import 'package:inventory_app/app_features/Authentication/Login/UI/login_page.dart';
import 'package:inventory_app/app_features/product_list/UI/product_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<bool> isUsernameTaken(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? existingUsername = prefs.getString('username');
    return existingUsername == username;
  }

  void signup(BuildContext context) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    bool usernameExists = await isUsernameTaken(username);
    if (usernameExists) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Username is already taken. Please choose another."),
      ));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      await prefs.setString('password', password);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Account Created Successfully"),
      ));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProductListPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: const Text(
          'SignUp',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => signup(context),
              child: Text('Signup'),
            ),
            SizedBox(height: 16.0,),
               ElevatedButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginPage()));
              },
              child: Text('Already have an account'),
            ),
          ],
        ),
      ),
    );
  }
}
