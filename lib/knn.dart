import 'dart:math';

import 'package:flutter/material.dart';

class Word {
  String text;
  int activityPoints;

  Word({required this.text, required this.activityPoints});
}

class KNNAlgorithm extends StatefulWidget {
  final String text;
  //final String point;
  const KNNAlgorithm({Key? key, required this.text,/*required this.point*/}) : super(key: key);
  @override
  _KNNAlgorithmState createState() => _KNNAlgorithmState();
}

class _KNNAlgorithmState extends State<KNNAlgorithm> {
  final List<Map<String, dynamic>> activities = [
    {
      'Activity': 'Coursera',
      'Level': 1,
      'Achievement Levels (I-V)': '- - - - -',
      'Activity Points': 50,
      'Approval Documents': 'Certificate/Letter',
    },
    {
      'Activity': 'NCC',
      'Level': 1,
      'Achievement Levels (I-V)': '- - - - -',
      'Activity Points': 60,
      'Approval Documents': 'Certificate/Letter',
    },
    {
      'Activity': 'NSS',
      'Level': 1,
      'Achievement Levels (I-V)': '- - - - -',
      'Activity Points': 60,
      'Approval Documents': 'Certificate/Letter',
    },
    {
      'Activity': 'Sports',
      'Level': 3,
      'Achievement Levels (I-V)': '8 15 25 40 60',
      'Activity Points': 60,
      'Approval Documents': 'Certificate/Letter',
    },
    // Add the rest of the activities here
  ];

  final k = 3; // Number of nearest neighbors to consider

  int activityPoints =0;//widget.point;
  String enteredActivity = '';

  void calculateActivityPoints() {
    final studentData = [1, 0]; // Replace with the student's activity level and achievement

    final distances = <double>[];
    for (var activity in activities) {
      final activityData = [activity['Activity'],activity['Level'], activity['Activity Points']];
      final distance = euclideanDistance(studentData, activityData);
      distances.add(distance);
    }

    final sortedIndices = List<int>.generate(activities.length, (index) => index)
      ..sort((a, b) => distances[a].compareTo(distances[b]));

    final nearestNeighbors = sortedIndices.take(k).toList();

    final predictedPoints = <int>[];
    for (var neighborIndex in nearestNeighbors) {
      final neighbor = activities[neighborIndex];
      final points = neighbor['Activity Points'];
      predictedPoints.add(points);
    }

    final totalPoints = predictedPoints.reduce((a, b) => a + b);

    setState(() {
      activityPoints += totalPoints;
      print(activityPoints);
    });
  }

  double euclideanDistance(List<num> a, List<dynamic> b) {
    var distanceSquared = 0.0;
    for (var i = 0; i < a.length; i++) {
      if (a[i] is String && b[i] is String) {
        distanceSquared += (a[i] as String).compareTo(b[i] as String);
      } else {
        distanceSquared += pow(a[i] - b[i], 2);
      }
    }
    return sqrt(distanceSquared);
  }

  // void onActivityEntered(String activity) {
  //   enteredActivity = activity;
  //   calculateActivityPoints();
  // }

  void onActivityEntered(String text) {
    enteredActivity = text;
    String words1 = enteredActivity.replaceAll('\n', '').replaceAll('.', '');
    List<String>words=words1.split(' ');
    List<String> uniqueWords = words.toSet().toList(); // Get unique words
    List<String> match=['Coursera','NPTL'];
    for(String word in uniqueWords){
      for(String word2 in match){
        var regex = RegExp(word2.toLowerCase());
        if(regex.hasMatch(word.toLowerCase())){
          print(word2);
        }
      }
    }
    calculateActivityPoints();
  }
  // void processInput(String input) {
  //   int points = knnAlgorithm(input, 3);
  //   print('Activity points: $points');
  // }

  void initState() {
    // TODO: implement initState
    super.initState();
    onActivityEntered(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold();
  }
}

