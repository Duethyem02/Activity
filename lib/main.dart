import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'splash_screen.dart';
import './student_login.dart';
import './faculty_login.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  Color _primaryColor = HexColor('#ADBCE6');
  Color _accentColor = HexColor('#6495ED');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ACTIVITY POINT MONITOR AND CERTIFICATE MANAGER',
        theme: ThemeData(
          primaryColor: _primaryColor,
          accentColor: _accentColor,
          scaffoldBackgroundColor: Colors.grey.shade100,
          primarySwatch: Colors.grey,
        ),
        home:  SplashScreen(title: 'ACTIVITY POINT MONITOR AND CERTIFICATE MANAGER',)
    );
  }
}
class Home extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title:const Text('Activity Point Monitor',style: TextStyle(color: Colors.white),),
        backgroundColor:Colors.indigo[500],
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
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
              style:ElevatedButton.styleFrom(backgroundColor:Colors.indigo[400],foregroundColor: Colors.white,fixedSize: const Size(275, 56),),
              child: const Text('Student',style: TextStyle(fontSize: 21),),
            ),
              const SizedBox(height:40.0),
              ElevatedButton(onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FacultyLogin(),
                  ),
                );
              },
                style:ElevatedButton.styleFrom(backgroundColor:Colors.indigo[400],foregroundColor: Colors.white,fixedSize: const Size(275, 56),),
                child:const Text('Teacher',style: TextStyle(fontSize: 21),),
              ),
            ]),
      ),
    );
  }
}