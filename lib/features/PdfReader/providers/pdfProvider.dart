import 'package:flutter/material.dart';

import '../datamodels/pdfModel.dart';

class PdfProvider with ChangeNotifier {
  List<PdfModel> _pdfFiles = [];

  List<PdfModel> get pdfFiles => _pdfFiles;

  void addPdf(String path) {
    _pdfFiles.add(PdfModel(path: path));
    notifyListeners();
  }
}
