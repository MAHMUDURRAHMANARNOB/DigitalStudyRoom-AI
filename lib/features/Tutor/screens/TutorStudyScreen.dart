import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/markdown_widget.dart' as MW;
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart'; // Updated import

import '../../../common/latexGenerator.dart';
import '../../../utils/constants/colors.dart';
import '../../authentication/providers/AuthProvider.dart';
import '../providers/TutorResponseProvider.dart';

class TutorStudyScreen extends StatefulWidget {
  final String topic;
  final String subject;
  const TutorStudyScreen({super.key, required this.topic, required this.subject});

  @override
  _TutorStudyScreenState createState() => _TutorStudyScreenState();
}

class _TutorStudyScreenState extends State<TutorStudyScreen> {
  AudioPlayer _audioPlayer = AudioPlayer();
  late AudioRecorder audioRecorder; // Updated: Use AudioRecorder instead of Record
  String? _sessionId;
  File? _audioFile;
  bool _isRecording = false;
  String? _audioPath;
  TextEditingController _textController = TextEditingController();
  late String courseTopic;
  late String _subject;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    _checkPermissions();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
    courseTopic = widget.topic;
    _subject = widget.subject;
    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {});
    });
    print(courseTopic);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTutorResponse();
    });

    audioRecorder = AudioRecorder(); // Initialize AudioRecorder
  }

  Future<void> _fetchTutorResponse() async {
    await Provider.of<TutorResponseProvider>(context, listen: false).getTutorResponse(
      userID, // userid
      authProvider.user!.name, // userName
      '', // nextLesson (not required for the first call)
      '1', // TutorId
      gradeClass, // className
      _subject, // SubjectName
      courseTopic, // courseTopic
      _sessionId, // sessionID (null for the first call)
      null, // audioFile (null for the first call)
      null, // answerText (null for the first call)
    );

    final response = Provider.of<TutorResponseProvider>(context, listen: false).successResponse;

    if (response != null) {
      // Update sessionID for subsequent API calls
      setState(() {
        _sessionId = response.sessionId;
      });

      // Play the audio
      if (response.aiDialogAudio.isNotEmpty) {
        _audioPlayer.play(UrlSource(response.aiDialogAudio));
      }
    }
  }

  Future<void> startRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        _audioPlayer.stop();

        // Get the directory for saving the recording
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/recording.m4a'; // Save as .m4a file

        // Start recording with the specified path
        await audioRecorder.start(RecordConfig(), path: path); // Updated: Added path parameter

        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      print("Error start recording: $e");
    }
  }

  Future<void> stopRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) { // Updated: Request permission
        final path = await audioRecorder.stop(); // Updated: Stop recording
        if (path != null) {
          final file = File(path);
          if (await file.exists()) {
            _audioFile = file;
            print("Recorded file path: $path");
          } else {
            print("File not found at path: $path");
          }
        }
        if (path != null && File(path).existsSync()) {
          setState(() {
            _isRecording = false;
            _audioPath = path;
            _audioFile = File(_audioPath!);
          });
          await _sendAudioToAPI();
        } else {
          setState(() {
            _isRecording = false;
          });
          print("File not found at path: $path");
        }
      } else {
        print("Permission denied for microphone");
      }
    } catch (e) {
      print("Error stop recording: $e");
    }
  }

  Future<void> _sendAudioToAPI() async {
    if (_audioFile == null) return;

    await Provider.of<TutorResponseProvider>(context, listen: false).getTutorResponse(
      userID, // userid
      authProvider.user!.name, // userName
      '', // nextLesson (not required)
      '1', // TutorId
      gradeClass, // className
      _subject, // SubjectName
      courseTopic, // courseTopic
      _sessionId, // sessionID (updated after the first call)
      _audioFile, // audioFile (recorded audio)
      null, // answerText
    );

    final response = Provider.of<TutorResponseProvider>(context, listen: false).successResponse;

    if (response != null) {
      // Update sessionID for future API calls
      setState(() {
        _sessionId = response.sessionId;
      });

      // Play the new audio response
      if (response.aiDialogAudio.isNotEmpty) {
        _audioPlayer.play(UrlSource(response.aiDialogAudio));
      }
    }
  }

  Future<void> _sendTextToAPI(String answerText) async {
    await Provider.of<TutorResponseProvider>(context, listen: false).getTutorResponse(
      userID, // userid
      authProvider.user!.name, // userName
      '', // nextLesson (not required)
      '1', // TutorId
      gradeClass, // className
      _subject, // SubjectName
      courseTopic, // courseTopic
      _sessionId, // sessionID (updated after the first call)
      null, // audioFile
      answerText, // answerText
    );
  }

  Future<void> _checkPermissions() async {
    if (await Permission.microphone.request().isGranted) { // Updated: Request permission
      print("Microphone permission granted");
    } else {
      print("Microphone permission denied");
    }
  }

  late int userID;
  late String gradeClass;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TutorResponseProvider>(context);

    userID = authProvider.user!.id;
    gradeClass = authProvider.user!.classId.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor AI Interaction'),
        centerTitle: true,
      ),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator(color: TColors.tertiaryColor,))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: TColors.tertiaryColor),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: MW.MarkdownWidget(
                  data: provider.successResponse?.aiDialog ?? 'No AI response yet.',
                  shrinkWrap: true,
                  selectable: true,
                  config: MarkdownConfig.defaultConfig,
                  markdownGenerator: MarkdownGenerator(generators: [latexGenerator], inlineSyntaxList: [LatexSyntax()]),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _isRecording ? Colors.red : Colors.blue),
                onPressed: _textController.text.isNotEmpty ? null : (_isRecording ? stopRecording : startRecording),
                child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
              ),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: 'Type your answer',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send,color: TColors.primaryColor),
                    onPressed: _textController.text.isEmpty ? null : () {
                      _sendTextToAPI(_textController.text);
                      _textController.clear();
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    audioRecorder.dispose(); // Dispose the AudioRecorder
    _textController.dispose();
    super.dispose();
  }
}