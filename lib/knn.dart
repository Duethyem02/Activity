// import 'package:activity_point_monitoring_project/student_profile.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';
//
// class Word {
//   String text;
//   int activityPoints;
//   String? level;
//
//   Word({required this.text, required this.activityPoints, this.level});
// }
//
// class KNNAlgorithm extends StatefulWidget {
//   final String inputText;
//   const KNNAlgorithm({Key? key, required this.inputText}) : super(key: key);
//
//   @override
//   _KNNAlgorithmState createState() => _KNNAlgorithmState();
// }
//
// class _KNNAlgorithmState extends State<KNNAlgorithm> {
//   late int points;
//   final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
//   String? get userId => getUserId();
//  // var email;
//
//   String? getUserId() {
//     final User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       return null;
//     }
//     final String uid = user.uid;
//     //email = user.email;
//     return uid;
//   }
//
//   static List<Word> trainedWords = [
//     Word(text: 'coursera', activityPoints: 50),
//     Word(text: 'ncc', activityPoints: 60),
//     Word(text: 'nss', activityPoints: 60),
//     Word(text: 'nptel', activityPoints: 50),
//     Word(text: 'internship', activityPoints: 20),
//     Word(text: 'sports', activityPoints: 40, level: 'level one'),
//     Word(text: 'sports', activityPoints: 60, level: 'state level'),
//   ];
//
//   int calculateEditDistance(String word1, String word2) {
//     int len1 = word1.length;
//     int len2 = word2.length;
//
//     List<List<int>> dp = List.generate(len1 + 1, (_) => List<int>.filled(len2 + 1, 0));
//
//     for (int i = 0; i <= len1; i++) {
//       for (int j = 0; j <= len2; j++) {
//         if (i == 0) {
//           dp[i][j] = j;
//         } else if (j == 0) {
//           dp[i][j] = i;
//         } else if (word1[i - 1] == word2[j - 1]) {
//           dp[i][j] = dp[i - 1][j - 1];
//         } else {
//           dp[i][j] = 1 + min(min(dp[i - 1][j], dp[i][j - 1]), dp[i - 1][j - 1]);
//         }
//       }
//     }
//
//     return dp[len1][len2];
//   }
//
//   int knnAlgorithm(String inputText, int k) {
//     List<String> inputWords = inputText.split(' ');
//
//     int totalPoints = 0;
//
//     for (Word word in trainedWords) {
//       if (inputWords.contains(word.text)) {
//         if (word.level != null && inputText.contains(word.level!)) {
//           totalPoints += word.activityPoints;
//         } else {
//           totalPoints += word.activityPoints;
//         }
//       }
//     }
//
//     return totalPoints;
//   }
//
//   void processInput() {
//     points = knnAlgorithm(widget.inputText, 3); // Use k=3 for nearest neighbors
//     print('Activity points: $points');
//     updateValue();
//   }
//
//   Future<void> updateValue() async {
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       String uid = user.uid;
//
//       // Fetch the current points for the user from Firestore
//       DocumentSnapshot userSnapshot = await _firebaseFirestore.collection('users').doc(uid).get();
//       int previousPoints = userSnapshot.exists ? userSnapshot['Point'] : 0;
//
//       // Add the newly calculated points to the previous points
//       int totalPoints = previousPoints + points;
//
//       // Update the points in Firestore for the user
//       await _firebaseFirestore.collection('users').doc(uid).update({'Point': totalPoints});
//       String email = userSnapshot.exists ? userSnapshot['email'] : " ";
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Sprofile(uid: email)));
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     processInput();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
import 'package:activity_point_monitoring_project/student_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Word {
  String text;
  int activityPoints;
  String? level;

  Word({required this.text, required this.activityPoints, this.level});
}

class KNNAlgorithm extends StatefulWidget {
  final String inputText;
  const KNNAlgorithm({Key? key, required this.inputText}) : super(key: key);

  @override
  _KNNAlgorithmState createState() => _KNNAlgorithmState();
}

class _KNNAlgorithmState extends State<KNNAlgorithm> {
  late int points;
  late int mooc;
  late int arts;
  late int nssncc;
  late int sports;
  late int internship;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String? get userId => getUserId();

