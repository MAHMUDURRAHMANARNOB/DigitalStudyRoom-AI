import 'dart:convert';
import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:digital_study_room/features/ToolsContent/provider/studyToolsProvider.dart';
import 'package:digital_study_room/features/ToolsContent/screens/widgets/reportButton.dart';
import 'package:digital_study_room/utils/constants/colors.dart';
import 'package:digital_study_room/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:markdown_widget/markdown_widget.dart' as MW;
import 'package:speech_to_text/speech_to_text.dart';

import '../../../common/latexGenerator.dart';
import '../../../utils/helpers/helper_function.dart';
import '../../authentication/providers/AuthProvider.dart';
import '../../profile/Providers/SubscriptionStatusProvider.dart';
import '../datamodel/studyToolsDataModel.dart';
import '../datamodel/toolsDataDataModel.dart';
import '../provider/ToolsResponseProvider.dart';
import '../provider/submitReactionProvider.dart';
import '../provider/toolsDataByCodeProvider.dart';
import '../provider/toolsReplyProvider.dart';

class ToolsContentScreen extends StatefulWidget {
  final String? staticToolsCode;
  final String? isClassAvailable;
  final String? isSubjectAvailable;

  const ToolsContentScreen({super.key, this.staticToolsCode, this.isClassAvailable, this.isSubjectAvailable});

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
   StudyToolsProvider? toolsProvider;

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

  late int userID = 1;
  late int _selectedticketId;
  late bool isLoading = true;

  late String _selectedToolsCode;
  late String _selectedToolName = '';
  late String _selectedClassName = 'Select Class';
  late String _selectedSubjectName = 'Select Subject';
  late String _question = '';
  late String _maxLine = '';
  final String _isMobile = 'Y';

  bool maxWordVisibility = false;
  bool subjectSelectionVisibility = false;
  bool mathKeyboardVisibility = false;

  late SpeechToText _speech;
  bool _isListening = false;
  bool toolsFetched = false;
  SubmitReactionProvider submitReactionProvider = SubmitReactionProvider();
  @override
  void initState() {
    super.initState();

    // Initialize toolsProvider in initState
    // final authProvider = context.read<AuthProvider>();
    // Get provider from the widget tree
    Future.microtask(() {
      toolsProvider = context.read<StudyToolsProvider>();
      fetchTools();
    });


    // Fetch tools here once during the widget lifecycle
    // fetchTools();

    _speech = SpeechToText();
  }


