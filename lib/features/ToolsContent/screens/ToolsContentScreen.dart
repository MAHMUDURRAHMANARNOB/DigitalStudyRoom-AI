import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:digital_study_room/features/ToolsContent/provider/studyToolsProvider.dart';
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../datamodel/studyToolsDataModel.dart';
import '../provider/ToolsResponseProvider.dart';
import '../provider/toolsDataByCodeProvider.dart';
import '../provider/toolsReplyProvider.dart';

class ToolsContentScreen extends StatefulWidget {
  final String? staticToolsCode;

  const ToolsContentScreen({super.key, this.staticToolsCode});

  @override
  State<ToolsContentScreen> createState() => _ToolsContentScreenState();
}

class _ToolsContentScreenState extends State<ToolsContentScreen> {

  List<Widget> _lessonComponents = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String dropdownClassValue = "";
  String dropdownSubjectValue = "";
  TextEditingController questionTextFieldController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late ToolsDataProvider toolsDataProvider;
  late StudyToolsProvider toolsProvider;

  late ToolsResponseProvider toolsResponseProvider =
  Provider.of<ToolsResponseProvider>(context, listen: false);

  late ToolsReplyProvider toolsReplyProvider =
  Provider.of<ToolsReplyProvider>(context, listen: false);



  File? _selectedImage;
  bool _isImageSelected = false;
  bool isSelected = false;
  bool isImagePicked = false;
  bool _isReply = false;
  bool _isNewQuestion = false;

  late int userID = 2;
  late int _selectedticketId;
  late bool isLoading = true;

  late String _selectedToolsCode;
  late String _selectedToolName = '';
  late String _selectedClassName = 'null';
  late String _selectedSubjectName = 'null';
  late String _question = '';
  late String _maxLine = '';
  final String _isMobile = 'Y';

  bool maxWordVisibility = false;
  bool subjectSelectionVisibility = false;
  bool mathKeyboardVisibility = false;

  // late SpeechToText _speech;
  bool _isListening = false;
  bool toolsFetched = false;

  @override
  void initState() {
    super.initState();

    // Initialize toolsProvider in initState
    // final authProvider = context.read<AuthProvider>();
    toolsProvider = StudyToolsProvider(userId: 2);

    // Fetch tools here once during the widget lifecycle
    fetchTools(toolsProvider);

    // _speech = SpeechToText();
  }