  String? getUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    final String uid = user.uid;
    return uid;
  }

  static List<Word> trainedWords = [
    Word(text: 'coursera', activityPoints: 50),
    Word(text: 'ncc', activityPoints: 60),
    Word(text: 'nss', activityPoints: 60),
    Word(text: 'nptel', activityPoints: 50),
    Word(text: 'internship', activityPoints: 20),
    Word(text: 'sports', activityPoints: 40, level: 'level one'),
    Word(text: 'sports', activityPoints: 60, level: 'state level'),
  ];

  int calculateEditDistance(String word1, String word2) {
    int len1 = word1.length;
    int len2 = word2.length;

    List<List<int>> dp = List.generate(len1 + 1, (_) => List<int>.filled(len2 + 1, 0));

    for (int i = 0; i <= len1; i++) {
      for (int j = 0; j <= len2; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (word1[i - 1] == word2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + min(min(dp[i - 1][j], dp[i][j - 1]), dp[i - 1][j - 1]);
        }
      }
    }

    return dp[len1][len2];
  }

  int knnAlgorithm(String inputText, int k) {
    List<String> inputWords = inputText.toLowerCase().split(RegExp(r'\s+|\.+|\,+'));
    int totalPoints = 0;

    for (String inputWord in inputWords) {
      for (Word word in trainedWords) {
        int editDistance = calculateEditDistance(inputWord, word.text);
        if (editDistance <= k) {
          if (word.level != null) {
            totalPoints += word.activityPoints;
            return totalPoints;
          } else {
            totalPoints += word.activityPoints;
            return totalPoints;
          }
        }
      }
    }
    return totalPoints;
  }

  void processInput() {
    int kpoints = knnAlgorithm(widget.inputText, 1);
    print('Activity points: $kpoints');
    criteria(widget.inputText,kpoints);
    // updateValue(pp);
  }
  criteria(String inputText, int p) async{
    List<String> words= inputText.toLowerCase().split(RegExp(r'\s+|\.+|\,+'));
    User? user = FirebaseAuth.instance.currentUser;
    int x=0,y=0,z=0,u=0,v=0;
    if(user!=null){
      String uid = user.uid;
      DocumentSnapshot userSnapshot = await _firebaseFirestore.collection('users').doc(uid).get();
      int moocpreviousPoints = userSnapshot.exists ? userSnapshot['mooc'] : 0;
      int nssnccpreviousPoints = userSnapshot.exists ? userSnapshot['nssncc'] : 0;
      int artspreviousPoints = userSnapshot.exists ? userSnapshot['arts'] : 0;
      int sportspreviousPoints = userSnapshot.exists ? userSnapshot['sports'] : 0;
      int internshippreviousPoints = userSnapshot.exists ? userSnapshot['internship'] : 0;
      x=moocpreviousPoints;
      z=nssnccpreviousPoints;
      y=artspreviousPoints;
      u=sportspreviousPoints;
      v=internshippreviousPoints;
      if(words.contains('coursera') || words.contains('nptel')){
        x=p+x;
        if(x>50){
          x=50;
        }
        await _firebaseFirestore.collection('users').doc(uid).update({'mooc': x});
      }
      if(words.contains('arts')){
        y=y+p;
        if(y>80){
          y=80;
        }
        await _firebaseFirestore.collection('users').doc(uid).update({'arts': y});

      }
      if(words.contains('ncc') || words.contains('nss')){
        z=p+z;
        if(z>50){
          z=50;
        }
        await _firebaseFirestore.collection('users').doc(uid).update({'nssncc': z});
      }
      if(words.contains('sports')){
        u=u+p;
        if(u>80){
          u=80;
        }
        await _firebaseFirestore.collection('users').doc(uid).update({'sports': u});
      }
      if(words.contains('internship')){
        v=v+p;
        if(v>20){
          v=20;
        }
        await _firebaseFirestore.collection('users').doc(uid).update({'internship': v});
      }
      int totalPoints = x+y+z+u+v;
      await _firebaseFirestore.collection('users').doc(uid).update({'Point': totalPoints});
      String email = userSnapshot.exists ? userSnapshot['email'] : " ";
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Sprofile(uid: email)));

    }
  }

  @override
  void initState() {
    super.initState();
    processInput();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
