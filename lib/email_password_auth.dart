import 'package:activity_point_monitoring_project/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'faculty_profile.dart';
import 'student_profile.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');

postDetailsToFirestore(String email,String name, String rool,String year,String branch,int point,int mooc,int arts,int nssncc,int sports,int internship) async {
  var user = FirebaseAuth.instance.currentUser;
  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  ref.doc(user!.uid).set({'email': email, 'rool': rool,'Name':name,'Year':year,'Branch':branch,'Point':point,'mooc':mooc,'arts':arts,'nssncc':nssncc,'sports':sports,'internship':internship});
}
class AuthServices {
  static signupUser(String email, String password, String name,String role,String year,String branch,int point,int mooc,int arts,int nssncc,int sports,int internship, context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password).then((value) => {postDetailsToFirestore(email, name,role,year,branch,point,mooc,arts,nssncc,sports,internship,)})
          .catchError((e) {});;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Successfull...!')));
      return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email Provided already Exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential= await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      route(context,email);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Successful')));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Password did not match')));
      }
    }

  }
}

void route(BuildContext context,String email) {
  User? user = FirebaseAuth.instance.currentUser;
  var kk = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      if (documentSnapshot.get('rool') == "student") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  Sprofile(uid: email),
          ),
        );
      }else if(documentSnapshot.get('rool') == "teacher") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  Fprofile(uid: email,),
          ),
        );
      }
    } else {
      print('Document does not exist on the database');
    }
  });
}
