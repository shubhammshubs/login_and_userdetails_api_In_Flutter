import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_and_userdetails_api/user_session/User.dart' as UserSession;
import 'package:login_and_userdetails_api/user_session/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  final String mobileNumber;
  HomePage({required this.mobileNumber});



  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<User> users = [];
  User? userInfo;
  bool isLoading = false;

  Future<void> fetchUsers() async {
    setState(() {
      isLoading = true;
    });

    http.Response response = await http.get(
      Uri.parse("https://api.trifrnd.com/portal/Attend.php?apicall=readall"),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<User> userList = data.map((item) => UserSession.User(
        id: item['id'],
        fname: item['fname'],
        lname: item['lname'],
        empId: item['EmpId'],
        email: item['email'],
        mobile: item['mobile'],
        departmentName: item['department_name'],
      )).toList();

      setState(() {
        users = userList;
        userInfo = users.firstWhere(
              (user) => user.mobile == widget.mobileNumber,
          orElse: () => UserSession.User(
            id: '',
            fname: '',
            lname: '',
            empId: '',
            email: '',
            mobile: '',
            departmentName: '',
          ),
        );
      });
    } else {
      // Handle error if the API call was not successful
      print("API call failed");
      Fluttertoast.showToast(
        msg: "Server Connection Error!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("User Details"),
      ),
      body: Center(

        child:
        isLoading
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userInfo != null
                ? Column(
              children: [
                Text('Welcome ${userInfo!.fname}',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                SizedBox(height: 20),
                Text('Name: ${userInfo!.fname} ${userInfo!.lname}'),
                Text('Employee ID: ${userInfo!.empId}'),
                Text('Email: ${userInfo!.email}'),
                Text('Mobile: ${userInfo!.mobile}'),
                Text('Department: ${userInfo!.departmentName}'),
              ],
            )
                : Text("User not found."),

            SizedBox(height: 20),

            ElevatedButton(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Logout'),
                ],
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('userName'); // Clear the stored user name
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginApp()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