  Widget buildChipClass(ToolsDataProvider toolsDataProvider) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: TColors.white,
              title: const Text("Select Class"),
              content: SingleChildScrollView(
                child: Column(
                  children: toolsDataProvider.toolsData?.classList
                      .map((ClassInfo classInfo) {
                    return ListTile(
                      title: Text(classInfo.className),
                      onTap: () {
                        setState(() {
                          _selectedClassName = classInfo.className;
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList() ??
                      [],
                ),
              ),
            );
          },
        );
      },
      child: Chip(
        backgroundColor: TColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),

          side: const BorderSide(
              color: TColors.primaryColor), // Change the border color here
        ),
        label: Text(
          _selectedClassName != "null" ? _selectedClassName : 'Select Class',
          style: const TextStyle(
            color: TColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget buildChipSubjects(ToolsDataProvider toolsDataProvider) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: TColors.white,
              title: const Text("Select Subject"),
              content: SingleChildScrollView(
                child: Column(
                  children: toolsDataProvider.toolsData?.subjectList
                      .map((Subject subject) {
                    return ListTile(
                      title: Text(subject.subjectName),
                      onTap: () {
                        setState(() {
                          _selectedSubjectName = subject.subjectName;
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList() ??
                      [],
                ),
              ),
            );
          },
        );
      },
      child: Chip(
        backgroundColor: TColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
              color: TColors.primaryColor), // Change the border color here
        ),
        label: Text(
          _selectedSubjectName != "null"
              ? _selectedSubjectName
              : 'Select Subject',
          style: TextStyle(
            color: TColors.primaryColor,
          ),
        ),
      ),
    );
  }

  void resetSelectedClassAndSubject() {
    setState(() {
      _selectedClassName = 'null';
      _selectedSubjectName = 'null';
      _isImageSelected = false;
      _selectedImage = null;
    });
  }

  void resetLessonComponent() {
    setState(() {
      _lessonComponents.clear();
    });
  }

  /*COMMON TOOL BUTTONS*/
  ElevatedButton buildToolButton(
      String toolName,
      String toolsCode,
      int toolId,
      String subject,
      String maxWord,
      String mathKeyboard, {
        required VoidCallback onToolSelected,
        bool isSelected = false,
      }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primaryColor,
      ),
      onPressed: () {
        isLoading = false;
        resetSelectedClassAndSubject();
        _scaffoldKey.currentState?.closeEndDrawer();
        onToolSelected();
        setState(() {
          _selectedToolsCode = toolsCode;
          _selectedToolName = toolName;
        });
        if (maxWord == "Y") {
          setState(() {
            maxWordVisibility = true;
          });
        } else {
          setState(() {
            maxWordVisibility = false;
          });
        }
        if (mathKeyboard == "Y") {
          setState(() {
            mathKeyboardVisibility = true;
          });
        } else {
          setState(() {
            mathKeyboardVisibility = false;
          });
        }

        if (subject == "Y") {
          setState(() {
            subjectSelectionVisibility = true;
          });
        } else {
          setState(() {
            subjectSelectionVisibility = false;
          });
        }
      },
      child: Text(
        toolName,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<void> fetchTools() async {
    if (!toolsFetched) {
      await toolsProvider!.fetchTools(userID);

      if (toolsProvider!.tools.isNotEmpty) {
        setState(() {
          isLoading = false;
          toolsFetched = true;
        });

        print("✅ Tools fetched successfully, calling selectToolByCode()");
        await selectToolByCode(widget.staticToolsCode!, toolsProvider!);
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text("ERROR!!"),
            content: Text("Please check your internet connection."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );
        print("❌ No tools available after fetching.");
      }
    }
  }


  /*Future<void> selectToolByCode(
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
  }*/
  /*Future<void> selectToolByCode(
      String toolsCode, StudyToolsProvider toolsProvider) async {
    // Find the corresponding tool in the toolsProvider
    List<StudyToolsDataModel> matchingTools = toolsProvider.tools
        .where((tool) => tool.toolsCode == toolsCode)
        .toList();

    print("Total tools available -> ${toolsProvider.tools.length}");
    print("Matching tools count -> ${matchingTools.length}");

    if (matchingTools.isNotEmpty) {
      isLoading = false;
      StudyToolsDataModel selectedTool = matchingTools.first;

      _scaffoldKey.currentState?.closeEndDrawer();

      print("Selected tool -> ID: ${selectedTool.toolID}, Name: ${selectedTool.toolName}");

      toolsDataProvider.fetchToolsData(userID, selectedTool.toolID);

      setState(() {
        _selectedToolsCode = selectedTool.toolsCode;
        _selectedToolName = selectedTool.toolName;
        maxWordVisibility = selectedTool.maxWord == "Y";
        mathKeyboardVisibility = selectedTool.mathKeyboard == "Y";
      });

    } else {
      // Handle the case when the tool with toolsCode is not found
      print("Error: Tool with toolsCode $toolsCode not found");
      isLoading = false;
      return; // Exit the function early
    }
  }*/
  Future<void> selectToolByCode(
      String toolsCode, StudyToolsProvider toolsProvider) async {

    // print("🔍 Searching for toolCode: $toolsCode in ${toolsProvider.tools.length} tools.");
    //
    // for (var tool in toolsProvider.tools) {
    //   print("🛠 Tool Found: Code -> ${tool.toolsCode}, Name -> ${tool.toolName}");
    // }

    List<StudyToolsDataModel> matchingTools = toolsProvider.tools
        .where((tool) => tool.toolsCode == toolsCode)
        .toList();

    // print("🔎 Matching tools count -> ${matchingTools.length}");

    if (matchingTools.isNotEmpty) {
      print("✅ Tool found: ${matchingTools.first.toolName}");
      isLoading = false;

      StudyToolsDataModel selectedTool = matchingTools.first;
      _scaffoldKey.currentState?.closeEndDrawer();

      toolsDataProvider.fetchToolsData(userID, selectedTool.toolID);

      setState(() {
        _selectedToolsCode = selectedTool.toolsCode;
        _selectedToolName = selectedTool.toolName;
        maxWordVisibility = selectedTool.maxWord == "Y";
        mathKeyboardVisibility = selectedTool.mathKeyboard == "Y";
      });
    } else {
      print("❌ Tool with toolsCode $toolsCode not found in provider.");
      isLoading = false;
    }
  }


  late bool dark;

  final SubscriptionStatusProvider subscriptionStatusProvider =
  SubscriptionStatusProvider();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    dark = THelperFunction.isDarkMode(context);

    userID = authProvider.user!.id;
    toolsProvider = StudyToolsProvider();

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
                backgroundColor: dark?TColors.primaryColor.withOpacity(0.2):TColors.primaryBackground,
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
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            color: TColors.white,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: _lessonComponents.isNotEmpty
                  ? Column(
                children: _lessonComponents,
              )
                  : Container(
                decoration: BoxDecoration(
                  color: TColors.white,
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
      _selectedImage = null;
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
              Visibility(
                visible: widget.isClassAvailable=="Y",
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Consumer<ToolsDataProvider>(
                    builder: (context, toolsDataProvider, child) {
                      return  /*buildDropdownMenuClass()*/  buildChipClass(
                          toolsDataProvider);
                    },
                  ),
                      // Text("Selected Class"),
                ),
              ),
              /*SELECTED SUBJECT*/
              Visibility(
                visible: widget.isSubjectAvailable=="Y",
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Visibility(
                    // visible: subjectSelectionVisibility,
                    child: Consumer<ToolsDataProvider>(
                      builder: (context, toolsDataProvider, child) {
                        return  /*buildDropdownMenuSubjects()*/  buildChipSubjects(
                            toolsDataProvider);
                      },
                    ),
                        // Text("Selected Subject"),
                  ),
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
                        _showImageSourceDialog();
                        setState(() {
                          isImagePicked = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dark?TColors.primaryColor.withOpacity(0.2):TColors.primaryBackground,
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
                          : dark?TColors.primaryColor.withOpacity(0.2):TColors.primaryBackground,
                      duration: const Duration(milliseconds: 1000),
                      repeat: true,
                      glowRadiusFactor: 0.2,
                      child: IconButton(
                        onPressed: _listen ,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: dark?TColors.primaryColor.withOpacity(0.2):TColors.primaryBackground,
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
                        if (_selectedImage != null || _question.isNotEmpty) {
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
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dark?TColors.primaryColor.withOpacity(0.2):TColors.primaryBackground,
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

  void _listen() async {
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

        print("Listening if: $_isListening");
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
  }

  Widget _buildReplyContainer() {
    return Visibility(
      visible: _isReply,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 5.0, 5.0),
        decoration: const BoxDecoration(
          // color: TColors.primaryBackground,
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
                // color: TColors.darkerGrey,
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
                    onPressed: () {} /*_listen*/,
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
                    if (subjectSelectionVisibility == true) {
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
                    }
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

  Future<File?> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _cropImage(pickedFile.path);
      setState(() {
        _isImageSelected = true;
      });

      print("file picked ${pickedFile.path}");
      return File(pickedFile.path);
    } else {
      print("nothing picked");
      return null;
    }
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primaryColor.withOpacity(0.1)),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _pickImage(context, ImageSource.gallery);
                  },
                  child: Text(
                    'Pick from Gallery',
                    style: TextStyle(color: TColors.primaryColor),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.primaryColor.withOpacity(0.1)),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _pickImage(context, ImageSource.camera);
                  },
                  child: Text(
                    'Capture from Camera',
                    style: TextStyle(color: TColors.primaryColor),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _cropImage(String imagePath) async {
    print("File is here $imagePath");
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: TColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      // Do something with the cropped image (e.g., display, upload, etc.)
      // You can use croppedFile.path to get the path of the cropped image.
      setState(() {
        _selectedImage = File(croppedFile.path);
      });
    }
  }

  Widget generateComponentGettingResponse(
      BuildContext context,
      int userid,
      String question,
      String selectedSubject,
      String selectedClass,
      String selectedToolsCode,
      String maxLine,
      String isMobile) {
    bool _isPressed = false;
    final toolsResponseProvider =
        Provider.of<ToolsResponseProvider>(context, listen: false);
    return FutureBuilder<void>(
      future: toolsResponseProvider.fetchToolsResponse(userid, question,
          selectedSubject, selectedClass, selectedToolsCode, maxLine, isMobile),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /*return const SpinKitThreeInOut(
            color: TColors.primaryColor,
          );*/
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
                      'Preparing...',
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
              color: TColors.primaryColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Sorry: ${toolsResponseProvider.toolsResponse!.message ?? "Server error"}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          if (toolsResponseProvider.toolsResponse != null &&
              toolsResponseProvider.toolsResponse!.errorCode == 200) {
            final response = toolsResponseProvider.toolsResponse;
            final lessonAnswerEncoded = response!.answer;
            final lessonAnswer =
                utf8.decode(lessonAnswerEncoded!.runes.toList());

            final ticketId = response.ticketId!;
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                // color: TColors.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /*Top Part*/
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: TColors.primaryColor),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Question:",
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TColors.primaryColor,
                          ),
                        ),
                        Text(
                          "$question",
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: TColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: TSizes.sm),
                  Container(
                    width: double.infinity,
                    // margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      // color: dark?TColors.black:TColors.primaryColor,
                      border: Border.all(
                          color: TColors.tertiaryColor),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: MW.MarkdownWidget(
                      data: lessonAnswer,
                      shrinkWrap: true,
                      selectable: true,
                      config: MarkdownConfig.defaultConfig,
                      markdownGenerator: MarkdownGenerator(
                          generators: [latexGenerator],
                          inlineSyntaxList: [LatexSyntax()]),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                TColors.primaryColor.withOpacity(0.1),
                          ),
                          onPressed: () {
                            setState(() {
                              _isReply = true;
                              _isNewQuestion = false;
                              _selectedticketId = ticketId!;
                            });
                          },
                          child: Text(
                            "Reply",
                            style: TextStyle(
                              color: TColors.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 5.0),
                        /*Consumer<SubmitReactionProvider>(
                          builder: (context, submitReactionProvider, _) {
                            return ElevatedButton(
                              onPressed: submitReactionProvider.isLoading ||
                                  submitReactionProvider.isSubmitted
                                  ? null
                                  : () {
                                submitReactionProvider
                                    .fetchSubmitReaction(userid,
                                    response.ticketId, "I", "C");
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  submitReactionProvider.isLoading
                                      ? CircularProgressIndicator()
                                      : Text(
                                    submitReactionProvider.isSubmitted
                                        ? 'Report Submitted'
                                        : 'Report Inappropriate',
                                    style: TextStyle(
                                      color: TColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),*/
                        ReportButton(
                          userId: userid,
                          ticketId: response.ticketId,
                          submitReactionProvider: submitReactionProvider,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: TColors.primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Sorry: ${toolsResponseProvider.toolsResponse!.message}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primaryColor),
                      onPressed: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PackagesScreen()),
                        );*/
                      },
                      child: const Text(
                        "Buy Subscription",
                        style: TextStyle(
                          color: TColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget generateComponentGettingImageResponse(
      BuildContext context,
      File questionImage,
      int userid,
      String question,
      String selectedSubject,
      String selectedClass,
      String selectedToolsCode,
      String maxLine,
      String isMobile) {
    final Future<void> responseFuture =
        toolsResponseProvider.fetchImageToolsResponse(
            questionImage,
            userid,
            question,
            selectedSubject,
            selectedClass,
            selectedToolsCode,
            maxLine,
            isMobile);
    return FutureBuilder<void>(
      future: responseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /*return const SpinKitThreeInOut(
            color: TColors.primaryColor,
          ); */
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
                      'Preparing...',
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
              color: TColors.primaryColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  toolsResponseProvider.toolsResponse != null &&
                          toolsResponseProvider.toolsResponse!.message != null
                      ? Text(
                          "Sorry: ${toolsResponseProvider.toolsResponse!.message}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(
                          "Sorry: You ran out of your Homework-tokens or your subscription is Expired. "),
                  toolsResponseProvider.toolsResponse != null &&
                          toolsResponseProvider.toolsResponse!.errorCode == 201
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: TColors.primaryColor),
                          onPressed: () {
                            /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PackagesScreen()),
                      );*/
                          },
                          child: const Text(
                            "Buy Subscription",
                            style: TextStyle(
                              color: TColors.primaryColor,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        } else {
          if (toolsResponseProvider.toolsResponse != null &&
              toolsResponseProvider.toolsResponse!.errorCode == 200) {
            final response = toolsResponseProvider.toolsResponse;
            final lessonAnswer = response!.answer;
            /*final lessonAnswer =
                utf8.decode(lessonAnswerEncoded!.runes.toList());*/
            final ticketId = response.ticketId!;

            return Container(
              width: double.infinity,
              // Your 'T' case UI code
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                // color: TColors.primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Top Part*/
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: TColors.primaryColor)
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Question",
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TColors.primaryColor,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(5.0),
                          width: double.infinity,
                          height: 100,
                          child: Image.file(
                            questionImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Text("$question"),
                  ),
                  Container(
                    // margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      // color: dark?TColors.black:TColors.primaryColor,
                      border: Border.all(color: TColors.tertiaryColor),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: MW.MarkdownWidget(
                      data: lessonAnswer!,
                      shrinkWrap: true,
                      selectable: true,
                      config: MarkdownConfig.defaultConfig.copy(),
                      markdownGenerator: MarkdownGenerator(

                          generators: [latexGenerator],
                          inlineSyntaxList: [LatexSyntax()]),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                TColors.primaryColor.withOpacity(0.1),
                          ),
                          onPressed: () {
                            setState(() {
                              _isReply = true;
                              _isNewQuestion = false;
                              _selectedticketId = ticketId;
                            });
                          },
                          child: Text(
                            "Reply",
                            style: TextStyle(
                              color: TColors.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        /*Consumer<SubmitReactionProvider>(
                          builder: (context, submitReactionProvider, _) {
                            return ElevatedButton(
                              onPressed: submitReactionProvider.isLoading ||
                                  submitReactionProvider.isSubmitted
                                  ? null
                                  : () {
                                submitReactionProvider
                                    .fetchSubmitReaction(userid,
                                    response.ticketId, "I", "C");
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  submitReactionProvider.isLoading
                                      ? CircularProgressIndicator()
                                      : Text(
                                    submitReactionProvider.isSubmitted
                                        ? 'Report Submitted'
                                        : 'Report Inappropriate',
                                    style: TextStyle(
                                      color: TColors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),*/
                        ReportButton(
                          userId: userid,
                          ticketId: response.ticketId,
                          submitReactionProvider: submitReactionProvider,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: TColors.primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Sorry: ${toolsResponseProvider.toolsResponse!.message}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primaryColor),
                      onPressed: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PackagesScreen()),
                        );*/
                      },
                      child: const Text(
                        "Buy Subscription",
                        style: TextStyle(
                          color: TColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget generateComponentGettingToolsReply(BuildContext context, int userid,
      int ticketId, String question, String isMobile) {
    // Capture the required values before calling setState

    final Future<void> responseFuture = toolsReplyProvider.fetchToolsReply(
        userid, ticketId, question, isMobile);
    late String? lessonAnswer = "";

    return FutureBuilder<void>(
      future: responseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          /*return const SpinKitThreeInOut(
            color: TColors.primaryColor,
          );*/
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
                      'Preparing...',
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
          );
        } else if (snapshot.hasError) {
          return Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: TColors.primaryColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Sorry: ${toolsReplyProvider.toolsResponse!.message}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  toolsReplyProvider.toolsResponse!.errorCode == 201
                      ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.primaryColor),
                    onPressed: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PackagesScreen()),
                      );*/
                    },
                    child: const Text(
                      "Buy Subscription",
                      style: TextStyle(
                        color: TColors.primaryColor,
                      ),
                    ),
                  )
                      : Container(),
                ],
              ),
            ),
          );
        } else {
          if (toolsReplyProvider.toolsResponse != null &&
              toolsReplyProvider.toolsResponse!.errorCode == 200) {
            final response = toolsReplyProvider.toolsResponse;
            final lessonAnswerEncoded = response!.answer;
            final lessonAnswer =
            utf8.decode(lessonAnswerEncoded!.runes.toList());

            // UI components with captured values
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                // color: TColors.primaryBackground,
                borderRadius: BorderRadius.circular(10.0),
              ),
              // Your 'T' case UI code
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Top Part*/
                  /*Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(5.0),
                  width: double.infinity,
                  child: Image.file(
                    questionImage,
                    fit: BoxFit.contain,
                  ),
                ),*/
                  Container(
                    width: double.infinity,
                    child: Text(
                      "$question",
                      softWrap: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: TColors.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    // margin: const EdgeInsets.all(10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      // color: dark?TColors.black:TColors.primaryColor,
                      border: Border.all(
                          color: TColors.tertiaryColor),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child:
                    MW.MarkdownWidget(
                      data: lessonAnswer,
                      shrinkWrap: true,
                      selectable: true,
                      config: MarkdownConfig.defaultConfig,
                      markdownGenerator: MarkdownGenerator(
                          generators: [latexGenerator],
                          inlineSyntaxList: [LatexSyntax()]),
                    ),
                  ),
                  /*SizedBox(
                  height: 5.0,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              TColors.primaryColor.withOpacity(0.1),
                        ),
                        onPressed: () {
                          setState(() {
                            _isReply = true;
                          });
                        },
                        child: Text(
                          "Reply",
                          style: TextStyle(
                            color: TColors.primaryColor,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              TColors.primaryColor.withOpacity(0.1),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Report Inappropriate",
                          style: TextStyle(
                            color: TColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )*/
                ],
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: TColors.primaryColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Sorry: ${toolsReplyProvider.toolsResponse!.message}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primaryColor.withOpacity(0.5)),
                      onPressed: () {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PackagesScreen()),
                        );*/
                      },
                      child: const Text(
                        "Buy Subscription",
                        style: TextStyle(
                          color: TColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
