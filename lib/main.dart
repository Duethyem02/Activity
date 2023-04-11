import 'package:flutter/material.dart';
import './student_login.dart';
import './faculty_login.dart';

void main() => runApp(MaterialApp(
  home:Home(),
));

class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title:Text('Activity Point Monitor'),
        backgroundColor:Colors.grey,
        centerTitle: true,
      ),
      body:Center(
        child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children:[ ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StudentLogin(),
                  ),
                );
            },
              child: Text('Student'),
              style:ElevatedButton.styleFrom(backgroundColor:Colors.black,foregroundColor: Colors.blueGrey),
            ),
              SizedBox(height:30.0),
              ElevatedButton(onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FacultyLogin(),
                  ),
                );
              },
                child: Text('Teacher'),
                style:ElevatedButton.styleFrom(backgroundColor:Colors.black,foregroundColor: Colors.blueGrey),
              ),
            ]),
      ),
    );
  }
}
