import 'package:flutter/material.dart';
import './student_login.dart';

class FacultyLogin extends StatelessWidget {
  const FacultyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Faculty Page'),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body:const loginwindow(),
    );
  }
}