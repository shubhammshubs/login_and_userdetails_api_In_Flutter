import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Home_page.dart';

void main() {
  runApp(

      LoginApp());

}

class LoginApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      home: LoginPage(),
    );
  }


}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // var other = "Login Done";
  bool _isLoading = false;




  Future<void> _login() async {

    setState(() {
      _isLoading = true;
    });

    final String apiUrl =
        'https://api.trifrnd.com/portal/Attend.php?apicall=login';

    // Simulate a delay of 1 second
    await Future.delayed(Duration(seconds: 1));

    final response = await http.post(Uri.parse(apiUrl),
        body: {
      "mobile": _mobileController.text,
      "password": _passwordController.text,
    });

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("Response body: ${response.body}");

      print("Decoded data: $responseData");

      if (responseData == "Login Done" ) {
        // Login successful, you can navigate to the next screen
        print("Login successful");
        final user = json.decode(response.body)[0];
        // print("Name is : $user");
        // Fluttertoast.showToast(msg:" $user",toastLength: Toast.LENGTH_SHORT,
        //   backgroundColor: Colors.green,
        //   textColor: Colors.white,);


        // final firstName = user["fname"];
        // print("Name 2 is : $firstName");
        //
        //
        // final prefs = await SharedPreferences.getInstance();
        // await prefs.setString('userName', firstName); // Store user's first name




        Fluttertoast.showToast(msg: "Login Successful",toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(mobileNumber: _mobileController.text,)),
        );



      } else {
        // Login failed, show an error message
        print("Login failed");
        // Fluttertoast.showToast(msg: "LogIn Failed");
        Fluttertoast.showToast(msg: "Invalid mobile number or password!",toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          textColor: Colors.white,);
      }

    } else {
      // Handle error if the API call was not successful
      print("API call failed");
      Fluttertoast.showToast(msg: "Server Connction Error!",toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _mobileController,

                decoration: InputDecoration(labelText: 'Mobile Number',
                    prefixIcon: Icon(Icons.mobile_friendly_sharp)),

                keyboardType: TextInputType.phone,

              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password',
                    prefixIcon: Icon(Icons.password_outlined),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off
                      ),
                    )    // This Widget is for password Visibility
                ),
                obscureText: _isPasswordVisible,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator()  // Show loading indicator
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.login),
                    SizedBox(width: 8),
                    Text('Login'),
                  ],
                ),
              )

              // ElevatedButton(
              //   onPressed: _login,
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(Icons.login),
              //       SizedBox(width: 8,),
              //       Text('Login'),
              //     ],
              //   )
              //
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
