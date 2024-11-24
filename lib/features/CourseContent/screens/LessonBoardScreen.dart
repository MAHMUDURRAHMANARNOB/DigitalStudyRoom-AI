import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/markdown.dart';

import '../../../utils/constants/colors.dart';

class LessonBoardScreen extends StatefulWidget {
  final String lessonTitle;

  const LessonBoardScreen({super.key, required this.lessonTitle});

  @override
  State<LessonBoardScreen> createState() => _LessonBoardScreenState();
}

class _LessonBoardScreenState extends State<LessonBoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  Widget _buildTabBar() {
    return TabBar(
      dividerColor: Colors.transparent,
      controller: _tabController,
      indicatorColor: TColors.primaryColor,
      labelColor: TColors.primaryColor,
      splashFactory: NoSplash.splashFactory,
      unselectedLabelColor: TColors.darkGrey,
      tabs: const [
        Tab(text: 'Lesson'),
        Tab(text: 'Videos'),
        Tab(text: 'Questions'),
      ],
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          // _buildAnswerSheet(),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height, // Define height here
            child: _lessonContent(),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height, // Define height here
            child: _videoContent(),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height, // Define height here
            child: _questionContent(),
          ),
        ],
      ),
    );
  }

  final config = MarkdownConfig.defaultConfig;

  Widget _lessonContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: MarkdownWidget(
        data: """**Lesson 1: Introduction to Python**

**Objectives:**

  * Understand the basic concepts of Python programming.
  * Set up the Python environment.
  * Write simple Python programs.

**What is Python?**

  * A high-level, interpreted programming language.
  * Known for its readability and simplicity.
  * Used in various fields, including data science, web development, and machine learning.

**Why Python?**

  * **Readability:** Python code is easy to read and understand.
  * **Versatility:** It can be used for a wide range of tasks.
  * **Large community:** A strong community provides support and resources.
  * **Standard library:** A rich library of modules for various tasks.

**Setting Up the Environment:**

1.  **Install Python:**
      - Download the latest version from the official Python website ([https://www.python.org/](https://www.google.com/url?sa=E&source=gmail&q=https://www.python.org/)).
      - Follow the installation instructions for your operating system.
2.  **Choose an IDE:**
      - An Integrated Development Environment (IDE) provides a user-friendly interface for writing and running Python code.
      - Popular choices include:
          - **Visual Studio Code:** A lightweight and customizable IDE.
          - **PyCharm:** A powerful IDE with advanced features.
          - **Thonny:** A simple and beginner-friendly IDE.

**Basic Syntax and Structure:**

  * **Indentation:** Python uses indentation to define code blocks.
  * **Comments:** Use `#` to add comments to your code.
  * **Variables:**
      - Declare variables without specifying a data type.
      - Use meaningful variable names.
      - Examples:
        ```python
        x = 10  # Integer
        name = "Alice"  # String
        is_student = True  # Boolean
        ```
  * **Operators:**
      - Arithmetic operators: `+`, `-`, `*`, `/`, `//`, `%`, `**`
      - Comparison operators: `==`, `!=`, `<`, `>`, `<=`, `>=`
      - Logical operators: `and`, `or`, `not`

**Input and Output:**

  * **`print()` function:**
      - Used to display output on the console.
      - Example:
        ```python
        print("Hello, world!")
        ```
  * **`input()` function:**
      - Used to get input from the user.
      - Example:
        ```python
        name = input("Enter your name: ")
        print("Hello,", name)
        ```

**Practice Exercise:**

Write a Python program to calculate the area of a circle.

**Additional Tips:**

  * Start with simple programs and gradually increase complexity.
  * Break down complex problems into smaller, manageable steps.
  * Experiment with different code snippets and learn from errors.
  * Practice regularly to improve your skills.

**Next Lesson:** Control Flow""",
        config: config,
      ),


      // After the Markdown widget, display the other lesson components
    );
  }
  Widget _questionContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10.0),
      child: MarkdownWidget(
        data: """**Quiz Questions for Module 1: Introduction to Python**

**Multiple Choice Questions:**

1. **What is Python?**
   * A low-level programming language
   * A compiled language
   * A high-level, interpreted language
   * A machine language

2. **Which of the following is NOT a valid Python variable name?**
   * my_variable
   * 123variable
   * myVariable
   * _my_variable

3. **What is the output of the following code?**
   ```python
   print("Hello, world!")
   ```
   * Hello, world!
   * "Hello, world!"
   * An error message
   * Nothing

4. **Which operator is used to perform integer division in Python?**
   * /
   * //
   * %
   * **

5. **What is the purpose of the `input()` function?**
   * To print output to the console
   * To read input from the user
   * To define a function
   * To create a variable

**True/False Questions:**

1. Python is case-sensitive.
2. Indentation is optional in Python.
3. The `print()` function can take multiple arguments.
4. Comments are ignored by the Python interpreter.

**Short Answer Questions:**

1. What are the basic data types in Python?
2. Explain the difference between `=` and `==` operators.
3. Write a Python program to calculate the area of a rectangle.
4. How do you write a multi-line comment in Python?

**Programming Problem:**

Write a Python program to swap the values of two variables without using a temporary variable.
""",
        config: config,
      ),


      // After the Markdown widget, display the other lesson components
    );
  }

  Widget _videoContent() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount:
          // ieltsCourseLessonProvider.ieltsCourseLessonResponse!.videoList.length,
          3,
      itemBuilder: (context, index) {
        /*final video = ieltsCourseLessonProvider
            .ieltsCourseLessonResponse!.videoList[index];*/

        return GestureDetector(
          onTap: () {
            // Fluttertoast.showToast(msg: video.lessonId.toString());
            /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoPlayerBoard(
                      videoUrl: video.videoUrl,
                      videoTitle: video.videoTitle,
                      isVideo: "Y",
                      lessonContentId: video.videoId)),
            );*/
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: TColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/dashboard_images/scanner.png",
                  width: 34,
                  height: 34,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        /*video.videoTitle*/
                        "TITLE",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 1,
                          ),
                          Text(
                            "Duration: ${/*video.videoDuration*/ "100"} minutes",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.lessonTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTabBar(),
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }
}
