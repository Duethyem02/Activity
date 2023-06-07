import 'package:flutter/material.dart';
import './email_password_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:activity_point_monitoring_project/forgot_password.dart';


class StudentLogin extends StatelessWidget {
  const StudentLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#6495ED'),
      appBar: AppBar(
        title: Text('Student Page',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: HexColor('#4169E1'),
      ),
      body:const sloginwindow(),
    );
  }
}

class sloginwindow extends StatefulWidget {
  const sloginwindow({Key? key}) : super(key: key);

  @override
  State<sloginwindow> createState() => _sloginwindowState();
}

class _sloginwindowState extends State<sloginwindow> {
  final _formkey =GlobalKey<FormState>();
  bool isLogin=false;
  var role="student";
  String password="";
  String email="";
  String name="";
  String year="";
  String branch="";
  String batch="";
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#ADBCE6'),
      body:Form(
          key:_formkey,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 170.0,),
              !isLogin? Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onSaved: (value){
                    setState(() {
                      name=value!;
                    });
                  },
                  key:ValueKey('name'),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                  ),
                ),
              ):Container(),
              !isLogin? Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onSaved: (value){
                    setState(() {
                      year=value!;
                    });
                  },
                  key:ValueKey('Year'),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Year',
                  ),
                ),
              ):Container(),
              !isLogin? Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onSaved: (value){
                    setState(() {
                      branch=value!;
                    });
                  },
                  key:ValueKey('Branch'),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Branch',
                  ),
                ),
              ):Container(),
              !isLogin? Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onSaved: (value){
                    setState(() {
                      batch=value!;
                    });
                  },
                  key:ValueKey('Batch'),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Batch',
                  ),
                ),
              ):Container(),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator:(value){
                    if(!(value.toString().contains('@'))) {
                      return'Invalid email';
                    }
                    else{
                      return null;
                    }
                  },
                  onSaved: (value){
                    setState(() {
                      email=value!;
                    });
                  },
                  key:ValueKey('email'),
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  validator:(value){
                    if(value.toString().length<6) {
                      return'Password is so small';
                    }
                    else{
                      return null;
                    }
                  },
                  onSaved: (value){
                    setState(() {
                      password=value!;
                    });
                  },
                  key:ValueKey('password'),
                  obscureText: _isObscure,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    /*suffixIcon: IconButton(
                        icon: Icon( _isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          }),*/
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ForgotPasswordScreen(),
                      ));
                },
                child: const Text('Forgot Password',style: TextStyle( fontSize: 15,fontWeight: FontWeight.bold, color: Colors.redAccent,),),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                  child: ElevatedButton(
                    style:ElevatedButton.styleFrom(backgroundColor:HexColor('#6495ED'),foregroundColor: Colors.blueGrey),
                    child: isLogin?const Text('Login'):const Text('Sign Up',style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        isLogin
                            ? AuthServices.signinUser(email, password, context)
                            : AuthServices.signupUser(email, password, name,role,year,branch,batch,context);
                      }
                    },
                  )
              ),
              Row(
                children: <Widget>[
                  TextButton(
                    child: isLogin
                        ? const Text(
                      'Does not have account ? Sign Up',
                      style: TextStyle(fontSize: 20),
                    )
                        : const Text(
                      'Already Signed Up ? Login',
                      style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold, color: Colors.blueAccent,),
                    ),
                    onPressed: () {
                      setState(() {
                        isLogin =!isLogin;
                      });
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          )),
    );
  }
}