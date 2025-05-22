/*
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/pdfProvider.dart';
import '../services/filePickerService.dart';
import '../widgets/pdfCard.dart';
import 'PdfViewerScreen.dart';

class PdfHomeScreen extends StatelessWidget {
  const PdfHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Reader"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings screen

            },
          ),
        ],
      ),
      body: pdfProvider.pdfFiles.isEmpty
          ? const Center(child: Text("No PDFs found."))
          : ListView.builder(
        itemCount: pdfProvider.pdfFiles.length,
        itemBuilder: (context, index) {
          final pdf = pdfProvider.pdfFiles[index];
          return PdfCard(
            pdf: pdf,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PdfViewerScreen(pdfPath: pdf.path),
                ),
              );
            },
          );
        },
      ),
      */
/*floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await requestStoragePermission()) {
            String? path = await FilePickerService.pickPDF();
            if (path != null) {
              pdfProvider.addPdf(path);
            }
          } else {
            // Show an alert to the user about missing permissions
          }
          */ /*
*/
/*String? path = await FilePickerService.pickPDF();
          if (path != null) {
            pdfProvider.addPdf(path);
          }*/ /*
*/
/*
        },
        child: const Icon(Icons.add),
      ),*/ /*

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            debugPrint("Floating Action Button Pressed");

            bool hasPermission = await requestStoragePermission();
            debugPrint("Storage Permission: $hasPermission");

            if (hasPermission) {
              String? path = await FilePickerService.pickPDF();
              debugPrint("Picked PDF Path: $path");

              if (path != null) {
                pdfProvider.addPdf(path);
                debugPrint("PDF added to provider");
              } else {
                debugPrint("No file was selected");
              }
            } else {
              debugPrint("Permission denied");
            }
          } catch (e) {
            debugPrint("Error occurred: $e");
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
Future<bool> requestStoragePermission() async {
  if (await Permission.storage.isGranted) {
    return true;
  }

  // For Android 13+ (API 33+), use the new permissions
  if (await Permission.manageExternalStorage.request().isGranted ||
      await Permission.photos.request().isGranted ||
      await Permission.videos.request().isGranted ||
      await Permission.audio.request().isGranted) {
    return true;
  }

  if (await Permission.storage.request().isPermanentlyDenied) {
    await openAppSettings();
    return false;
  }

  return false;
}
*/

// features/AiTutor/screens/PdfViewerScreen.dart

// features/AiTutor/screens/PdfViewerScreen.dart
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String subjectName;

  const PdfViewerScreen({
    Key? key,
    required this.pdfUrl,
    required this.subjectName,
  }) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfController? _pdfController;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      // Fetch PDF data from the network URL
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        final pdfData = response.bodyBytes; // Uint8List
        final document = await PdfDocument.openData(pdfData);
        setState(() {
          _pdfController = PdfController(
            document: Future.value(document),
          );
          _error = null;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch PDF: HTTP ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading PDF: $e';
      });
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
      ),
      body: _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error!),
                  ElevatedButton(
                    onPressed: _loadPdf,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _pdfController == null
              ? const Center(child: CircularProgressIndicator())
              : PdfView(
                  controller: _pdfController!,
                  onDocumentError: (error) {
                    setState(() {
                      _error = 'Error rendering PDF: $error';
                    });
                  },
                ),
    );
  }
}
