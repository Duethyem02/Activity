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

class Fprofile extends StatelessWidget {
  Fprofile({Key? key, required this.uid}) : super(key: key);

  final String uid;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text('Faculty'),
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
                    child: Image.network('https://th.bing.com/th/id/R.8f9d91c32c30a4b3ae17b2edb4b14dbc?rik=IC53xJ%2fTFxKUig&riu=http%3a%2f%2ficon-library.com%2fimages%2fstaff-icon-png%2fstaff-icon-png-15.jpg&ehk=ZJejg%2fns9362kI67D57YbUheY2bPz9q2lIjhuubL6hs%3d&risl=&pid=ImgRaw&r=0',width: 150,height: 150,fit: BoxFit.cover,),
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
                    'Department',
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
                    'University ID',
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
                builder: (context) => FacultyPage(),
              ),
            );
          },
          style:ElevatedButton.styleFrom(backgroundColor:Colors.indigo[400],foregroundColor: Colors.white,),
          child: const Text('Verify Certificate',style: TextStyle(fontSize: 21),),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class FacultyPage extends StatefulWidget {
  @override
  _FacultyPageState createState() => _FacultyPageState();
}

class _FacultyPageState extends State<FacultyPage> {
  String selectedClass="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: Column(
        children: [
          DropdownButton(
            hint: Text('Select a class'),
            value: selectedClass,
            onChanged: (value) {
              setState(() {
                selectedClass = value!;
              });
            },
            items: [
              DropdownMenuItem(
                value: 'A',
                child: Text('Class A'),
              ),
              DropdownMenuItem(
                value: 'B',
                child: Text('Class B'),
              ),
              DropdownMenuItem(
                value: 'C',
                child: Text('Class C'),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('batch', isEqualTo: selectedClass)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final students = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return ListTile(
                      title: Text(student['name']),
                      subtitle: Text(student['email']),
                      // Display any other relevant information here
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



