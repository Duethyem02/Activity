import 'dart:typed_data';
import 'package:activity_point_monitoring_project/student_profile.dart';
import 'package:activity_point_monitoring_project/textextract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'knn.dart';


class PdfUploader extends StatefulWidget {
  PdfUploader({Key? key,}) : super(key: key);

  @override
  _PdfUploaderState createState() => _PdfUploaderState();
}

class _PdfUploaderState extends State<PdfUploader> {
  TextEditingController urlController = TextEditingController();

  final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
  List<Map<String,dynamic>> pdfData = [];
  String? get userId => getUserId();
  var email;
  String? getUserId(){
    final User? user=FirebaseAuth.instance.currentUser;
    if(user==null){
      return null;
    }
    final String uid=user.uid;
    email=user.email;
    return uid;
  }
  Future<String> uploadPdf(String fileName, Uint8List file) async {
    try {
      final reference =await FirebaseStorage.instance.ref('pdfs/$userId/$fileName');
      final uploadTask = reference.putData(file);
      await uploadTask;
      final downloadLink = await reference.getDownloadURL();
      return downloadLink;
    } catch (e, st) {
      print(e);
      print(st);
      return"";}
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;
      final downloadLink=await uploadPdf(fileName, fileBytes!);
      await _firebaseFirestore.collection("$userId").add({
        "name":fileName,
        "url":downloadLink,
      });
      getAllPdf();
    }
  }
  void getAllPdf() async{
    final results= await _firebaseFirestore.collection("$userId").get();
    pdfData=results.docs.map((e) => e.data()).toList();
    if (mounted) setState((){});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllPdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Upload PDF'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Sprofile(uid: email),),);
            },
          ),
        ),
        body: GridView.builder(
          itemCount: pdfData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              InkWell(
                  onTap: () async {
                    final pdfUrl = pdfData[index]['url'];
                    // final userUrl = urlController.text.trim();
                    String? extractedText= await extractTextFromPDF(pdfData[index]['url']);
                    final initialUrl = 'https://docs.google.com/viewer?url=${Uri.encodeComponent(pdfUrl)}';
                    final pp=Uri.parse(initialUrl);
                    launch(initialUrl);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              KNNAlgorithm(text:extractedText),
                        ));
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network('https://th.bing.com/th/id/OIP.9IRAdWdQZ2Dfwp86yYQ1CgHaIz?pid=ImgDet&rs=1',width: 200,height: 200,fit: BoxFit.cover,),
                        Text(
                          pdfData[index]['name'],
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                  )
              ),
            );
          },),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.upload_file),
          onPressed: pickFile,
        )
    );

  }
}

