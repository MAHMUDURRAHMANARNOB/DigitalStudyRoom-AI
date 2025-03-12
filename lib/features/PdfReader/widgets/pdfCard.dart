import 'package:flutter/material.dart';

import '../datamodels/pdfModel.dart';

class PdfCard extends StatelessWidget {
  final PdfModel pdf;
  final VoidCallback onTap;

  const PdfCard({super.key, required this.pdf, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(pdf.path.split('/').last),
      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
      onTap: onTap,
    );
  }
}
