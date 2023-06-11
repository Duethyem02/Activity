import 'package:flutter/material.dart';
import './student_login.dart';
import 'email_password_auth.dart';


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
      body:const tloginwindow(),
    );
  }
}

class tloginwindow extends StatefulWidget {
  const tloginwindow({Key? key}) : super(key: key);

  @override
  State<tloginwindow> createState() => _tloginwindowState();
}

class _tloginwindowState extends State<tloginwindow> {
  final _formkey =GlobalKey<FormState>();
  bool isLogin=false;
  var _isObscured=true;
  var role="teacher";
  String password="";
  String email="";
  String name="";
  String university_id="";
  String department="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
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
                      university_id=value!;
                    });
                  },
                  key:ValueKey('University ID'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'University ID',
                  ),
                ),
              ):Container(),
              !isLogin? Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onSaved: (value){
                    setState(() {
                      department=value!;
                    });
                  },
                  key:ValueKey('Department'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Department',
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
                  obscureText: _isObscured,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text('Forgot Password',),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    style:ElevatedButton.styleFrom(backgroundColor:Colors.black,foregroundColor: Colors.blueGrey),
                    child: isLogin?const Text('Login'):const Text('Sign Up'),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        isLogin
                            ? AuthServices.signinUser(email, password, context)
                            : AuthServices.signupUser(email, password, name,role,university_id,department,0,context);
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
                      style: TextStyle(fontSize: 20),
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