  Future<void> fetchTools(StudyToolsProvider toolsProvider) async {
    if (!toolsFetched) {
      await toolsProvider.fetchTools();
      setState(() {
        isLoading = false;
        toolsFetched = true; // Set the flag to true after fetching tools
      });
      selectToolByCode(widget.staticToolsCode!, toolsProvider);
    }
  }
  Future<void> selectToolByCode(
      String toolsCode, StudyToolsProvider toolsProvider) async {
    // Find the corresponding tool in the toolsProvider
    List<StudyToolsDataModel> matchingTools = toolsProvider.tools
        .where((tool) => tool.toolsCode == toolsCode)
        .toList();

    print("matchingTool -> ${toolsProvider.tools.length}");
    print("ppp: $userID,${matchingTools.first.toolName}");
    if (matchingTools.isNotEmpty) {
      isLoading = false;
      StudyToolsDataModel selectedTool = matchingTools.first;

      // resetSelectedClassAndSubject();
      _scaffoldKey.currentState?.closeEndDrawer();

      print("ppp: $userID,${selectedTool.toolID}");
      // Perform the actions just like in the onPressed handler
      toolsDataProvider.fetchToolsData(userID, selectedTool.toolID);

      setState(() {
        _selectedToolsCode = selectedTool.toolsCode;
        _selectedToolName = selectedTool.toolName;
      });

      if (selectedTool.maxWord == "Y") {
        setState(() {
          maxWordVisibility = true;
        });
      } else {
        setState(() {
          maxWordVisibility = false;
        });
      }

      if (selectedTool.mathKeyboard == "Y") {
        setState(() {
          mathKeyboardVisibility = true;
        });
      } else {
        setState(() {
          mathKeyboardVisibility = false;
        });
      }

      if (selectedTool.subject == "Y") {
        setState(() {
          // subjectSelectionVisibility = true;
        });
      } else {
        setState(() {
          // subjectSelectionVisibility = false;
        });
      }
    } else {
      // Handle the case when the tool with toolsCode is not found
      print("Tool with toolsCode $toolsCode not found");
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    toolsDataProvider = Provider.of<ToolsDataProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedToolName),
        centerTitle: true,
      ),
      floatingActionButton: Visibility(
        visible: !_isNewQuestion && !_isReply,
        child: _lessonComponents.isEmpty
            ? FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              _isNewQuestion = true;
              _isReply = false;
            });
          },
          label: const Text(
            'New Question',
            style: TextStyle(
              color: TColors.primaryColor,
            ),
          ),
          icon: const Icon(
            Icons.add,
            color: TColors.primaryColor,
          ),
          backgroundColor: TColors.primaryBackground,
        )
            : FloatingActionButton(
          onPressed: () {
            setState(() {
              _isNewQuestion = true;
              _isReply = false;
            });
          },
          backgroundColor: TColors.primaryBackground,
          child: Icon(
            Icons.question_answer_outlined,
            color: TColors.primaryColor,
          ),
        ),
      ),
      body: SafeArea(child: MainContent()),
    );
  }

  Widget MainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /*Text(
          _selectedToolName,
          style: TextStyle(color: Colors.green, fontSize: 12.0),
        ),*/
        
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            // color: Colors.grey[100],
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: _lessonComponents.isNotEmpty
                  ? Column(
                children: _lessonComponents,
              )
                  : Container(
                decoration: BoxDecoration(
                  color: TColors.light,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to HomeWork Board',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your selected tool is - $_selectedToolName',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: TColors.primaryColor),
                    ),
                    /*UnorderedList([
                                "What conclusions can we draw from the implementation?",
                                "Are there any changes that need to be introduced permanently?"
                              ]),*/
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '⚈ Now select your class and subject from below dropdown',
                        ),
                        Text(
                          "⚈ Write down your question or problem",
                        ),
                        Text(
                          "⚈ You can add image if you want",
                        ),
                        Text(
                          "⚈ Send and get the solution",
                        ),
                        Text(
                          "⚈ From the top-right corner menu, you can explore more tools",
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      "Now Keep Simplifying 😉",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        _isNewQuestion == true
            ? newQuestionBarWidget()
            : _buildReplyContainer(),
      ],
    );
  }
  void _removeImage() {
    setState(() {
      // _selectedImage = null;
    });
  }
  Widget newQuestionBarWidget() {
    return Column(
      children: [
        Visibility(
          // visible: _isNewQuestion,
          child: Container(
            // color: TColors.primaryCardColor,
            padding: EdgeInsets.fromLTRB(8.0, 2.0, 5.0, 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  // visible: _isNewQuestion,
                  child: const Text("Talk about your confusion "),
                ),
                IconButton(
                  style: ElevatedButton.styleFrom(
                      // backgroundColor: TColors.backgroundColorDark,
                  ),
                  onPressed: () {
                    // Add your logic to send the message
                    setState(() {
                      _isNewQuestion = false;
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    // color: TColors.primaryColor,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        /*BOTTOM CONTROL 1ST ROW*/
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8.0, 5.0, 5.0, 2.0),
          decoration: const BoxDecoration(
            // color: TColors.backgroundColorDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /*SELECTED CLASS*/
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: /*Consumer<ToolsDataProvider>(
                  builder: (context, toolsDataProvider, child) {
                    return *//*buildDropdownMenuClass()*//* buildChipClass(
                        toolsDataProvider);
                  },
                ),*/Text("Selected Class"),
              ),
              /*SELECTED SUBJECT*/
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Visibility(
                  // visible: subjectSelectionVisibility,
                  child: /*Consumer<ToolsDataProvider>(
                    builder: (context, toolsDataProvider, child) {
                      return *//*buildDropdownMenuSubjects()*//* buildChipSubjects(
                          toolsDataProvider);
                    },
                  ),*/Text("Selected Subject"),
                ),
              ),

            ],
          ),
        ),
        /*BOTTOM CONTROL 2ND ROW*/
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(8.0, 2.0, 5.0, 5.0),
          decoration: const BoxDecoration(
            // color: TColors.backgroundColorDark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /*Picked Image*/
              if (_selectedImage != null)
                Visibility(
                  visible: _isImageSelected,
                  child: Stack(
                    children: [
                      ClipPath(
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: 80,
                          width: 80,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _removeImage,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                              Colors.red, // Background color of the button
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.white, // Color of the icon
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              /*TYPE MESSAGE*/
              TextField(
                controller: questionTextFieldController,
                maxLines: 3,
                minLines: 1,
                cursorColor: TColors.primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Speak, Add Image or Type..',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                ),
                onChanged: (value) {
                  _question = value;
                },
              ),
              /*BUTTON CONTROLS IMAGE, KEYBOARD, SEND*/
              
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Align items with space between them
                  children: [
                    IconButton(
                      onPressed: () {
                        // _showImageSourceDialog();
                        setState(() {
                          isImagePicked = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primaryBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                        ),
                      ),
                      iconSize: 24,
                      icon: const Icon(
                        Iconsax.gallery_add,
                        color: TColors.primaryColor,
                      ),
                    ),
                    AvatarGlow(
                      animate: _isListening,
                      curve: Curves.fastOutSlowIn,
                      glowColor: _isListening
                          ? TColors.primaryColor
                          : TColors.primaryBackground,
                      duration: const Duration(milliseconds: 1000),
                      repeat: true,
                      glowRadiusFactor: 0.2,
                      child: IconButton(
                        onPressed: (){}/*_listen*/,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primaryBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                          ),
                        ),
                        iconSize: 24,
                        icon: _isListening
                            ? Icon(
                          Iconsax.microphone,
                          color: TColors.primaryColor,
                        )
                            : Icon(
                          Icons.mic_none,
                          color: TColors.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        /*if (_selectedImage != null || _question.isNotEmpty) {
                          if (subjectSelectionVisibility) {
                            if (_selectedClassName != "null" &&
                                _selectedSubjectName != "null") {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                              if (isImagePicked) {
                                final Widget component =
                                generateComponentGettingImageResponse(
                                    context,
                                    _selectedImage!,
                                    userID,
                                    _question,
                                    _selectedSubjectName,
                                    _selectedClassName,
                                    _selectedToolsCode,
                                    _maxLine,
                                    _isMobile);

                                setState(() {
                                  _lessonComponents.add(component);
                                  isImagePicked = false;
                                  questionTextFieldController.clear();
                                  _selectedImage = null;
                                  _question = '';
                                  _isNewQuestion = false;
                                  _isReply = false;
                                });
                              } else if (_isReply) {
                                final Widget component =
                                generateComponentGettingToolsReply(
                                  context,
                                  userID,
                                  _selectedticketId!,
                                  _question ?? "what is this",
                                  _isMobile,
                                );
                                setState(() {
                                  _lessonComponents.add(component);
                                  questionTextFieldController.clear();
                                  _isReply = false;
                                  _isNewQuestion = false;
                                });
                              } else {
                                setState(() {
                                  _lessonComponents.add(
                                    generateComponentGettingResponse(
                                        context,
                                        userID,
                                        _question,
                                        _selectedSubjectName,
                                        _selectedClassName,
                                        _selectedToolsCode,
                                        _maxLine,
                                        _isMobile),
                                  );
                                  questionTextFieldController.clear();
                                  _selectedImage = null;
                                  _isImageSelected = false;
                                  _isReply = false;
                                  _isNewQuestion = false;
                                  _question = '';
                                });
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(child: const Text('Wait..')),
                                    content: Text(
                                      'You have to Select\n'
                                          '• Your Class\n'
                                          '• Your Subject\n'
                                          '• Your Question\n'
                                          'for our $_selectedToolName tool to work.',
                                    ),
                                  );
                                },
                              );
                            }
                          } else {
                            if (_selectedClassName != "null") {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                              if (isImagePicked) {
                                final Widget component =
                                generateComponentGettingImageResponse(
                                    context,
                                    _selectedImage!,
                                    userID,
                                    _question,
                                    _selectedSubjectName,
                                    _selectedClassName,
                                    _selectedToolsCode,
                                    _maxLine,
                                    _isMobile);

                                setState(() {
                                  _lessonComponents.add(component);
                                  isImagePicked = false;
                                  questionTextFieldController.clear();
                                  _selectedImage = null;
                                  _question = '';
                                  _isNewQuestion = false;
                                  _isReply = false;
                                });
                              } else if (_isReply) {
                                final Widget component =
                                generateComponentGettingToolsReply(
                                  context,
                                  userID,
                                  _selectedticketId!,
                                  _question ?? "what is this",
                                  _isMobile,
                                );
                                setState(() {
                                  _lessonComponents.add(component);
                                  questionTextFieldController.clear();
                                  _isReply = false;
                                  _isNewQuestion = false;
                                });
                              } else {
                                setState(() {
                                  _lessonComponents.add(
                                    generateComponentGettingResponse(
                                        context,
                                        userID,
                                        _question,
                                        _selectedSubjectName,
                                        _selectedClassName,
                                        _selectedToolsCode,
                                        _maxLine,
                                        _isMobile),
                                  );
                                  questionTextFieldController.clear();
                                  _selectedImage = null;
                                  _isImageSelected = false;
                                  _isReply = false;
                                  _isNewQuestion = false;
                                  _question = '';
                                });
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(child: const Text('Wait..')),
                                    content: Text(
                                      'You have to Select\n'
                                          '• Your Class\n'
                                          '• Your Question or Image\n'
                                          'for our $_selectedToolName tool to work.',
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(child: const Text('Wait..')),
                                content: Text(
                                  'You have to Select\n'
                                      '• Your Class\n'
                                      '• Your Question or Image\n'
                                      'for our $_selectedToolName tool to work.',
                                ),
                              );
                            },
                          );
                        }*/
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primaryBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                        ),
                      ),
                      iconSize: 20,
                      icon: const Icon(
                        Iconsax.send_2,
                        size: 24,
                        color: TColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Text("Chat may produce inaccurate information."),
      ],
    );
  }

  /*void _listen() async {
    if (!_isListening) {
      print("Listening if: $_isListening");
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        print("Listening if available: $_isListening");
        setState(() {
          _isListening = true;
        });

        // print("Listening if: $_isListening");
        _speech.listen(
          onResult: (val) => setState(() {
            // _text = val.recognizedWords;
            questionTextFieldController.text = val.recognizedWords;
            _question = val.recognizedWords;
            _isListening = false;
          }),
        );
      } else {
        setState(() {
          _isListening = false;
        });
      }
    } else {
      setState(() {
        _isListening = false;
        print("Listening else: $_isListening");
      });
      _speech.stop();
    }
  }*/

  Widget _buildReplyContainer() {
    return Visibility(
      visible: _isReply,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 5.0, 5.0),
        decoration: const BoxDecoration(
          color: TColors.primaryBackground,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Column(
          children: [
            Visibility(
              visible: _isReply,
              child: Container(
                color: TColors.darkerGrey,
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 5.0, 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: _isReply,
                      child: const Text("Talk about your confusion "),
                    ),
                    IconButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primaryBackground),
                      onPressed: () {
                        // Add your logic to send the message
                        setState(() {
                          _isReply = false;
                        });
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: TColors.primaryColor,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /*Picked Image*/

                /*TYPE MESSAGE*/
                Expanded(
                  child: TextField(
                    controller: questionTextFieldController,
                    maxLines: 3,
                    minLines: 1,
                    cursorColor: TColors.primaryColor,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(
                          color: TColors.primaryColor,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _question = value;
                    },
                  ),
                ),
                /*BUTTON CONTROLS IMAGE, KEYBOARD, SEND*/
                AvatarGlow(
                  animate: _isListening,
                  curve: Curves.fastOutSlowIn,
                  glowColor: _isListening
                      ? TColors.primaryColor
                      : TColors.primaryBackground,
                  duration: const Duration(milliseconds: 1000),
                  repeat: true,
                  glowRadiusFactor: 0.2,
                  child: IconButton(
                    onPressed: (){}/*_listen*/,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primaryBackground,
                    ),
                    iconSize: 20,
                    icon: _isListening
                        ? Icon(
                      fill: 1,
                      Icons.mic,
                      color: TColors.primaryColor,
                    )
                        : Icon(
                      fill: 1,
                      Icons.mic_none,
                      color: TColors.primaryColor,
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () {
                    /*if (subjectSelectionVisibility == true) {
                      if (_selectedClassName != "null" &&
                          _selectedSubjectName != "null" &&
                          _question != '') {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                        if (isImagePicked) {
                          setState(() {
                            _lessonComponents.add(
                              generateComponentGettingImageResponse(
                                  context,
                                  _selectedImage!,
                                  userID,
                                  _question,
                                  _selectedSubjectName,
                                  _selectedClassName,
                                  _selectedToolsCode,
                                  _maxLine,
                                  _isMobile),
                            );
                            isImagePicked = false;
                            // Clear the text in the TextField
                            questionTextFieldController.clear();
                            _selectedImage = null;
                            _question = '';
                          });
                        } else if (_isReply) {
                          final Widget component =
                          generateComponentGettingToolsReply(
                            context,
                            userID,
                            _selectedticketId!,
                            _question ?? "what is this",
                            _isMobile,
                          );
                          setState(() {
                            _lessonComponents.add(component);
                            questionTextFieldController.clear();
                            _isReply = false;
                          });
                        } else {
                          setState(() {
                            _lessonComponents.add(
                              generateComponentGettingResponse(
                                  context,
                                  userID,
                                  _question,
                                  _selectedSubjectName,
                                  _selectedClassName,
                                  _selectedToolsCode,
                                  _maxLine,
                                  _isMobile),
                            );
                            // Clear the text in the TextField
                            questionTextFieldController.clear();
                            _selectedImage = null;
                            _isImageSelected = false;
                            _isReply = false;
                            _isNewQuestion = true;
                            _question = '';
                          });
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Center(child: const Text('Wait..')),
                                  content: Text(
                                    'You have to write\n'
                                        '• Your Question\n'
                                        '• Your Class\n'
                                        '• Your Subject\n'
                                        'for our $_selectedToolName tool to work.',
                                  ));
                            });
                      }
                    } else {
                      if (_selectedClassName != "null" && _question != '') {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut);
                        if (isImagePicked) {
                          setState(() {
                            _lessonComponents.add(
                              generateComponentGettingImageResponse(
                                  context,
                                  _selectedImage!,
                                  userID,
                                  _question,
                                  _selectedSubjectName,
                                  _selectedClassName,
                                  _selectedToolsCode,
                                  _maxLine,
                                  _isMobile),
                            );
                            isImagePicked = false;
                            // Clear the text in the TextField
                            questionTextFieldController.clear();
                            _selectedImage = null;
                            _question = '';
                          });
                        } else if (_isReply) {
                          final Widget component =
                          generateComponentGettingToolsReply(
                            context,
                            userID,
                            _selectedticketId!,
                            _question ?? "what is this",
                            _isMobile,
                          );
                          setState(() {
                            _lessonComponents.add(component);
                            questionTextFieldController.clear();
                            _isReply = false;
                          });
                        } else {
                          setState(() {
                            _lessonComponents.add(
                              generateComponentGettingResponse(
                                  context,
                                  userID,
                                  _question,
                                  _selectedSubjectName,
                                  _selectedClassName,
                                  _selectedToolsCode,
                                  _maxLine,
                                  _isMobile),
                            );
                            // Clear the text in the TextField
                            questionTextFieldController.clear();
                            _selectedImage = null;
                            _isImageSelected = false;
                            _isReply = false;
                            _isNewQuestion = true;
                            _question = '';
                          });
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Center(child: const Text('Wait..')),
                                  content: Text(
                                    'You have to write\n'
                                        '• Your Question\n'
                                        '• Your Class\n'
                                        'for our $_selectedToolName tool to work.',
                                  ));
                            });
                      }
                    }*/
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryBackground,
                  ),
                  iconSize: 20,
                  icon: const Icon(
                    fill: 1,
                    Icons.send_rounded,
                    color: TColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



}

