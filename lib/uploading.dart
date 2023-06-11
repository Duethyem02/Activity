import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:activity_point_monitoring_project/student_profile.dart';
import 'package:activity_point_monitoring_project/textextract.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:dio/dio.dart';




class PdfUploader extends StatefulWidget {
  PdfUploader({Key? key,}) : super(key: key);

  @override
  _PdfUploaderState createState() => _PdfUploaderState();
}

class _PdfUploaderState extends State<PdfUploader> {
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
      final downloadLink = await reference. getDownloadURL();
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
              child: InkWell(
                  onTap: () async {
                    String? extractedText= await extractTextFromPDF(pdfData[index]['url']);
                    List<String> words = extractedText.split(' ');
                    List<String> listOfValues = ['coursera','participation','nptel','sports','arts','attended'];
                    List<String> matchedWords = [];
                    for (String word in words) {
                      if (listOfValues.contains(word.toLowerCase())) {
                        matchedWords.add(word);
                      }
                    }
                    print(words);

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>
                            PdfViewerScreen(pdfUrl: pdfData[index]['url'])));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(child: Image.network('https://th.bing.com/th/id/OIP.9IRAdWdQZ2Dfwp86yYQ1CgHaIz?pid=ImgDet&rs=1',width: 200,height: 200,fit: BoxFit.cover,)),
                        Flexible(child: Text(
                                  pdfData[index]['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),),
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

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);
  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Syncfusion Flutter PDF Viewer'),
  //     ),
  //     body: SfPdfViewer.network(
  //       widget.pdfUrl,
  //     ),
  //   );
  // }
  //bool _isLoading = true;
  PDFDocument? _pdf;

  void _loadFile() async {
    // final downloadLink = widget.pdfUrl;
    // final viewableLink = downloadLink.replaceAll('alt=media', 'alt=embed');
    // Load the pdf file from the internet
    _pdf = await PDFDocument.fromURL(
        widget.pdfUrl);

    setState(() {
      //_isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('PDF'),
      // ),
      body: Center(
          child: _pdf!= null
              ?PDFViewer(document: _pdf!)
              : const Center(child: CircularProgressIndicator())),
    );
  }
}


