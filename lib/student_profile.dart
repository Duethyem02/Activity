import 'package:activity_point_monitoring_project/uploading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserP {
  String uid;
  String Branch;
  String Name;
  String Year;
  String email;
  String rool;

  UserP({required this.uid,required this.Branch, required this.Name, required this.Year,required this.email,required this.rool});

  factory UserP.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserP(
      uid: doc.id,
      Branch: data['Branch'],
      Name: data['Name'],
      Year: data['Year'],
      email: data['email'],
      rool: data['rool'],
    );
  }
}

class UserRepository {
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  Future<UserP?> getUserById(String id) async {
    QuerySnapshot snapshot = await _usersCollection.where('email', isEqualTo: id).get();
    if (snapshot.docs.isEmpty) {
      return null;
    } else {
      return UserP.fromFirestore(snapshot.docs.first);
    }
  }
}

class Sprofile extends StatelessWidget {
  Sprofile({Key? key, required this.uid}) : super(key: key);

  final String uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text('Student'),
        centerTitle: true,
        backgroundColor: Colors.indigo[100],
        elevation: 0,
      ),
      body: FutureBuilder(
        future: UserRepository().getUserById(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserP user = snapshot.data as UserP;
            return Padding(
              padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Image.network('https://cdn0.iconfinder.com/data/icons/education-line-circle-1/614/243_-_Male_Student-512.png',width: 150,height: 150,fit: BoxFit.cover,),
                  ),
                  Divider(
                    height: 60,
                    color: Colors.grey[800],
                  ),
                  Text(
                    'Name',
                    style: TextStyle(
                        color: Colors.grey[600],
                        letterSpacing: 2
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.Name,
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2,
                        fontSize: 28,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Branch',
                    style: TextStyle(
                        color: Colors.grey[600],
                        letterSpacing: 2
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.Branch,
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2,
                        fontSize: 28,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Year',
                    style: TextStyle(
                        color: Colors.grey[600],
                        letterSpacing: 2
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.Year,
                    style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 2,
                        fontSize: 28,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 30),
                  /*Text(
          'Batch',
          style: TextStyle(
              color: Colors.grey,
              letterSpacing: 2
          ),
        ),
        SizedBox(height: 10),
        Text(
          'E',
          style: TextStyle(
              color: Colors.black,
              letterSpacing: 2,
              fontSize: 28,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 30),
        Text(
          'Branch',
          style: TextStyle(
              color: Colors.grey[600],
              letterSpacing: 2
          ),
        ),
        SizedBox(height: 10),
        Text(
          'EEE',
          style: TextStyle(
              color: Colors.black,
              letterSpacing: 2,
              fontSize: 28,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 30),*/
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Colors.grey[600],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        user.email,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            letterSpacing: 1
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            );

          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: Container(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PdfUploader(),
              ),
            );
          },
          style:ElevatedButton.styleFrom(backgroundColor:Colors.indigo[400],foregroundColor: Colors.white,),
          child: const Text('Upload Certificate',style: TextStyle(fontSize: 21),),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}



