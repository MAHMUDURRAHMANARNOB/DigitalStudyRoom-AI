import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:digital_study_room/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/markdown_widget.dart' as MW;
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart'; // Updated import
import 'package:shimmer/shimmer.dart';

import '../../../common/latexGenerator.dart';
import '../../../utils/constants/colors.dart';
import '../../authentication/providers/AuthProvider.dart';
import '../../profile/packagesScreen.dart';
import '../providers/TutorResponseProvider.dart';

class TutorStudyScreen extends StatefulWidget {
  final String topic;
  final String subject;
  final int chapterId;

  const TutorStudyScreen(
      {super.key,
      required this.topic,
      required this.subject,
      required this.chapterId});

  @override
  _TutorStudyScreenState createState() => _TutorStudyScreenState();
}

class _TutorStudyScreenState extends State<TutorStudyScreen> {
  List<Widget> _conversationComponents = [];
  AudioPlayer _audioPlayer = AudioPlayer();
  late AudioRecorder audioRecorder;
  String? _sessionId;
  File? _audioFile;
  bool _isRecording = false;
  String? _audioPath;
  TextEditingController _askQuescontroller = TextEditingController();
  late String courseTopic;
  late String _subject;
  late int _chapterId;
  late AuthProvider authProvider;
  ScrollController _scrollController = ScrollController();
  late String inputText = '';

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();
    audioRecorder = AudioRecorder(); // Initialize AudioRecorder
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    courseTopic = widget.topic;
    userID = authProvider.user!.id;
    gradeClass = authProvider.user!.classId.toString();
    _subject = widget.subject;
    _chapterId = widget.chapterId;
    _askQuescontroller = TextEditingController();
    _askQuescontroller.addListener(_textChangeListener);
    _requestMicrophonePermission();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _conversationComponents.add(firstAIResponse());
    });
  }

  bool _isTextQuestion = false;

  void _textChangeListener() {
    setState(() {
      _isTextQuestion = _askQuescontroller.text.isNotEmpty;
    });
  }

  Future<void> startRecording() async {
    try {
      if (await Permission.microphone.request().isGranted) {
        _audioPlayer.stop();

        // Get the directory for saving the recording
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/recording.m4a'; // Save as .m4a file

        // Start recording with the specified path
        await audioRecorder.start(RecordConfig(),
            path: path); // Updated: Added path parameter

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
      if (await Permission.microphone.request().isGranted) {
        // Updated: Request permission
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
            _conversationComponents.add(
              TutorAIAudioRespose(
                audioFile: _audioFile, // This will be null for text-based input
              ),
            );
          });
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

    setState(() {
      // Add AI response to UI
    });
  }

  Widget firstAIResponse() {
    final tutorResponseProvider =
        Provider.of<TutorResponseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<void>(
      future: tutorResponseProvider.getTutorResponse(
        userID,
        // userid
        authProvider.user!.name,
        // userName
        '',
        // nextLesson (not required for the first call)
        '1',
        // TutorId
        gradeClass,
        // className
        _subject,
        // SubjectName
        courseTopic,
        // courseTopic
        _sessionId,
        // sessionID (null for the first call)
        null,
        // audioFile (null for the first call)
        null,
        // answerText (null for the first call)
        _chapterId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                  child: Image.asset(
                    "assets/icons/dsr_icon.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                SizedBox(
                  child: Shimmer.fromColors(
                    baseColor: TColors.primaryColor,
                    highlightColor: Colors.white,
                    child: const Text(
                      'Starting Your Session...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ); // Loading state
        } else if (snapshot.hasError) {
          return Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: TColors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Sorry: Server error",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          int errorCode = tutorResponseProvider.successResponse!.errorCode;
          _sessionId = tutorResponseProvider.successResponse!.sessionId;
          // print(errorCode);

          if (errorCode == 200) {
            return buildAiTextResponse(
                context, snapshot, tutorResponseProvider);
          } else if (errorCode == 201) {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: TColors.white,
                border: Border.all(color: TColors.primaryColor),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Sorry: ${tutorResponseProvider.successResponse?.message ?? ''}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PackagesScreen()),
                        );
                      },
                      child: const Text(
                        "Purchase Minutes",
                        style: TextStyle(
                          color: TColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: TColors.secondaryColor.withOpacity(0.1),
              ),
              padding: EdgeInsets.all(10.0),
              child: Text(tutorResponseProvider.successResponse?.message ??
                  "404: Server Issue"),
            );
          }
        }
      },
    );
  }

  Widget TutorTextAIResponse(String answerText) {
    final tutorResponseProvider =
        Provider.of<TutorResponseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<void>(
      future: tutorResponseProvider.getTutorResponse(
        userID,
        authProvider.user!.name,
        '',
        // nextLesson (not required)
        '1',
        // TutorId
        gradeClass,
        // className
        _subject,
        // SubjectName
        courseTopic,
        // courseTopic
        _sessionId,
        // sessionID (updated after the first call)
        null,
        // audioFile
        answerText,
        // answerText
        _chapterId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                  child: Image.asset(
                    "assets/icons/dsr_icon.png",
                    height: 30,
                    width: 30,
                  ),
                ),
                SizedBox(
                  child: Shimmer.fromColors(
                    baseColor: TColors.primaryColor,
                    highlightColor: Colors.white,
                    child: const Text(
                      'Analyzing...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ); // Loading state
        } else if (snapshot.hasError) {
          return Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: TColors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Sorry: Server error",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          int? errorCode = tutorResponseProvider.successResponse!.errorCode;

          print(errorCode);

          if (errorCode == 200) {
            _sessionId = tutorResponseProvider.successResponse!.sessionId;
            return buildAiTextResponse(
                context, snapshot, tutorResponseProvider);
          } else if (errorCode == 201) {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: TColors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Sorry: ${tutorResponseProvider.successResponse?.message ?? ''}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PackagesScreen()),
                        );
                      },
                      child: const Text(
                        "Purchase Minutes",
                        style: TextStyle(
                          color: TColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: TColors.secondaryColor.withOpacity(0.1),
              ),
              padding: EdgeInsets.all(10.0),
              child: Text(tutorResponseProvider.successResponse?.message ??
                  "404: Server Issue"),
            );
          }
        }
      },
    );
  }

  Widget buildAiTextResponse(BuildContext context, AsyncSnapshot<void> snapshot,
      TutorResponseProvider tutorResponseProvider) {
    final response = tutorResponseProvider.successResponse;
    int errorCode = response!.errorCode;
    if (errorCode == 200) {
      String aiDialogAudio = response!.aiDialogAudio!;
      String aiDialogText = response!.aiDialog ?? "";
      String userAudio = response!.userAudioFile!;
      String userText = response!.userText ?? "";
      if (aiDialogAudio != null) {
        Source urlSource = UrlSource(aiDialogAudio);
        _audioPlayer.play(urlSource);
      }

      return Container(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            /*Ai Row*/
            aiDialogText != ""
                ? Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                                  child: Image.asset(
                                    "assets/icons/dsr_icon.png",
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        _audioPlayer.pause();
                                      },
                                      icon: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: TColors.secondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(64),
                                        ),
                                        child: Icon(
                                          Icons.pause,
                                          color: TColors.white,
                                          // size: 30,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Source urlSource =
                                            UrlSource(aiDialogAudio);
                                        _audioPlayer.play(urlSource);
                                      },
                                      icon: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: TColors.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(64),
                                        ),
                                        child: Icon(
                                          Icons.volume_down_rounded,
                                          color: TColors.white,
                                          // size: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  /*color: TColors.primaryColor
                                    .withOpacity(0.3),*/
                                  border:
                                      Border.all(color: TColors.primaryColor)),
                              padding: EdgeInsets.all(10.0),
                              child: MW.MarkdownWidget(
                                data: aiDialogText,
                                shrinkWrap: true,
                                selectable: true,
                                config: MarkdownConfig.defaultConfig,
                                markdownGenerator: MarkdownGenerator(
                                    generators: [latexGenerator],
                                    inlineSyntaxList: [LatexSyntax()]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                    ],
                  )
                : SizedBox(
                    width: 2,
                    child: Text("Some error in server"),
                  ),
          ],
        ),
      );
    } else if (errorCode == 201) {
      return Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: TColors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                "Sorry: ${tutorResponseProvider.successResponse!.message}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PackagesScreen()),
                  );
                },
                child: const Text(
                  "Purchase Minutes",
                  style: TextStyle(
                    color: TColors.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(12.0),
        child: Text(tutorResponseProvider.successResponse!.message!),
      );
    }
  }

  Widget TutorAIAudioRespose({File? audioFile}) {
    final tutorResponseProvider =
        Provider.of<TutorResponseProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<void>(
      future: tutorResponseProvider.getTutorResponse(
        userID,
        authProvider.user!.name,
        '',
        '1',
        gradeClass,
        _subject,
        courseTopic,
        _sessionId,
        audioFile,
        // Pass recorded audio file if available
        null,
        // Pass text answer if available
        _chapterId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget(); // Show loading indicator
        } else if (snapshot.hasError) {
          return _buildErrorWidget(); // Show error message
        } else {
          final response = tutorResponseProvider.successResponse;
          int errorCode = response!.errorCode;
          if (errorCode == 200) {
            _sessionId = tutorResponseProvider.successResponse!.sessionId;
            String aiDialogAudio = response!.aiDialogAudio!;
            String aiDialogText = response!.aiDialog ?? "";
            String userAudio = response!.userAudioFile!;
            String userText = response!.userText ?? "";
            if (aiDialogAudio != null) {
              Source urlSource = UrlSource(aiDialogAudio);
              _audioPlayer.play(urlSource);
            }

            return Container(
              padding: EdgeInsets.all(5.0),
              child: Column(
                children: [
                  /*Ai Row*/
                  aiDialogText != ""
                      ? Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                            5.0, 0.0, 5.0, 5.0),
                                        child: Image.asset(
                                          "assets/icons/dsr_icon.png",
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _audioPlayer.pause();
                                            },
                                            icon: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: TColors.secondaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(64),
                                              ),
                                              child: Icon(
                                                Icons.pause,
                                                color: TColors.white,
                                                // size: 30,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Source urlSource =
                                                  UrlSource(aiDialogAudio);
                                              _audioPlayer.play(urlSource);
                                            },
                                            icon: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: TColors.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(64),
                                              ),
                                              child: Icon(
                                                Icons.volume_down_rounded,
                                                color: TColors.white,
                                                // size: 30,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        /*color: TColors.primaryColor
                                    .withOpacity(0.3),*/
                                        border: Border.all(
                                            color: TColors.primaryColor)),
                                    padding: EdgeInsets.all(10.0),
                                    child: MW.MarkdownWidget(
                                      data: aiDialogText,
                                      shrinkWrap: true,
                                      selectable: true,
                                      config: MarkdownConfig.defaultConfig,
                                      markdownGenerator: MarkdownGenerator(
                                          generators: [latexGenerator],
                                          inlineSyntaxList: [LatexSyntax()]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                          ],
                        )
                      : SizedBox(
                          width: 2,
                          child: Text("Some error in server"),
                        ),
                ],
              ),
            );
          } else if (errorCode == 201) {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: TColors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Sorry: ${tutorResponseProvider.successResponse!.message}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primaryColor),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PackagesScreen()),
                        );
                      },
                      child: const Text(
                        "Purchase Minutes",
                        style: TextStyle(
                          color: TColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.all(12.0),
              child: Text(tutorResponseProvider.successResponse!.message!),
            );
          }
        }
      },
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: [
          Image.asset("assets/icons/dsr_icon.png", height: 30, width: 30),
          SizedBox(width: 10),
          Shimmer.fromColors(
            baseColor: TColors.primaryColor,
            highlightColor: Colors.white,
            child: const Text(
              'Analyzing...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Sorry: Server error",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseWidget(String? message) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: TColors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Text("Sorry: ${message ?? ''}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: TColors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PackagesScreen()));
            },
            child: const Text("Purchase Minutes",
                style: TextStyle(color: TColors.primaryColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericErrorWidget(String? message) {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: TColors.secondaryColor.withOpacity(0.1),
      ),
      padding: EdgeInsets.all(10.0),
      child: Text(message ?? "404: Server Issue"),
    );
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      print('Microphone permission granted');
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    } else {
      print('Microphone permission denied');
    }
  }

  late int userID;
  late String gradeClass;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TutorResponseProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;

    userID = authProvider.user!.id;
    gradeClass = authProvider.user!.classId.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor AI Interaction'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
                children: _conversationComponents,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              // color: TColors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              border: Border.all(color: TColors.primaryColor, width: 0.1),
            ),
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                /*Question Asking*/
                _isRecording
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.0),
                        child: Text("Recording in progress ..."),
                      )
                    : TextField(
                        controller: _askQuescontroller,
                        maxLines: 3,
                        minLines: 1,
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: screenHeight * 0.020,
                        ),
                        cursorColor: TColors.primaryColor,
                        decoration: const InputDecoration(
                          hintText: 'Speak or Type..',
                          hintStyle: TextStyle(),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                        onChanged: (value) {
                          setState(() {
                            inputText = value;
                            _isTextQuestion = value.isNotEmpty;
                            // _isMyMessage = true;
                          });
                        },
                      ),
                SizedBox(
                  height: 5,
                ),
                /*SEND / VOICE*/
                Stack(
                  children: [
                    // Send or Voice button
                    Align(
                      alignment: Alignment.center,
                      child: _isTextQuestion == true
                          ? IconButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 4,
                              ),
                              onPressed: () {
                                // Add your logic to send the message
                                _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeOut);
                                setState(() {
                                  _conversationComponents.add(
                                    TutorTextAIResponse(
                                        _askQuescontroller.text),
                                  );
                                  /*_conversationComponents
                                      .add(AIResponseBox(audioFile!, sessionId));*/

                                  _askQuescontroller.clear();
                                });
                              },
                              icon: Container(
                                padding: EdgeInsets.all(screenHeight * 0.010),
                                child: Icon(
                                  Icons.send_rounded,
                                  color: TColors.primaryColor,
                                  size: screenHeight * 0.03,
                                ),
                              ))
                          : AvatarGlow(
                              animate: _isRecording,
                              curve: Curves.fastOutSlowIn,
                              glowColor: TColors.primaryColor,
                              duration: const Duration(milliseconds: 1000),
                              repeat: true,
                              glowRadiusFactor: 1,
                              child: IconButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isRecording == false
                                      ? Colors.white
                                      : TColors.primaryColor,
                                  elevation: 4,
                                ),
                                onPressed: () async {
                                  /*_onMicrophoneButtonPressed;*/
                                  if (!_isRecording) {
                                    await startRecording();
                                  } else {
                                    await stopRecording();
                                  }
                                  setState(
                                      () {}); // Update UI based on recording state
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(screenHeight * 0.020),
                                  child: Icon(
                                    _isRecording == false
                                        ? Icons.keyboard_voice_rounded
                                        : Icons.stop_rounded,
                                    /*Icons.keyboard_voice_rounded,*/
                                    color: _isRecording == false
                                        ? TColors.primaryColor
                                        : Colors.white,
                                    size: screenHeight * 0.04,
                                  ),
                                ),
                              ),
                            ),
                    ),

                    // New Question
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    audioRecorder.dispose(); // Dispose the AudioRecorder
    _askQuescontroller.dispose();
    super.dispose();
  }
}
