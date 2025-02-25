import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:markdown_widget/markdown_widget.dart' as MW;

import '../../../common/latexGenerator.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../provider/SolveBanglaMathProvider.dart';

class SolveBanglaMathScreen extends StatefulWidget {
  const SolveBanglaMathScreen({super.key});

  @override
  State<SolveBanglaMathScreen> createState() => _SolveBanglaMathScreenState();
}

class _SolveBanglaMathScreenState extends State<SolveBanglaMathScreen> {

  List<Widget> _lessonComponents = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController questionTextFieldController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  late SolveBanglaMathResponseProvider toolsResponseProvider =
  Provider.of<SolveBanglaMathResponseProvider>(context, listen: false);

  File? _selectedImage;
  bool _isImageSelected = false;
  bool isSelected = false;
  bool isImagePicked = false;

  bool _isReply = false;
  bool _isNewQuestion = false;

  late int userID;
  late String gradeClass;
  late bool isLoading = true;

  late String _question = '';

  late SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();

    _speech = SpeechToText();
  }

  @override
  Widget build(BuildContext context) {

    userID = /*Provider.of<AuthProvider>(context, listen: false).user!.id*/1;
    gradeClass = /*Provider.of<AuthProvider>(context, listen: false).user!.id*/"9";
    return Scaffold(
      appBar: AppBar(
        title: Text("গণিত সমাধান"),
        centerTitle: true,
      ),
      floatingActionButton: Visibility(
        visible: !_isNewQuestion,
        child: !_lessonComponents.isEmpty
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
          backgroundColor:TColors.primaryBackground,
        )
            : Container(),
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
            // color: Colors.grey[100],
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: _lessonComponents.isNotEmpty
                  ? Column(
                children: _lessonComponents,
              )
                  : Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    // question
                    Column(
                      children: [
                        TextFormField(
                          maxLines: 3,
                          controller: questionTextFieldController,
                          cursorColor: TColors.primaryColor,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: TColors.primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            labelText: "Enter your problem",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            _question = value;
                          },
                        ),
                        SizedBox(height: 10.0),
                        if (_selectedImage != null)
                          Visibility(
                            visible: _isImageSelected,
                            child: Stack(
                              children: [
                                ClipPath(
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(12.0),
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
                                        color: Colors
                                            .red, // Background color of the button
                                      ),
                                      padding:
                                      const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        // Color of the icon
                                        size: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 10.0),
                        TextButton.icon(
                          onPressed: () {
                            _showImageSourceDialog();
                            print(isImagePicked);
                            setState(() {
                              isImagePicked = true;
                            });
                          },
                          icon: Icon(
                            Iconsax.gallery_add,
                            color: TColors.secondaryColor,
                          ),
                          label: Text(
                            "Add Image",
                            style: TextStyle(
                                color: TColors.secondaryColor),
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),

                    TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: TColors.primaryColor),
                      onPressed: () {
                        setState(() {
                          if(_selectedImage != null &&
                              isImagePicked){
                            _lessonComponents.add(
                              generateSolveBanglaMathImageResponse(
                                context,
                                _selectedImage!,
                                userID,
                                gradeClass,
                                _question,
                              ),
                            );
                          }else{
                            _lessonComponents.add(
                              generateMathSolutionResponse(
                                context,
                                userID,
                                gradeClass,
                                _question,
                              ),
                            );
                          }




                          questionTextFieldController.clear();
                          _selectedImage = null;
                          _isImageSelected = false;
                          isImagePicked = false;
                          _question = '';
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10.0),
                        child: const Text(
                          "Advice Me",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Text(
                      "N.B: We do not store any of you personal information",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: _isNewQuestion,
          child: newQuestionBarWidget(),
        )
      ],
    );
  }

  Widget newQuestionBarWidget() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // question
          _lessonComponents.isNotEmpty
              ?Column(
            children: [
              TextFormField(
                maxLines: 3,
                controller: questionTextFieldController,
                cursorColor: TColors.primaryColor,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: TColors.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  labelText: "Enter your problem",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _question = value;
                },
              ),
              SizedBox(height: 10.0),
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
                              color: Colors
                                  .red, // Background color of the button
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              // Color of the icon
                              size: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 10.0),
              TextButton.icon(
                onPressed: () {
                  _showImageSourceDialog();
                  print(isImagePicked);
                  setState(() {
                    isImagePicked = true;
                  });
                },
                icon: Icon(
                  Iconsax.gallery_add,
                  color: TColors.secondaryColor,
                ),
                label: Text(
                  "Add Image",
                  style: TextStyle(color: TColors.secondaryColor),
                ),
              ),
              SizedBox(height: 10.0),
            ],
          ):Container(),

          TextButton(
            style: TextButton.styleFrom(backgroundColor: TColors.primaryColor),
            onPressed: () {
              setState(() {
                if(_selectedImage != null &&
                    isImagePicked){
                  _lessonComponents.add(
                    generateSolveBanglaMathImageResponse(
                      context,
                      _selectedImage!,
                      userID,
                      gradeClass,
                      _question,
                    ),
                  );
                }else{
                  _lessonComponents.add(
                    generateMathSolutionResponse(
                      context,
                      userID,
                      gradeClass,
                      _question,
                    ),
                  );
                }




                questionTextFieldController.clear();
                _selectedImage = null;
                _isImageSelected = false;
                isImagePicked = false;
                _isReply = false;
                _isNewQuestion = false;
                _question = '';
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: const Text(
                "Advice Me",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Text(
            "N.B: We do not store any of you personal information",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget generateMathSolutionResponse(
      BuildContext context,
      int userid,
      String gradeClass,
      String problemText,
      ) {
    bool _isPressed = false;
    final toolsResponseProvider =
    Provider.of<SolveBanglaMathResponseProvider>(context, listen: false);
    return FutureBuilder<void>(
      future:
      toolsResponseProvider.fetchMathSolutionResponse(userid, gradeClass, problemText),
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
                    width: 40,
                    height: 40,
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
              color: TColors.primaryColor.withOpacity(0.5),
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
            final question = toolsResponseProvider.toolsResponse!.question;

            // final ticketId = response.ticketId!;
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                // color: TColors.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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

                ],
              ),
            );
          } else {
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

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
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

  Widget generateSolveBanglaMathImageResponse(
      BuildContext context,
      File questionImage,
      int userid,
      String gradeClass,
      String question,
      ) {
    final Future<void> responseFuture =
    toolsResponseProvider.fetchMathImageSolutionResponse(
      questionImage,
      userid,
      gradeClass,
      question,
    );
    return FutureBuilder<void>(
      future: responseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {

          return Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
                  child: Image.asset(
                    "assets/images/animations/loader_tlh.gif",
                    width: 40,
                    height: 40,
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
          if (toolsResponseProvider.solveBanglaMathDataModel != null &&
              toolsResponseProvider.solveBanglaMathDataModel!.errorCode ==
                  200) {
            final response = toolsResponseProvider.solveBanglaMathDataModel;
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

                ],
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(5.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: TColors.primaryBackground,
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
                          backgroundColor: TColors.primaryBackground),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //       const SubscriptionListScreen()),
                        // );
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
