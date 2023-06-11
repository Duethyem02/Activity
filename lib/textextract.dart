import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> extractTextFromPDF(String pdfUrl) async {
  final apiKey = 'K83353243188957'; // Replace with your OCR.space API key
  final apiEndpoint = 'https://api.ocr.space/parse/image';

  final response = await http.post(
    Uri.parse(apiEndpoint),
    body: {
      'url': pdfUrl,
      'apikey': apiKey,
      'filetype': 'pdf',
      'OCREngine': '2',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['IsErroredOnProcessing']) {
      throw Exception('OCR processing error: ${data['ErrorMessage']}');
    } else {
      final extractedText = data['ParsedResults'][0]['ParsedText'];
      return extractedText;
    }
  } else {
    throw Exception('Failed to extract text from PDF. Status code: ${response.statusCode}');
  }
}

