import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as img;

import '../../screens/MCQViewScreen.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String subjectName;
  final int startPage;
  final String userId;
  final String courseId;
  final String chapterId;

  const PdfViewerScreen({
    Key? key,
    required this.pdfUrl,
    required this.subjectName,
    required this.startPage,
    required this.userId,
    required this.courseId,
    required this.chapterId,
  }) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfController? _pdfController;
  String? _error;
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _showQuestionPanel = false;
  bool _showRightDrawer = false;
  final TextEditingController _questionController = TextEditingController();
  XFile? _selectedImage;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isSelectingArea = false;

  // First, update the state variables
  Offset? _selectionStart;
  Rect? _selectedArea;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      if (response.statusCode == 200) {
        final pdfData = response.bodyBytes;
        final document = await PdfDocument.openData(pdfData);
        setState(() {
          _pdfController = PdfController(
            document: Future.value(document),
            initialPage: widget.startPage, // PDF pages are 0-indexed
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

  /*Future<void> _takeScreenshot() async {
    setState(() {
      _isSelectingArea = true;
    });
  }*/
  Future<void> _takeScreenshot() async {
    setState(() {
      _isSelectingArea = true;
      _selectedArea = null; // Reset any previous selection
      _selectionStart = null;
    });
  }

  /* Future<void> _captureSelectedArea() async {
    if (_selectedArea == null) return;

    try {
      // Capture the entire screen first
      final Uint8List? fullImage = await _screenshotController.capture(
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      );

      if (fullImage != null) {
        // Crop the image to the selected area
        final croppedImage = await _cropImage(fullImage, _selectedArea!);

        if (croppedImage != null) {
          final directory = await getTemporaryDirectory();
          final imagePath = '${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
          final File imageFile = File(imagePath);
          await imageFile.writeAsBytes(croppedImage);

          await Share.shareFiles([imagePath], text: 'PDF Screenshot');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing screenshot: $e')),
      );
    } finally {
      setState(() {
        _isSelectingArea = false;
        _selectedArea = null;
        _selectionStart = null;
      });
    }
  }*/
  Future<void> _captureSelectedArea() async {
    if (_selectedArea == null) return;

    try {
      // Capture the screenshot of the PDF viewer
      final Uint8List? fullImage = await _screenshotController.capture(
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      );
      // final tempDir = await getTemporaryDirectory();
      // final fullImagePath = '${tempDir.path}/full_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      // await File(fullImagePath).writeAsBytes(fullImage);
      // print('Full screenshot saved to: $fullImagePath');

      if (fullImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture screenshot')),
        );
        return;
      }

      // Decode the captured image to get its dimensions
      final img.Image? decodedImage = img.decodeImage(fullImage);
      if (decodedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to decode screenshot')),
        );
        return;
      }
      print(
          'Captured image size: ${decodedImage.width}x${decodedImage.height}');

      // Adjust the selected area coordinates for the pixel ratio
      final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final Rect adjustedArea = Rect.fromLTRB(
        _selectedArea!.left * pixelRatio,
        _selectedArea!.top * pixelRatio,
        _selectedArea!.right * pixelRatio,
        _selectedArea!.bottom * pixelRatio,
      );

      // Crop the image
      final croppedImage = await _cropImage(fullImage, adjustedArea);

      if (croppedImage != null) {
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
        final File imageFile = File(imagePath);
        await imageFile.writeAsBytes(croppedImage);

        // Log the cropped image size
        final img.Image? croppedDecoded = img.decodeImage(croppedImage);
        print(
            'Cropped image size: ${croppedDecoded?.width}x${croppedDecoded?.height}');

        setState(() {
          _selectedImage = XFile(imagePath);
          _isSelectingArea = false;
          _selectedArea = null;
          _selectionStart = null;
          _showQuestionPanel = true;
        });

        // Optionally share the screenshot
        // await Share.shareFiles([imagePath], text: 'PDF screenshot');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error cropping screenshot')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing screenshot: $e')),
      );
    } finally {
      setState(() {
        _isSelectingArea = false;
        _selectedArea = null;
        _selectionStart = null;
      });
    }
  }

  Future<Uint8List?> _cropImage(Uint8List imageBytes, Rect region) async {
    try {
      // Decode the image
      final img.Image? decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        print('Error: Failed to decode image');
        return null;
      }

      // Calculate the cropping dimensions
      final int x = region.left.toInt().clamp(0, decodedImage.width);
      final int y = region.top.toInt().clamp(0, decodedImage.height);
      final int width = region.width.toInt().clamp(0, decodedImage.width - x);
      final int height =
          region.height.toInt().clamp(0, decodedImage.height - y);

      print('Crop dimensions: x=$x, y=$y, width=$width, height=$height');
      print(
          'Image dimensions: width=${decodedImage.width}, height=${decodedImage.height}');

      // Ensure the crop dimensions are valid
      if (width <= 0 || height <= 0) {
        print('Error: Invalid crop dimensions (width or height is zero)');
        return null;
      }

      // Crop the image
      final img.Image croppedImage = img.copyCrop(
        decodedImage,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      // Encode the cropped image as PNG
      final Uint8List? encodedImage = img.encodePng(croppedImage);
      if (encodedImage == null) {
        print('Error: Failed to encode cropped image');
        return null;
      }

      return encodedImage;
    } catch (e) {
      print('Error cropping image: $e');
      return null;
    }
  }

  Future<File?> _captureFullPageScreenshot() async {
    try {
      final Uint8List? fullImage = await _screenshotController.capture(
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      );

      if (fullImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture page screenshot')),
        );
        return null;
      }

      final img.Image? decodedImage = img.decodeImage(fullImage);
      if (decodedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to decode screenshot')),
        );
        return null;
      }

      final Uint8List? encodedImage = img.encodePng(decodedImage);
      if (encodedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to encode screenshot')),
        );
        return null;
      }

      final directory = await getTemporaryDirectory();
      final imagePath =
          '${directory.path}/fullpage_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
      final File imageFile = File(imagePath);
      await imageFile.writeAsBytes(encodedImage);

      return imageFile;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing page screenshot: $e')),
      );
      return null;
    }
  }

  Future<void> _startMcqExam() async {
    final pageImage = await _captureFullPageScreenshot();
    if (pageImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to capture page screenshot')),
      );
      return;
    }

    print(
        "userid: ${widget.userId}\n courseId: ${widget.courseId}\n chapterId: ${widget.chapterId}\n pageId:${_pdfController?.page ?? widget.startPage}\n pageimage ${pageImage.path}");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => McqView(
          userId: widget.userId,
          courseId: widget.courseId,
          chapterId: widget.chapterId,
          pageId: (_pdfController?.page ?? widget.startPage).toString(),
          isFullExam: "N",
          pageImage: pageImage, // Pass the base64-encoded screenshot
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _playAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $e')),
      );
    }
  }

  void _submitQuestion() {
    final question = _questionController.text;
    final image = _selectedImage;

    // TODO: Implement API call to submit question with image

    _questionController.clear();
    setState(() {
      _selectedImage = null;
      _showQuestionPanel = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question submitted to AI Tutor')),
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    _audioPlayer.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _takeScreenshot,
            tooltip: 'Take Screenshot',
          ),
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => setState(() => _showQuestionPanel = true),
            tooltip: 'Ask AI Tutor',
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => setState(() => _showRightDrawer = true),
            tooltip: 'Open Menu',
          ),
        ],
      ),
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Screenshot(
                  controller: _screenshotController,
                  child: _buildPdfViewer(),
                ),
              ),
              if (_showRightDrawer) _buildRightDrawer(),
            ],
          ),
          if (_isSelectingArea) _buildAreaSelectionOverlay(),
          if (_showQuestionPanel) _buildQuestionPanel(),
        ],
      ),
    );
  }

  Widget _buildPdfViewer() {
    return _error != null
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
            ? const Center(child: CircularProgressIndicator(color: TColors.primaryColor,))
            : PdfView(
                controller: _pdfController!,
                onDocumentError: (error) {
                  setState(() {
                    _error = 'Error rendering PDF: $error';
                  });
                },
              );
  }

  Widget _buildRightDrawer() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chapter Tools',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _showRightDrawer = false),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Give MCQ Exam'),
            onTap: _startMcqExam,
          ),
          ListTile(
            leading: const Icon(Icons.audiotrack),
            title: const Text('Audio Explanation'),
            onTap: () {
              // TODO: Replace with actual audio URL from API
              _playAudio('https://example.com/audio.mp3');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Bookmark Page'),
            onTap: () {
              // TODO: Implement bookmarking
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Page Navigation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (_pdfController != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Go to Page',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        final page = int.tryParse(value);
                        if (page != null && _pdfController != null) {
                          _pdfController!.animateToPage(
                            page - 1, // Just pass the page number directly
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Then modify the area selection handlers
  Widget _buildAreaSelectionOverlay() {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          _selectionStart = details.localPosition;
          _selectedArea = Rect.fromPoints(
            details.localPosition,
            details.localPosition,
          );
        });
      },
      onPanUpdate: (details) {
        setState(() {
          _selectedArea = Rect.fromPoints(
            _selectionStart!,
            details.localPosition,
          );
        });
      },
      onPanEnd: (_) async {
        await _captureSelectedArea();
      },
      child: Stack(
        children: [
          // Semi-transparent overlay with CustomPaint for the selected area
          CustomPaint(
            size: Size.infinite,
            painter: _AreaSelectionPainter(_selectedArea),
          ),
          // Button to confirm the selection
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: ElevatedButton(
                onPressed: _captureSelectedArea,
                child: const Text('Capture Selected Area'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ask AI Tutor',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _showQuestionPanel = false),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Type your question about this page...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
              ),
              maxLines: 3,
            ),
            if (_selectedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Stack(
                  children: [
                    Image.file(
                      File(_selectedImage!.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => setState(() => _selectedImage = null),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submitQuestion,
                child: const Text('Submit Question'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AreaSelectionPainter extends CustomPainter {
  final Rect? selectedArea;

  _AreaSelectionPainter(this.selectedArea);

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedArea == null) return;

    // Draw semi-transparent overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    // Draw the entire screen with the overlay
    canvas.drawRect(Offset.zero & size, overlayPaint);

    // Draw border around selected area
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(selectedArea!, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _AreaSelectionPainter oldDelegate) {
    return oldDelegate.selectedArea != selectedArea;
  }
}
