import 'package:activity_point_monitoring_project/student_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Word {
  String text;
  int activityPoints;

  Word({required this.text, required this.activityPoints});
}

class KNNAlgorithm extends StatefulWidget {
  final String text;
  const KNNAlgorithm({Key? key, required this.text,/*required this.point*/}) : super(key: key);
  @override
  _KNNAlgorithmState createState() => _KNNAlgorithmState();
}

class _KNNAlgorithmState extends State<KNNAlgorithm> {
  late int newpoint;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  String? get userId => getUserId();
  var email;
  var points;

  // Future<int?> getpoint(String? id)  async {
  //   QuerySnapshot snapshot = await _usersCollection.where(
  //       'email', isEqualTo: id).get();
  //   List<DocumentSnapshot> documents = snapshot.docs;
  //
  //   for (DocumentSnapshot doc in documents) {
  //     // Access data within the document
  //     Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
  //     if(data!=null){
  //       point= data['Point'];
  //     }
  //   }
  // }
  String? getUserId(){
    final User? user=FirebaseAuth.instance.currentUser;
    if(user==null){
      return null;
    }
    final String uid=user.uid;
    email=user.email;
    return uid;
  }
  static List<Word> trainedWords = [
    Word(text: 'coursera', activityPoints: 50),
    Word(text: 'ncc', activityPoints: 60),
    Word(text: 'nss', activityPoints: 60),
    Word(text: 'nptel', activityPoints: 50),
    Word(text: 'internship', activityPoints: 20),
  ];

  static int knnAlgorithm(String sentence, int k) {
    var enteredActivity = sentence;
  String words1 = enteredActivity.replaceAll('\n',' ').replaceAll(',',' ').replaceAll('.',' ');
  List<String>words=words1.split(' ');
  List<String> uniqueWords = words.toSet().toList(); // Get unique words
  List<String> match=['coursera','nptel','ncc','nss','internship'];
  List<String> matchingWord = [];
  for (String word in match) {
    if (words1.toLowerCase().contains(word.toLowerCase())) {
      matchingWord.add(word);
      break;
    }
  }
  print(matchingWord);
  int totalPoints = 0;

    for (String word in matchingWord) {
      int? nearestPoints = findNearestPoints(word, k);
      if (nearestPoints != null) {
        totalPoints += nearestPoints;
      }
    }

    return totalPoints;
  }

  static int? findNearestPoints(String word, int k) {
    List<Word> nearestNeighbors = trainedWords;
    nearestNeighbors.sort((a, b) => calculateDistance(a.text, word).compareTo(calculateDistance(b.text, word)));
    nearestNeighbors = nearestNeighbors.sublist(0, k);

    int? totalPoints = nearestNeighbors
        .where((neighbor) => neighbor.text == word)
        .map((neighbor) => neighbor.activityPoints)
        .fold<int?>(null, (sum, points) => sum != null ? sum + points : points);

    return totalPoints;
  }

  static int calculateDistance(String word1, String word2) {
    // Implement distance calculation, e.g., edit distance or similarity metrics
    // Return the calculated distance as an integer value
    return 0; // Placeholder value, replace with actual distance calculation
  }
  void processInput(String input) {
    points = knnAlgorithm(input, 3);
    print('Activity points: $points');
    // int oldpoint=point ;
    // newpoint=points;
    //
    // print('Activity points: $newpoint');
    updateValue();
  }

  Future<void> updateValue() async {
       User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      String email = user.email!;

      DocumentReference userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(uid);

      await userDoc.update({'Point': points});
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Sprofile(uid: email)));
    }}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getpoint(userId);
    processInput(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}
