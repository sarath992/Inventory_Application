import 'package:flutter/material.dart';
import 'package:inventory_app/app_features/Authentication/SignUp/UI/signup_page.dart';
import 'package:inventory_app/app_features/product_list/UI/product_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedUsername = prefs.getString('username') ?? '';
    String savedPassword = prefs.getString('password') ?? '';

    if (username == savedUsername && password == savedPassword) {
      // Login successful
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProductListPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please check the credentials')));
    }
  }

  void navigateToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
         backgroundColor: Colors.blue,
        title: const Text(
          'Login',
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
              onPressed: () => login(context),
              child: Text('Login'),
            ),
            SizedBox(height: 10.0),
           
            TextButton(
              onPressed: () => navigateToSignup(context),
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
